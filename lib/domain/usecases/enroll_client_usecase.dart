import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/repositories/clients/clients_repo_imp.dart';
import 'package:health_managment_system/domain/repository_interface/clients/clients_repo_interface.dart';
import 'package:health_managment_system/domain/usecases/get_client_usecase.dart';
import 'package:health_managment_system/domain/usecases/get_health_programs_usecase.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/errors/failures.dart';

class EnrollClientUseCase
    implements UseCase<Either<Failure, Unit>, EnrollClientParams> {
  final GetClientUseCase _getClientUseCase;
  final GetHealthProgramUseCase _getHealthProgramUseCase;
  final ClientsRepo _clientsRepo;

  EnrollClientUseCase({
    GetClientUseCase? getClientUseCase,
    GetHealthProgramUseCase? getHealthProgramUseCase,
    ClientsRepo? clientsRepository,
  })  : _getClientUseCase = getClientUseCase ?? locator<GetClientUseCase>(),
        _getHealthProgramUseCase =
            getHealthProgramUseCase ?? locator<GetHealthProgramUseCase>(),
        _clientsRepo = clientsRepository ?? locator<ClientsRepositoryImpl>();

  @override
  Future<Either<Failure, Unit>> call(EnrollClientParams params) async {
    // Fetch the client
    final clientResult =
        await _getClientUseCase(GetClientParams(id: params.clientId));
    if (clientResult.isRight()) {
      final clientEntity =
          clientResult.fold((failure) => null, (entity) => entity);

      // Check eligibility for each health program and collect ineligible IDs
      final ineligibleHealthProgramIds = <int>[];

      for (final programId in params.healthProgramIds) {
        final programResult = await _getHealthProgramUseCase(
            GetHealthProgramParams(id: programId));
        if (programResult.isRight()) {
          final programEntity =
              programResult.fold((failure) => null, (entity) => entity);

          // Check eligibility
          if (programEntity!.eligibilityCriteria != null &&
              !programEntity.eligibilityCriteria!
                  .isClientEligible(clientEntity!)) {
            ineligibleHealthProgramIds.add(programId);
          }
        }
      }

      // If any programs are ineligible, return failure
      if (ineligibleHealthProgramIds.isNotEmpty) {
        return Left(IneligibleClientFailure(
            ineligibleHealthProgramIds: ineligibleHealthProgramIds));
      }

      // All eligibility checks passed, proceed with enrollment
      return await _clientsRepo.enrollClient(
          params.clientId, params.healthProgramIds);
    } else {
      final failure = clientResult.fold((failure) => failure, (model) => null);
      return Left(failure!);
    }
  }
}

class EnrollClientParams {
  final int clientId;
  final List<int> healthProgramIds;

  EnrollClientParams({
    required this.clientId,
    required this.healthProgramIds,
  });
}
