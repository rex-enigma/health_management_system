import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/repositories/health_programs/health_progams_repo_imp.dart';
import 'package:health_managment_system/domain/entities/health_program_entity.dart';
import 'package:health_managment_system/domain/repository_interface/health_programs/health_programs_repo_interface.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/errors/failures.dart';

class GetHealthProgramUseCase implements UseCase<Either<Failure, HealthProgramEntity>, GetHealthProgramParam> {
  final HealthProgramsRepo _healthProgramsRepo;

  GetHealthProgramUseCase({HealthProgramsRepo? healthProgramsRepo})
      : _healthProgramsRepo = healthProgramsRepo ?? locator<HealthProgramsRepositoryImpl>();

  @override
  Future<Either<Failure, HealthProgramEntity>> call(GetHealthProgramParam param) {
    return _healthProgramsRepo.getHealthProgram(param.id);
  }
}

class GetHealthProgramParam {
  final int id;

  GetHealthProgramParam({required this.id});
}
