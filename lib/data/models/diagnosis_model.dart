import 'package:health_managment_system/domain/entities/diagnosis_entity.dart';

class DiagnosisModel extends DiagnosisEntity {
  DiagnosisModel({
    required super.id,
    required super.diagnosisName,
    required super.icd10Code,
  });

  factory DiagnosisModel.fromEntity(DiagnosisEntity entity) {
    return DiagnosisModel(
      id: entity.id,
      diagnosisName: entity.diagnosisName,
      icd10Code: entity.icd10Code,
    );
  }

  factory DiagnosisModel.fromMap({required Map<String, dynamic> diagnosisMap}) {
    return DiagnosisModel(
      id: diagnosisMap['id'] as int,
      diagnosisName: diagnosisMap['diagnosis_name'] as String,
      icd10Code: diagnosisMap['icd_11_code'] as String,
    );
  }

  DiagnosisEntity toEntity() {
    return DiagnosisEntity(
      id: id,
      diagnosisName: diagnosisName,
      icd10Code: icd10Code,
    );
  }
}
