import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:health_managment_system/data/data_sources/remote/diagnoses/diagnoses_remote_datasource_interface.dart';
import 'package:health_managment_system/enums/diagnosis.dart';
import 'package:health_managment_system/errors/failures.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';

class DiagnosesRemoteDataSourceImpl implements DiagnosesRemoteDataSource {
  late final FlutterSecureStorage flutterSecureStorage;
  late final String baseUrl;

  DiagnosesRemoteDataSourceImpl({
    FlutterSecureStorage? flutterSecureStorage,
    String? baseUrl,
  }) {
    this.flutterSecureStorage = flutterSecureStorage ?? FlutterSecureStorage();
    this.baseUrl = baseUrl ?? dotenv.env['BASE_URL'] as String;
  }

  @override
  Future<Either<Failure, List<Diagnosis>>> getAllDiagnoses(
      {int page = 1, int limit = 10}) async {
    try {
      final token = await flutterSecureStorage.read(key: 'jwt_token');
      if (token == null) {
        return Left(AuthenticationFailure('No token found'));
      }

      final response = await http.get(
        Uri.parse('$baseUrl/v1/diagnoses?page=$page&limit=$limit'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final diagnoses =
            data.map((diagnosis) => Diagnosis.fromString(diagnosis)).toList();
        return Right(diagnoses);
      } else {
        final error =
            jsonDecode(response.body)['error'] ?? 'Failed to fetch diagnoses';
        return Left(ServerFailure(error, statusCode: response.statusCode));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
