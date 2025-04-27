import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:health_managment_system/data/data_sources/remote/users/users_remote_datasource_interface.dart';
import 'package:health_managment_system/errors/failures.dart';
import 'package:health_managment_system/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  late http.Client client;
  late FlutterSecureStorage flutterSecureStorage;
  late String baseUrl;

  UsersRemoteDataSourceImpl({http.Client? client, FlutterSecureStorage? flutterSecureStorage, String? baseUrl}) {
    client = client ?? http.Client();
    flutterSecureStorage = flutterSecureStorage ?? FlutterSecureStorage();
    baseUrl = baseUrl ?? dotenv.env['BASE_URL'] as String;
  }

  @override
  Future<Either<Failure, UserModel>> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
    String? profileImagePath,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/v1/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'phone_number': phoneNumber,
          'profile_image_path': profileImagePath,
        }),
      );

      if (response.statusCode == 201) {
        return Right(UserModel.fromMap(userMap: jsonDecode(response.body)));
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Signup failed';
        return Left(ServerFailure(error, statusCode: response.statusCode));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred during signup'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> login(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/v1/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await flutterSecureStorage.write(key: 'jwt_token', value: data['token']);
        return Right(UserModel.fromMap(userMap: data['user']));
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Login failed';
        return Left(AuthenticationFailure(error));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred during login'));
    }
  }
}
