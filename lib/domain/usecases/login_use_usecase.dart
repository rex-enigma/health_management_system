import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/repositories/users/users_repo_imp.dart';
import 'package:health_managment_system/domain/entities/user_entity.dart';
import 'package:health_managment_system/domain/repository_interface/users/users_repo_interface.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/errors/failures.dart';

class LoginUseCase
    implements UseCase<Either<Failure, UserEntity>, LoginParams> {
  final UsersRepo _usersRepo;

  LoginUseCase({UsersRepo? usersRepos})
      : _usersRepo = usersRepos ?? locator<UsersRepositoryImpl>();

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return _usersRepo.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({
    required this.email,
    required this.password,
  });
}
