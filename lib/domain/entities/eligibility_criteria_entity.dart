import 'package:health_managment_system/domain/entities/diagnosis_entity.dart';

class EligibilityCriteriaEntity {
  final int id;
  final int? minAge; // Minimum age in years
  final int? maxAge; // Maximum age in years
  final DiagnosisEntity? diagnosis;

  EligibilityCriteriaEntity({
    required this.id,
    this.minAge,
    this.maxAge,
    this.diagnosis,
  });

  @override
  bool operator ==(Object other) {
    return other is EligibilityCriteriaEntity &&
        id == other.id &&
        minAge == other.minAge &&
        maxAge == other.maxAge &&
        diagnosis == other.diagnosis;
  }

  @override
  int get hashCode {
    return id.hashCode ^ minAge.hashCode ^ maxAge.hashCode ^ diagnosis.hashCode;
  }

  /// Returns a string representation of the entity
  @override
  String toString() {
    return """EligibilityCriteriaEntity{
    id: $id,
    minAge: $minAge,
    axAge: $maxAge,
    requiredDiagnosis: $diagnosis
    }""";
  }
}
