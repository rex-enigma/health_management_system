import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:health_managment_system/data/data_sources/remote/clients/clients_remote_datasource_interface.dart';
import 'package:health_managment_system/data/models/client_model.dart';
import 'package:health_managment_system/enums/diagnosis.dart';
import 'package:health_managment_system/errors/exceptions.dart';
import 'package:http/http.dart' as http;

class ClientsRemoteDataSourceImpl implements ClientsRemoteDataSource {
  late http.Client client;
  late FlutterSecureStorage secureStorage;
  late String baseUrl;

  ClientsRemoteDataSourceImpl({http.Client? client, FlutterSecureStorage? flutterSecureStorage, String? baseUrl}) {
    client = client ?? http.Client();
    flutterSecureStorage = flutterSecureStorage ?? FlutterSecureStorage();
    baseUrl = baseUrl ?? dotenv.env['BASE_URL'] as String;
  }

  @override
  Future<ClientModel> createClient({
    required String firstName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
    required String contactInfo,
    String? address,
    String? profileImagePath,
    required List<String> diagnosisNames,
  }) async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      throw AuthenticationException('No token found');
    }

    final response = await client.post(
      Uri.parse('$baseUrl/v1/clients'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
        'date_of_birth': dateOfBirth,
        'contact_info': contactInfo,
        'address': address,
        'profile_image_path': profileImagePath,
        'diagnosis_names': diagnosisNames,
      }),
    );

    if (response.statusCode == 201) {
      return ClientModel.fromMap(clientMap: jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to create client';
      throw ServerException(error, statusCode: response.statusCode);
    }
  }

  @override
  Future<List<ClientModel>> getAllClients({int page = 1, int limit = 10}) async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      throw AuthenticationException('No token found');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/v1/clients?page=$page&limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((clientData) => ClientModel.fromMap(clientMap: clientData)).toList();
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to fetch clients';
      throw ServerException(error, statusCode: response.statusCode);
    }
  }

  @override
  Future<List<ClientModel>> searchClients({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      throw AuthenticationException('No token found');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/v1/clients/search?query=$query&page=$page&limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((map) => ClientModel.fromMap(clientMap: map)).toList();
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to search clients';
      throw ServerException(error, statusCode: response.statusCode);
    }
  }

  @override
  Future<ClientModel> getClient(int id) async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      throw AuthenticationException('No token found');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/v1/clients/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ClientModel.fromMap(clientMap: jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to fetch client';
      throw ServerException(error, statusCode: response.statusCode);
    }
  }

  @override
  Future<void> enrollClient(int clientId, List<int> healthProgramIds) async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      throw AuthenticationException('No token found');
    }

    final response = await client.post(
      Uri.parse('$baseUrl/v1/clients/$clientId/enroll'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'health_program_ids': healthProgramIds,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to enroll client';
      throw ServerException(error, statusCode: response.statusCode);
    }
  }

  @override
  Future<int> deleteClient(int clientId) async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      throw AuthenticationException('No token found');
    }

    final response = await client.delete(
      Uri.parse('$baseUrl/v1/clients/$clientId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['id'];
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to delete client';
      throw ServerException(error, statusCode: response.statusCode);
    }
  }
}
