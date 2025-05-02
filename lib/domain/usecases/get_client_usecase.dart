import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/repositories/clients/clients_repo_imp.dart';
import 'package:health_managment_system/domain/entities/client.dart';
import 'package:health_managment_system/domain/repository_interface/clients/clients_repo_interface.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/errors/failures.dart';

class GetClientUseCase implements UseCase<Either<Failure, ClientEntity>, GetClientParams> {
  final ClientsRepo _clientsRepo;

  GetClientUseCase({ClientsRepo? clientsRepo})
      : _clientsRepo = clientsRepo ?? locator<ClientsRepositoryImpl>();

  @override
  Future<Either<Failure, ClientEntity>> call(GetClientParams params) {
    return _clientsRepo.getClient(params.id);
  }
}

class GetClientParams {
  final int id;

  GetClientParams({required this.id});
}
