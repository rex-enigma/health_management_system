import 'package:dartz/dartz.dart';
import 'package:health_managment_system/enums/diagnosis.dart';
import 'package:health_managment_system/errors/failures.dart';

abstract class DiagnosesRepo {
  Future<Either<Failure, List<Diagnosis>>> getAllDiagnoses({
    int page = 1,
    int limit = 10,
  });
}
