import 'package:dartz/dartz.dart';
import 'package:health_managment_system/domain/entities/health_program_entity.dart';
import 'package:health_managment_system/errors/failures.dart';

abstract class HealthProgramsRepo {
  Future<Either<Failure, HealthProgramEntity>> createHealthProgram({
    required String name,
    required String description,
    required String startDate,
    String? endDate,
    String? imagePath,
    Map<String, dynamic>? eligibilityCriteria,
  });

  Future<Either<Failure, HealthProgramEntity>> getHealthProgram(int clientId);

  Future<Either<Failure, List<HealthProgramEntity>>> getAllHealthPrograms({
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, List<HealthProgramEntity>>> searchHealthPrograms({
    required String query,
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, int>> deleteHealthProgram(int id);
}
