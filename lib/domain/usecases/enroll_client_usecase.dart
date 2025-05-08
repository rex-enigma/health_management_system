import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/repositories/clients/clients_repo_imp.dart';
import 'package:health_managment_system/domain/repository_interface/clients/clients_repo_interface.dart';
import 'package:health_managment_system/domain/usecases/get_client_usecase.dart';
import 'package:health_managment_system/domain/usecases/get_health_programs_usecase.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/errors/failures.dart';

class EnrollClientUseCase implements UseCase<Either<Failure, Unit>, EnrollClientParams> {
  final ClientsRepo _clientsRepo;

  EnrollClientUseCase({
    GetClientUseCase? getClientUseCase,
    GetHealthProgramUseCase? getHealthProgramUseCase,
    ClientsRepo? clientsRepository,
  }) : _clientsRepo = clientsRepository ?? locator<ClientsRepositoryImpl>();

  @override
  Future<Either<Failure, Unit>> call(EnrollClientParams params) async {
    return await _clientsRepo.enrollClient(params.clientId, params.healthProgramIds);
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
