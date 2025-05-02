import 'package:dartz/dartz.dart';
import 'package:health_managment_system/data/models/diagnosis_model.dart';
import 'package:health_managment_system/errors/failures.dart';

abstract class DiagnosesRemoteDataSource {
  // Future<Either<Failure, List<DiagnosisModel>>> getAllDiagnoses({int page = 1, int limit = 10});

  Future<Either<Failure, List<DiagnosisModel>>> searchDiagnoses(
      {required String query, int page = 1, int limit = 10});
}
