import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/repositories/users/users_repo_imp.dart';
import 'package:health_managment_system/domain/entities/user_entity.dart';
import 'package:health_managment_system/domain/repository_interface/users/users_repo_interface.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/errors/failures.dart';

class SignupUseCase
    implements UseCase<Either<Failure, UserEntity>, SignupParams> {
  final UsersRepo _usersRepo;

  SignupUseCase({UsersRepo? usersRepo})
      : _usersRepo = usersRepo ?? locator<UsersRepositoryImpl>();

  @override
  Future<Either<Failure, UserEntity>> call(SignupParams params) {
    return _usersRepo.signup(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      password: params.password,
      phoneNumber: params.phoneNumber,
      profileImagePath: params.profileImagePath,
    );
  }
}

class SignupParams {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? phoneNumber;
  final String?
      profileImagePath; // consider to integrate this later without a rush

  SignupParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.profileImagePath,
  });
}
