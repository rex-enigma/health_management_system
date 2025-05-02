import 'package:health_managment_system/domain/entities/client_entity.dart';
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

  /// Business logic for checking if the criteria are met for a given client
  bool isClientEligible(ClientEntity client) {
    final clientAge = _calculateClientAge(client.dateOfBirth);
    if (minAge != null && clientAge < minAge!) {
      return false;
    }
    if (maxAge != null && clientAge > maxAge!) {
      return false;
    }
    return client.currentDiagnoses
        .any((diagnosis) => diagnosis.diagnosisName == diagnosis.diagnosisName);
  }

  /// Calculates the age of the client based on their date of birth
  int _calculateClientAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

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
