import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:health_managment_system/data/data_sources/remote/health_programs/health_programs_remote_datasource_interface.dart';
import 'package:health_managment_system/data/models/health_program_model.dart';
import 'package:health_managment_system/errors/failures.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';

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
  Future<Either<Failure, HealthProgramModel>> createHealthProgram({
    required String name,
    required String description,
    required String startDate,
    String? endDate,
    String? imagePath,
    Map<String, dynamic>? eligibilityCriteria,
  }) async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      return Left(AuthenticationFailure('No token found'));
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
        'eligibility_criteria': eligibilityCriteria,
      }),
    );

    if (response.statusCode == 201) {
      return Right(HealthProgramModel.fromMap(healthProgramMap: jsonDecode(response.body)));
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to create health program';
      return Left(ServerFailure(error, statusCode: response.statusCode));
    }
  }

  @override
  Future<Either<Failure, HealthProgramModel>> getHealthProgram(int healthProgramId) async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      return Left(AuthenticationFailure('No token found'));
    }

    final response = await client.get(
      Uri.parse('$baseUrl/v1/health-programs/$healthProgramId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Right(HealthProgramModel.fromMap(healthProgramMap: jsonDecode(response.body)));
    } else if (response.statusCode == 404) {
      return Left(NotFoundFailure(jsonDecode(response.body)['error'], statusCode: response.statusCode));
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to fetch health program';
      return Left(ServerFailure(error, statusCode: response.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<HealthProgramModel>>> getAllHealthPrograms({int page = 1, int limit = 10}) async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      return Left(AuthenticationFailure('No token found'));
    }

    final response = await client.get(
      Uri.parse('$baseUrl/v1/health-programs?page=$page&limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return Right(data.map((healthProgramData) => HealthProgramModel.fromMap(healthProgramMap: healthProgramData)).toList());
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to fetch health programs';
      return Left(ServerFailure(error, statusCode: response.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<HealthProgramModel>>> searchHealthPrograms({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      return Left(AuthenticationFailure('No token found'));
    }

    final response = await client.get(
      Uri.parse('$baseUrl/v1/health-programs/search?query=$query&page=$page&limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return Right(data.map((healthProgramData) => HealthProgramModel.fromMap(healthProgramMap: healthProgramData)).toList());
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to search health programs';
      return Left(ServerFailure(error, statusCode: response.statusCode));
    }
  }

  @override
  Future<Either<Failure, int>> deleteHealthProgram(int healthProgramId) async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      return Left(AuthenticationFailure('No token found'));
    }

    final response = await client.delete(
      Uri.parse('$baseUrl/v1/health-programs/$healthProgramId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Right(jsonDecode(response.body)['id']);
    } else if (response.statusCode == 404) {
      return Left(NotFoundFailure(jsonDecode(response.body)['error'], statusCode: response.statusCode));
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to delete health program';
      return Left(ServerFailure(error, statusCode: response.statusCode));
    }
  }
}
