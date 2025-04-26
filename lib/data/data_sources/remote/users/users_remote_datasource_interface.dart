import 'package:health_managment_system/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:health_managment_system/errors/failures.dart';

abstract class UsersRemoteDataSource {
  Future<Either<Failure, UserModel>> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
    String? profileImagePath,
  });

  Future<Either<Failure, UserModel>> login(String email, String password);
}
