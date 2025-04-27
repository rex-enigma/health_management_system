import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:health_managment_system/data/data_sources/remote/clients/clients_remote_datasource_interface.dart';
import 'package:health_managment_system/data/models/client_model.dart';
import 'package:health_managment_system/errors/failures.dart';
import 'package:http/http.dart' as http;

class ClientsRemoteDataSourceImpl implements ClientsRemoteDataSource {
  late http.Client client;
  late FlutterSecureStorage flutterSecureStorage;
  late String baseUrl;

  ClientsRemoteDataSourceImpl({http.Client? client, FlutterSecureStorage? flutterSecureStorage, String? baseUrl}) {
    this.client = client ?? http.Client();
    this.flutterSecureStorage = flutterSecureStorage ?? FlutterSecureStorage();
    this.baseUrl = baseUrl ?? dotenv.env['BASE_URL'] as String;
  }

  @override
  Future<Either<Failure, ClientModel>> createClient({
    required String firstName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
    required String contactInfo,
    String? address,
    String? profileImagePath,
    required List<String> diagnosisNames,
  }) async {
    final token = await flutterSecureStorage.read(key: 'jwt_token');
    if (token == null) {
      return Left(AuthenticationFailure('No token found'));
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
      return Right(ClientModel.fromMap(clientMap: jsonDecode(response.body)));
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to create client';
      return Left(ServerFailure(error, statusCode: response.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<ClientModel>>> getAllClients({int page = 1, int limit = 10}) async {
    final token = await flutterSecureStorage.read(key: 'jwt_token');
    if (token == null) {
      return Left(AuthenticationFailure('No token found'));
    }

    final response = await client.get(
      Uri.parse('$baseUrl/v1/clients?page=$page&limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return Right(data.map((clientData) => ClientModel.fromMap(clientMap: clientData)).toList());
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to fetch clients';
      return Left(ServerFailure(error, statusCode: response.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<ClientModel>>> searchClients({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    final token = await flutterSecureStorage.read(key: 'jwt_token');
    if (token == null) {
      return Left(AuthenticationFailure('No token found'));
    }

    final response = await client.get(
      Uri.parse('$baseUrl/v1/clients/search?query=$query&page=$page&limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return Right(data.map((map) => ClientModel.fromMap(clientMap: map)).toList());
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to search clients';
      return Left(ServerFailure(error, statusCode: response.statusCode));
    }
  }

  @override
  Future<Either<Failure, ClientModel>> getClient(int clientId) async {
    final token = await flutterSecureStorage.read(key: 'jwt_token');
    if (token == null) {
      return Left(AuthenticationFailure('No token found'));
    }

    final response = await client.get(
      Uri.parse('$baseUrl/v1/clients/$clientId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Right(ClientModel.fromMap(clientMap: jsonDecode(response.body)));
    } else if (response.statusCode == 404) {
      return Left(NotFoundFailure(jsonDecode(response.body)['error'], statusCode: response.statusCode));
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to fetch client';
      return Left(ServerFailure(error, statusCode: response.statusCode));
    }
  }

  @override
  Future<Either<Failure, Unit>> enrollClient(int clientId, List<int> healthProgramIds) async {
    final token = await flutterSecureStorage.read(key: 'jwt_token');
    if (token == null) {
      return Left(AuthenticationFailure('No token found'));
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
      return Right(unit);
    } else if (response.statusCode == 404) {
      return Left(NotFoundFailure(jsonDecode(response.body)['error'], statusCode: response.statusCode));
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to enroll client';
      return Left(ServerFailure(error, statusCode: response.statusCode));
    }
  }

  @override
  Future<Either<Failure, int>> deleteClient(int clientId) async {
    final token = await flutterSecureStorage.read(key: 'jwt_token');
    if (token == null) {
      return Left(AuthenticationFailure('No token found'));
    }

    final response = await client.delete(
      Uri.parse('$baseUrl/v1/clients/$clientId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['id'];
    } else if (response.statusCode == 404) {
      return Left(NotFoundFailure(jsonDecode(response.body)['error'], statusCode: response.statusCode));
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to delete client';
      return Left(ServerFailure(error, statusCode: response.statusCode));
    }
  }
}
