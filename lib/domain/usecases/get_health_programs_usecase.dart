import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/repositories/health_programs/health_progams_repo_imp.dart';
import 'package:health_managment_system/domain/entities/health_program_entity.dart';
import 'package:health_managment_system/domain/repository_interface/health_programs/health_programs_repo_interface.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/errors/failures.dart';

class GetHealthProgramUseCase implements UseCase<Either<Failure, HealthProgramEntity>, GetHealthProgramParams> {
  final HealthProgramsRepo _healthProgramsRepo;

  GetHealthProgramUseCase({HealthProgramsRepo? healthProgramsRepo}) : _healthProgramsRepo = healthProgramsRepo ?? locator<HealthProgramsRepositoryImpl>();

  @override
  Future<Either<Failure, HealthProgramEntity>> call(GetHealthProgramParams params) {
    return _healthProgramsRepo.getHealthProgram(params.id);
  }
}

class GetHealthProgramParams {
  final int id;

  GetHealthProgramParams({required this.id});
}
