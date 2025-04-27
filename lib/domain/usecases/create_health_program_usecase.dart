import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/repositories/health_programs/health_progams_repo_imp.dart';
import 'package:health_managment_system/domain/entities/health_program_entity.dart';
import 'package:health_managment_system/domain/repository_interface/health_programs/health_programs_repo_interface.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/errors/failures.dart';

class CreateHealthProgramUseCase
    implements
        UseCase<Either<Failure, HealthProgramEntity>,
            CreateHealthProgramParams> {
  final HealthProgramsRepo _healthProgramsRepo;

  CreateHealthProgramUseCase({HealthProgramsRepo? healthProgramsRepo})
      : _healthProgramsRepo =
            healthProgramsRepo ?? locator<HealthProgramsRepositoryImpl>();

  @override
  Future<Either<Failure, HealthProgramEntity>> call(
      CreateHealthProgramParams params) {
    return _healthProgramsRepo.createHealthProgram(
      name: params.name,
      description: params.description,
      startDate: params.startDate,
      endDate: params.endDate,
      imagePath: params.imagePath,
      eligibilityCriteria: params.eligibilityCriteria,
    );
  }
}

class CreateHealthProgramParams {
  final String name;
  final String description;
  final String startDate;
  final String? endDate;
  final String? imagePath;
  final Map<String, dynamic>? eligibilityCriteria;

  CreateHealthProgramParams({
    required this.name,
    required this.description,
    required this.startDate,
    this.endDate,
    this.imagePath,
    this.eligibilityCriteria,
  });
}
