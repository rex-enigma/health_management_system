import 'package:health_managment_system/enums/diagnosis.dart';

abstract class DiagnosesRemoteDataSource {
  Future<List<Diagnosis>> getAllDiagnoses({int page = 1, int limit = 10});
}
