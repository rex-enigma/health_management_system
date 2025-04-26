import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/repositories/health_programs/health_progams_repo_imp.dart';
import 'package:health_managment_system/domain/entities/health_program_entity.dart';
import 'package:health_managment_system/domain/repository_interface/health_programs/health_programs_repo_interface.dart';
import 'package:health_managment_system/domain/usecases/get_all_health_programs_usecase.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/errors/failures.dart';

class SearchHealthProgramsUseCase implements UseCase<Either<Failure, List<HealthProgramEntity>>, SearchHealthProgramsParams> {
  final HealthProgramsRepo _healthProgramsRepo;

  SearchHealthProgramsUseCase({HealthProgramsRepo? healthProgramsRepo}) : _healthProgramsRepo = healthProgramsRepo ?? locator<HealthProgramsRepositoryImpl>();

  @override
  Future<Either<Failure, List<HealthProgramEntity>>> call(SearchHealthProgramsParams params) {
    return _healthProgramsRepo.searchHealthPrograms(
      query: params.query,
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchHealthProgramsParams {
  final String query;
  final int page;
  final int limit;

  SearchHealthProgramsParams({
    required this.query,
    this.page = 1,
    this.limit = 10,
  });
}
