import 'package:dartz/dartz.dart';
import 'package:health_managment_system/domain/entities/diagnosis_entity.dart';
import 'package:health_managment_system/errors/failures.dart';

abstract class DiagnosesRepo {
  // Future<Either<Failure, List<DiagnosisEntity>>> getAllDiagnoses({
  //   int page = 1,
  //   int limit = 10,
  // });

  Future<Either<Failure, List<DiagnosisEntity>>> searchDiagnoses({
    required String query,
    int page = 1,
    int limit = 10,
  });
}
