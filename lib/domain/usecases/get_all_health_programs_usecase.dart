import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/repositories/health_programs/health_progams_repo_imp.dart';
import 'package:health_managment_system/domain/entities/health_program_entity.dart';
import 'package:health_managment_system/domain/repository_interface/health_programs/health_programs_repo_interface.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/errors/failures.dart';

class GetAllHealthProgramsUseCase implements UseCase<Either<Failure, List<HealthProgramEntity>>, GetAllHealthProgramsParams> {
  final HealthProgramsRepo _healthProgramsRepo;

  GetAllHealthProgramsUseCase({HealthProgramsRepo? healthProgramsRepo}) : _healthProgramsRepo = healthProgramsRepo ?? locator<HealthProgramsRepositoryImpl>();

  @override
  Future<Either<Failure, List<HealthProgramEntity>>> call(GetAllHealthProgramsParams params) {
    return _healthProgramsRepo.getAllHealthPrograms(
      page: params.page,
      limit: params.limit,
    );
  }
}

class HealthProgramsRepository {}

class GetAllHealthProgramsParams {
  final int page;
  final int limit;

  GetAllHealthProgramsParams({this.page = 1, this.limit = 10});
}
