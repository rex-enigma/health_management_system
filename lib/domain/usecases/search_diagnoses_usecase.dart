import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/repositories/diagnoses/diagnoses_repo_imp.dart';
import 'package:health_managment_system/domain/entities/diagnosis_entity.dart';
import 'package:health_managment_system/domain/repository_interface/diagnoses/diagnoses_repo_interface.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/errors/failures.dart';

class SearchDiagnosesUseCase extends UseCase<Either<Failure, List<DiagnosisEntity>>, SearchParams> {
  final DiagnosesRepo _diagnosisRepos;

  SearchDiagnosesUseCase({DiagnosesRepo? diagnosisRepos})
      : _diagnosisRepos = diagnosisRepos ?? locator<DiagnosesRepositoryImpl>();

  @override
  Future<Either<Failure, List<DiagnosisEntity>>> call(SearchParams params) async {
    return await _diagnosisRepos.searchDiagnoses(
      query: params.query,
      page: params.page,
      limit: params.limit,
    );
  }
}
