import 'package:health_managment_system/domain/entities/diagnosis_entity.dart';

class DiagnosisModel extends DiagnosisEntity {
  DiagnosisModel({
    required super.id,
    required super.diagnosisName,
    required super.icd11Code,
  });

  factory DiagnosisModel.fromEntity(DiagnosisEntity entity) {
    return DiagnosisModel(
      id: entity.id,
      diagnosisName: entity.diagnosisName,
      icd11Code: entity.icd11Code,
    );
  }

  factory DiagnosisModel.fromMap({required Map<String, dynamic> diagnosisMap}) {
    return DiagnosisModel(
      id: diagnosisMap['id'] as int,
      diagnosisName: diagnosisMap['diagnosis_name'] as String,
      icd11Code: diagnosisMap['icd_11_code'] as String,
    );
  }

  DiagnosisEntity toEntity() {
    return DiagnosisEntity(
      id: id,
      diagnosisName: diagnosisName,
      icd11Code: icd11Code,
    );
  }
}
