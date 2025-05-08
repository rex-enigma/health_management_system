import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/repositories/clients/clients_repo_imp.dart';
import 'package:health_managment_system/domain/repository_interface/clients/clients_repo_interface.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/errors/failures.dart';

class DeleteClientUseCase implements UseCase<Either<Failure, int>, DeleteClientParams> {
  final ClientsRepo _clientsRepo;

  DeleteClientUseCase({ClientsRepo? clientsRepo}) : _clientsRepo = clientsRepo ?? locator<ClientsRepositoryImpl>();

  @override
  Future<Either<Failure, int>> call(DeleteClientParams params) {
    return _clientsRepo.deleteClient(params.id);
  }
}

class DeleteClientParams {
  final int id;

  DeleteClientParams({required this.id});
}
