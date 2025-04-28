import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/data_sources/remote/health_programs/health_programs_remote_datasource_imp.dart';
import 'package:health_managment_system/data/data_sources/remote/health_programs/health_programs_remote_datasource_interface.dart';
import 'package:health_managment_system/domain/entities/health_program_entity.dart';
import 'package:health_managment_system/domain/repository_interface/health_programs/health_programs_repo_interface.dart';
import 'package:health_managment_system/errors/failures.dart';

class HealthProgramsRepositoryImpl implements HealthProgramsRepo {
  late HealthProgramsRemoteDataSource _healthProgramsRemoteDataSource;

  HealthProgramsRepositoryImpl({
    HealthProgramsRemoteDataSource? healthProgramsRemoteDataSource,
  }) {
    _healthProgramsRemoteDataSource = healthProgramsRemoteDataSource ??
        locator<HealthProgramsRemoteDataSourceImpl>();
  }

  @override
  Future<Either<Failure, HealthProgramEntity>> createHealthProgram({
    required String name,
    required String description,
    required String startDate,
    String? endDate,
    String? imagePath,
    Map<String, dynamic>? eligibilityCriteria,
  }) async {
    final result = await _healthProgramsRemoteDataSource.createHealthProgram(
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
      imagePath: imagePath,
      eligibilityCriteria: eligibilityCriteria,
    );

    if (result.isRight()) {
      final programModel = result.fold((failure) => null, (model) => model);
      HealthProgramEntity entity = programModel!.toEntity();
      return Right(entity);
    }

    final failure = result.fold((failure) => failure, (model) => null);
    return Left(failure!);
  }

  @override
  Future<Either<Failure, HealthProgramEntity>> getHealthProgram(int id) async {
    final result = await _healthProgramsRemoteDataSource.getHealthProgram(id);

    if (result.isRight()) {
      final programModel = result.fold((failure) => null, (model) => model);
      HealthProgramEntity entity = programModel!.toEntity();
      return Right(entity);
    }

    final failure = result.fold((failure) => failure, (model) => null);
    return Left(failure!);
  }

  @override
  Future<Either<Failure, List<HealthProgramEntity>>> getAllHealthPrograms({
    int page = 1,
    int limit = 10,
  }) async {
    final result = await _healthProgramsRemoteDataSource.getAllHealthPrograms(
      page: page,
      limit: limit,
    );

    if (result.isRight()) {
      final programsModel = result.fold((failure) => null, (models) => models);
      final entities = programsModel!
          .map((programModel) => programModel.toEntity())
          .toList();
      return Right(entities);
    }

    final failure = result.fold((failure) => failure, (models) => null);
    return Left(failure!);
  }

  @override
  Future<Either<Failure, List<HealthProgramEntity>>> searchHealthPrograms({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    final result = await _healthProgramsRemoteDataSource.searchHealthPrograms(
      query: query,
      page: page,
      limit: limit,
    );

    if (result.isRight()) {
      final programsModel = result.fold((failure) => null, (models) => models);
      final entities = programsModel!.map((model) => model.toEntity()).toList();
      return Right(entities);
    }

    final failure = result.fold((failure) => failure, (models) => null);
    return Left(failure!);
  }

  @override
  Future<Either<Failure, int>> deleteHealthProgram(int id) async {
    final result =
        await _healthProgramsRemoteDataSource.deleteHealthProgram(id);

    if (result.isRight()) {
      final deletedId = result.fold((failure) => null, (id) => id);
      return Right(deletedId!);
    }

    final failure = result.fold((failure) => failure, (id) => null);
    return Left(failure!);
  }
}
