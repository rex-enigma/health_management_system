import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:health_managment_system/data/data_sources/remote/health_programs/health_programs_remote_datasource_imp.dart';
import 'package:health_managment_system/data/models/health_program_model.dart';
import 'package:health_managment_system/domain/entities/health_program_entity.dart';
import 'package:health_managment_system/errors/exceptions.dart';
import 'package:http/http.dart' as http;

class HealthProgramsRemoteDataSourceImpl implements HealthProgramsRemoteDataSource {
  late http.Client client;
  late FlutterSecureStorage secureStorage;
  late String baseUrl;

  HealthProgramsRemoteDataSourceImpl({http.Client? client, FlutterSecureStorage? flutterSecureStorage, String? baseUrl}) {
    client = client ?? http.Client();
    flutterSecureStorage = flutterSecureStorage ?? FlutterSecureStorage();
    baseUrl = baseUrl ?? dotenv.env['BASE_URL'] as String;
  }

  @override
  Future<HealthProgramModel> createHealthProgram({
    required String name,
    required String description,
    required String startDate,
    String? endDate,
    String? imagePath,
    EligibilityCriteria? eligibilityCriteria,
  }) async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      throw AuthenticationException('No token found');
    }

    final response = await client.post(
      Uri.parse('$baseUrl/v1/health-programs'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'start_date': startDate,
        'end_date': endDate,
        'image_path': imagePath,
        'eligibility_criteria': eligibilityCriteria?.toJson(),
      }),
    );

    if (response.statusCode == 201) {
      return HealthProgramModel.fromMap(healthProgramMap: jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to create health program';
      throw ServerException(error, statusCode: response.statusCode);
    }
  }

  @override
  Future<HealthProgramModel> getHealthProgram(int healthProgramId) async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      throw AuthenticationException('No token found');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/v1/health-programs/$healthProgramId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return HealthProgramModel.fromMap(healthProgramMap: jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to fetch health program';
      throw ServerException(error, statusCode: response.statusCode);
    }
  }

  @override
  Future<List<HealthProgramModel>> getAllHealthPrograms({int page = 1, int limit = 10}) async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      throw AuthenticationException('No token found');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/v1/health-programs?page=$page&limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((healthProgramData) => HealthProgramModel.fromMap(healthProgramMap: healthProgramData)).toList();
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to fetch health programs';
      throw ServerException(error, statusCode: response.statusCode);
    }
  }

  @override
  Future<List<HealthProgramModel>> searchHealthPrograms({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      throw AuthenticationException('No token found');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/v1/health-programs/search?query=$query&page=$page&limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((healthProgramData) => HealthProgramModel.fromMap(healthProgramMap: healthProgramData)).toList();
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to search health programs';
      throw ServerException(error, statusCode: response.statusCode);
    }
  }

  @override
  Future<int> deleteHealthProgram(int healthProgramId) async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      throw AuthenticationException('No token found');
    }

    final response = await client.delete(
      Uri.parse('$baseUrl/v1/health-programs/$healthProgramId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['id'];
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to delete health program';
      throw ServerException(error, statusCode: response.statusCode);
    }
  }
}
