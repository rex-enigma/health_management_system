import 'package:dartz/dartz.dart';
import 'package:health_managment_system/domain/entities/user_entity.dart';
import 'package:health_managment_system/errors/failures.dart';

abstract class UsersRepo {
  Future<Either<Failure, UserEntity>> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
    String? profileImagePath,
  });

  Future<Either<Failure, UserEntity>> login(String email, String password);
}
