import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/data_sources/remote/diagnoses/diagnoses_remote_datasource_imp.dart';
import 'package:health_managment_system/data/data_sources/remote/diagnoses/diagnoses_remote_datasource_interface.dart';
import 'package:health_managment_system/data/models/diagnosis_model.dart';
import 'package:health_managment_system/domain/entities/diagnosis_entity.dart';
import 'package:health_managment_system/domain/repository_interface/diagnoses/diagnoses_repo_interface.dart';
import 'package:health_managment_system/errors/failures.dart';

class DiagnosesRepositoryImpl implements DiagnosesRepo {
  late DiagnosesRemoteDataSource _diagnosesRemoteDataSource;

  DiagnosesRepositoryImpl({
    DiagnosesRemoteDataSource? diagnosesRemoteDataSource,
  }) {
    _diagnosesRemoteDataSource =
        diagnosesRemoteDataSource ?? locator<DiagnosesRemoteDataSourceImpl>();
  }

  // @override
  // Future<Either<Failure, List<DiagnosisEntity>>> getAllDiagnoses(
  //     {int page = 1, int limit = 10}) async {
  //   final result = await _diagnosesRemoteDataSource.getAllDiagnoses(
  //     page: page,
  //     limit: limit,
  //   );

  //   if (result.isRight()) {
  //     final diagnoses =
  //         result.fold((failure) => null, (diagnoses) => diagnoses);
  //     return Right(diagnoses!);
  //   }

  //   final failure = result.fold((failure) => failure, (diagnoses) => null);
  //   return Left(failure!);
  // }

  @override
  Future<Either<Failure, List<DiagnosisEntity>>> searchDiagnoses(
      {required String query, int page = 1, int limit = 10}) async {
    final result = await _diagnosesRemoteDataSource.searchDiagnoses(
      query: query,
      page: page,
      limit: limit,
    );

    if (result.isRight()) {
      final diagnosesModel = result.fold((failure) => null, (diagnoses) => diagnoses);
      final diagnosisEntities =
          diagnosesModel!.map((diagnosisModel) => diagnosisModel.toEntity()).toList();
      return Right(diagnosisEntities);
    }

    final failure = result.fold((failure) => failure, (diagnoses) => null);
    return Left(failure!);
  }
}
