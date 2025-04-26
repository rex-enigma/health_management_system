import 'package:health_managment_system/data/models/health_program_model.dart';
import 'package:health_managment_system/domain/entities/health_program_entity.dart';

abstract class HealthProgramsRemoteDataSource {
  Future<HealthProgramModel> createHealthProgram({
    required String name,
    required String description,
    required String startDate,
    String? endDate,
    String? imagePath,
    Map<String, dynamic>? eligibilityCriteria,
  });

  Future<HealthProgramModel> getHealthProgram(int healthProgramId);

  Future<List<HealthProgramModel>> getAllHealthPrograms({int page = 1, int limit = 10});

  Future<List<HealthProgramModel>> searchHealthPrograms({
    required String query,
    int page = 1,
    int limit = 10,
  });

  Future<void> deleteHealthProgram(int healthProgramId);
}
