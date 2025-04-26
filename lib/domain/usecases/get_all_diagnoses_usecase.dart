import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/repositories/diagnoses/diagnoses_repo_imp.dart';
import 'package:health_managment_system/domain/repository_interface/diagnoses/diagnoses_repo_interface.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/enums/diagnosis.dart';
import 'package:health_managment_system/errors/failures.dart';

class GetAllDiagnosesUseCase implements UseCase<Either<Failure, List<Diagnosis>>, GetAllDiagnosesParams> {
  final DiagnosesRepo _diagnosesRepo;

  GetAllDiagnosesUseCase({DiagnosesRepo? diagnosesRepo}) : _diagnosesRepo = diagnosesRepo ?? locator<DiagnosesRepositoryImpl>();

  @override
  Future<Either<Failure, List<Diagnosis>>> call(GetAllDiagnosesParams params) {
    return _diagnosesRepo.getAllDiagnoses(
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetAllDiagnosesParams {
  final int page;
  final int limit;

  GetAllDiagnosesParams({this.page = 1, this.limit = 10});
}
