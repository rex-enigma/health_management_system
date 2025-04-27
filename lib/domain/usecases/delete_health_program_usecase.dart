import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/repositories/health_programs/health_progams_repo_imp.dart';
import 'package:health_managment_system/domain/repository_interface/health_programs/health_programs_repo_interface.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/errors/failures.dart';

class DeleteHealthProgramUseCase
    implements UseCase<Either<Failure, void>, DeleteHealthProgramParams> {
  final HealthProgramsRepo _healthProgramsRepo;

  DeleteHealthProgramUseCase({HealthProgramsRepo? healthProgramsRepo})
      : _healthProgramsRepo =
            healthProgramsRepo ?? locator<HealthProgramsRepositoryImpl>();

  @override
  Future<Either<Failure, void>> call(DeleteHealthProgramParams params) {
    return _healthProgramsRepo.deleteHealthProgram(params.id);
  }
}

class DeleteHealthProgramParams {
  final int id;

  DeleteHealthProgramParams({required this.id});
}
