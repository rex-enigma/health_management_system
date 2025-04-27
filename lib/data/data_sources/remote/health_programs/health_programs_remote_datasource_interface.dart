import 'package:health_managment_system/data/models/health_program_model.dart';
import 'package:dartz/dartz.dart';
import 'package:health_managment_system/errors/failures.dart';

abstract class HealthProgramsRemoteDataSource {
  Future<Either<Failure, HealthProgramModel>> createHealthProgram({
    required String name,
    required String description,
    required String startDate,
    String? endDate,
    String? imagePath,
    Map<String, dynamic>? eligibilityCriteria,
  });

  Future<Either<Failure, HealthProgramModel>> getHealthProgram(
      int healthProgramId);

  Future<Either<Failure, List<HealthProgramModel>>> getAllHealthPrograms(
      {int page = 1, int limit = 10});

  Future<Either<Failure, List<HealthProgramModel>>> searchHealthPrograms({
    required String query,
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, int>> deleteHealthProgram(int healthProgramId);
}
