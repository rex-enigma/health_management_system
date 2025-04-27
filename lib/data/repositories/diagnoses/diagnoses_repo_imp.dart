import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/data_sources/remote/diagnoses/diagnoses_remote_datasource_interface.dart';
import 'package:health_managment_system/domain/repository_interface/diagnoses/diagnoses_repo_interface.dart';
import 'package:health_managment_system/enums/diagnosis.dart';
import 'package:health_managment_system/errors/failures.dart';

class DiagnosesRepositoryImpl implements DiagnosesRepo {
  late DiagnosesRemoteDataSource _diagnosesRemoteDataSource;

  DiagnosesRepositoryImpl({
    DiagnosesRemoteDataSource? diagnosesRemoteDataSource,
  }) {
    _diagnosesRemoteDataSource =
        diagnosesRemoteDataSource ?? locator<DiagnosesRemoteDataSource>();
  }

  @override
  Future<Either<Failure, List<Diagnosis>>> getAllDiagnoses({
    int page = 1,
    int limit = 10,
  }) async {
    final result = await _diagnosesRemoteDataSource.getAllDiagnoses(
      page: page,
      limit: limit,
    );

    if (result.isRight()) {
      final diagnoses =
          result.fold((failure) => null, (diagnoses) => diagnoses);
      return Right(diagnoses!);
    }

    final failure = result.fold((failure) => failure, (diagnoses) => null);
    return Left(failure!);
  }
}
