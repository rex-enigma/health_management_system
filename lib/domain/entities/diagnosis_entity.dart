class DiagnosisEntity {
  final int id;
  final String diagnosisName;
  final String icd10Code;

  DiagnosisEntity({
    required this.id,
    required this.diagnosisName,
    required this.icd10Code,
  });

  DiagnosisEntity copyWith({
    int? id,
    String? diagnosisName,
    String? code,
  }) {
    return DiagnosisEntity(
      id: id ?? this.id,
      diagnosisName: diagnosisName ?? this.diagnosisName,
      icd10Code: code ?? this.icd10Code,
    );
  }

  @override
  bool operator ==(Object other) {
    return (other is DiagnosisEntity &&
        id == other.id &&
        diagnosisName == other.diagnosisName &&
        icd10Code == other.icd10Code);
  }

  @override
  int get hashCode {
    return id.hashCode ^ diagnosisName.hashCode ^ icd10Code.hashCode;
  }

  @override
  String toString() {
    return """DiagnosisEntity: {
      id: $id,
      diagnosisName: $diagnosisName,
      code: $icd10Code
    }""";
  }
}
