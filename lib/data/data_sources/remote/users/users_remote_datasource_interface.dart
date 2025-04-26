import 'package:health_managment_system/data/models/user_model.dart';

abstract class UsersRemoteDataSource {
  Future<UserModel> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
    String? profileImagePath,
  });

  Future<Map<String, dynamic>> login(String email, String password);
}
