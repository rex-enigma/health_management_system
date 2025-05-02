import 'package:health_managment_system/data/models/client_model.dart';
import 'package:dartz/dartz.dart';
import 'package:health_managment_system/errors/failures.dart';

abstract class ClientsRemoteDataSource {
  Future<Either<Failure, ClientModel>> createClient({
    required String firstName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
    required String contactInfo,
    String? address,
    String? profileImagePath,
    required List<String> diagnosisNames,
  });

  Future<Either<Failure, List<ClientModel>>> getAllClients({int page = 1, int limit = 10});

  Future<Either<Failure, List<ClientModel>>> searchClients({
    required String query,
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, ClientModel>> getClient(int id);

  Future<Either<Failure, Unit>> enrollClient(int clientId, List<int> healthProgramIds);

  Future<Either<Failure, int>> deleteClient(int clientId);
}
