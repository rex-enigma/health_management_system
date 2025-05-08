import 'package:dartz/dartz.dart';
import 'package:health_managment_system/domain/entities/client_entity.dart';
import 'package:health_managment_system/errors/failures.dart';

abstract class ClientsRepo {
  Future<Either<Failure, ClientEntity>> createClient({
    required String firstName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
    required String contactInfo,
    String? address,
    String? profileImagePath,
    required List<int> diagnosisIds,
  });

  Future<Either<Failure, List<ClientEntity>>> getAllClients({
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, List<ClientEntity>>> searchClients({
    required String query,
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, ClientEntity>> getClient(int clientId);

  Future<Either<Failure, Unit>> enrollClient(int clientId, List<int> healthProgramIds);

  Future<Either<Failure, int>> deleteClient(int clientId);
}
