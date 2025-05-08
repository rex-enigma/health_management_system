import 'package:health_managment_system/domain/entities/diagnosis_entity.dart';
import 'package:health_managment_system/domain/entities/eligibility_criteria_entity.dart';

class EligibilityCriteriaModel extends EligibilityCriteriaEntity {
  EligibilityCriteriaModel({
    required super.id,
    super.minAge,
    super.maxAge,
    super.diagnosis,
  });

  factory EligibilityCriteriaModel.fromEntity(EligibilityCriteriaEntity entity) {
    return EligibilityCriteriaModel(
      id: entity.id,
      minAge: entity.minAge,
      maxAge: entity.maxAge,
      diagnosis: entity.diagnosis,
    );
  }

  factory EligibilityCriteriaModel.fromMap({required Map<String, dynamic> eligibilityCriteriaMap}) {
    return EligibilityCriteriaModel(
      id: eligibilityCriteriaMap['id'] as int,
      minAge: eligibilityCriteriaMap['min_age'] as int?,
      maxAge: eligibilityCriteriaMap['max_age'] as int?,
      diagnosis: eligibilityCriteriaMap['diagnosis'] != null
          ? DiagnosisEntity(
              id: eligibilityCriteriaMap['diagnosis']['id'] as int,
              diagnosisName: eligibilityCriteriaMap['diagnosis']['diagnosis_name'] as String,
              icd11Code: eligibilityCriteriaMap['diagnosis']['icd_11_code'] as String,
            )
          : null,
    );
  }

  EligibilityCriteriaEntity toEntity() {
    return EligibilityCriteriaEntity(
      id: id,
      minAge: minAge,
      maxAge: maxAge,
      diagnosis: diagnosis,
    );
  }

  @override
  int get hashCode {
    return id.hashCode ^ minAge.hashCode ^ maxAge.hashCode ^ diagnosis.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EligibilityCriteriaModel &&
        other.id == id &&
        other.minAge == minAge &&
        other.maxAge == maxAge &&
        other.diagnosis == diagnosis;
  }
}
