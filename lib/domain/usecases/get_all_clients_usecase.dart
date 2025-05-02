import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/repositories/clients/clients_repo_imp.dart';
import 'package:health_managment_system/domain/entities/client.dart';
import 'package:health_managment_system/domain/repository_interface/clients/clients_repo_interface.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/errors/failures.dart';

class GetAllClientsUseCase
    implements UseCase<Either<Failure, List<ClientEntity>>, GetAllClientsParams> {
  final ClientsRepo _clientsRepo;

  GetAllClientsUseCase({ClientsRepo? clientsRepo})
      : _clientsRepo = clientsRepo ?? locator<ClientsRepositoryImpl>();

  @override
  Future<Either<Failure, List<ClientEntity>>> call(GetAllClientsParams params) {
    return _clientsRepo.getAllClients(
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetAllClientsParams {
  final int page;
  final int limit;

  GetAllClientsParams({this.page = 1, this.limit = 10});
}
