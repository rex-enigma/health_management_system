import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:health_managment_system/data/data_sources/remote/diagnoses/diagnoses_remote_datasource_interface.dart';
import 'package:health_managment_system/enums/diagnosis.dart';
import 'package:health_managment_system/errors/exceptions.dart';
import 'package:http/http.dart' as http;

class DiagnosesRemoteDataSourceImpl implements DiagnosesRemoteDataSource {
  late http.Client client;
  late FlutterSecureStorage secureStorage;
  late String baseUrl;

  DiagnosesRemoteDataSourceImpl({http.Client? client, FlutterSecureStorage? flutterSecureStorage, String? baseUrl}) {
    client = client ?? http.Client();
    flutterSecureStorage = flutterSecureStorage ?? FlutterSecureStorage();
    baseUrl = baseUrl ?? dotenv.env['BASE_URL'] as String;
  }

  @override
  Future<List<Diagnosis>> getAllDiagnoses({int page = 1, int limit = 10}) async {
    final token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      throw AuthenticationException('No token found');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/v1/diagnoses?page=$page&limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((diagnosis) => Diagnosis.fromString(diagnosis)).toList();
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to fetch diagnoses';
      throw ServerException(error, statusCode: response.statusCode);
    }
  }
}
