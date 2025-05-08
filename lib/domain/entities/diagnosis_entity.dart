class DiagnosisEntity {
  final int id;
  final String diagnosisName;
  final String icd11Code;

  DiagnosisEntity({
    required this.id,
    required this.diagnosisName,
    required this.icd11Code,
  });

  DiagnosisEntity copyWith({
    int? id,
    String? diagnosisName,
    String? code,
  }) {
    return DiagnosisEntity(
      id: id ?? this.id,
      diagnosisName: diagnosisName ?? this.diagnosisName,
      icd11Code: code ?? this.icd11Code,
    );
  }

  @override
  bool operator ==(Object other) {
    return (other is DiagnosisEntity &&
        id == other.id &&
        diagnosisName == other.diagnosisName &&
        icd11Code == other.icd11Code);
  }

  @override
  int get hashCode {
    return id.hashCode ^ diagnosisName.hashCode ^ icd11Code.hashCode;
  }

  @override
  String toString() {
    return """DiagnosisEntity: {
      id: $id,
      diagnosisName: $diagnosisName,
      code: $icd11Code
    }""";
  }
}
