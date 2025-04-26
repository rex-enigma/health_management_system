import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/data_sources/remote/users/users_remote_datasource_interface.dart';
import 'package:health_managment_system/domain/entities/user_entity.dart';
import 'package:health_managment_system/domain/repository_interface/users/users_repo_interface.dart';
import 'package:health_managment_system/errors/failures.dart';

class UsersRepositoryImpl implements UsersRepo {
  late UsersRemoteDataSource _usersRemoteDataSource;

  UsersRepositoryImpl({
    UsersRemoteDataSource? usersRemoteDataSource,
  }) {
    _usersRemoteDataSource = usersRemoteDataSource ?? locator<UsersRemoteDataSource>();
  }

  @override
  Future<Either<Failure, UserEntity>> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
    String? profileImagePath,
  }) async {
    var result = await _usersRemoteDataSource.signup(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      profileImagePath: profileImagePath,
    );

    // success
    if (result.isRight()) {
      final userModel = result.fold((failure) => null, (userModel) => userModel);
      UserEntity userEntity = userModel!.toEntity();
      return Right(userEntity);
    }

    final failure = result.fold((failure) => failure, (userModel) => null);
    return Left(failure!);
  }

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    final result = await _usersRemoteDataSource.login(email, password);
    if (result.isRight()) {
      final userModel = result.fold((failure) => null, (userModel) => userModel);
      UserEntity userEntity = userModel!.toEntity();
      return Right(userEntity);
    }
    final failure = result.fold((failure) => failure, (userModel) => null);
    return Left(failure!);
  }
}
