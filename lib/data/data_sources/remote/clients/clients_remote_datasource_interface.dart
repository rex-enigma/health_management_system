import 'package:health_managment_system/data/models/client_model.dart';
import 'package:health_managment_system/enums/diagnosis.dart';

abstract class ClientsRemoteDataSource {
  Future<ClientModel> createClient({
    required String firstName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
    required String contactInfo,
    String? address,
    String? profileImagePath,
    required List<String> diagnosisNames,
  });

  Future<List<ClientModel>> getAllClients({int page = 1, int limit = 10});

  Future<List<ClientModel>> searchClients({
    required String query,
    int page = 1,
    int limit = 10,
  });

  Future<ClientModel> getClient(int id);

  Future<void> enrollClient(int clientId, List<int> healthProgramIds);

  Future<void> deleteClient(int clientId);
}
