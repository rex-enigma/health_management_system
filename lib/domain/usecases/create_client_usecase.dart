import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/repositories/clients/clients_repo_imp.dart';
import 'package:health_managment_system/domain/entities/client.dart';
import 'package:health_managment_system/domain/repository_interface/clients/clients_repo_interface.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/errors/failures.dart';

class CreateClientUseCase implements UseCase<Either<Failure, ClientEntity>, CreateClientParams> {
  final ClientsRepo _clientsRepo;

  CreateClientUseCase({ClientsRepo? clientsRepo})
      : _clientsRepo = clientsRepo ?? locator<ClientsRepositoryImpl>();

  @override
  Future<Either<Failure, ClientEntity>> call(CreateClientParams params) {
    return _clientsRepo.createClient(
      firstName: params.firstName,
      lastName: params.lastName,
      gender: params.gender,
      dateOfBirth: params.dateOfBirth,
      contactInfo: params.contactInfo,
      address: params.address,
      profileImagePath: params.profileImagePath,
      diagnosisNames: params.diagnosisNames,
    );
  }
}

class CreateClientParams {
  final String firstName;
  final String lastName;
  final String gender;
  final String dateOfBirth;
  final String contactInfo;
  final String? address;
  final String? profileImagePath;
  final List<String> diagnosisNames;

  CreateClientParams({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.contactInfo,
    this.address,
    this.profileImagePath,
    required this.diagnosisNames,
  });
}
