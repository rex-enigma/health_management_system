import 'package:health_managment_system/domain/entities/client_entity.dart';
import 'package:health_managment_system/domain/entities/eligibility_criteria_entity.dart';
import 'package:health_managment_system/domain/entities/user_entity.dart';
import 'package:health_managment_system/utils/calculate_age.dart';

class HealthProgramEntity {
  final int id;
  final String? imagePath;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final EligibilityCriteriaEntity? eligibilityCriteria;
  final UserEntity createdByUser;
  final DateTime? createdAt;

  HealthProgramEntity({
    required this.id,
    this.imagePath,
    required this.name,
    required this.description,
    required this.startDate,
    this.endDate,
    this.eligibilityCriteria,
    required this.createdByUser,
    this.createdAt,
  });

  /// Constructor for creating a new health program instance before persistence.
  // HealthProgramEntity.insert({
  //   required this.id,
  //   this.imagePath,
  //   required this.name,
  //   required this.description,
  //   required this.startDate,
  //   this.endDate,
  //   this.eligibilityCriteria,
  //   required this.createdByUser,
  //   required this.createdAt,
  // });

  /// Business logic for checking if the criteria are met for a given client to be eligible to this health program
  bool isClientEligible(ClientEntity client) {
    final clientAge = calculateAge(client.dateOfBirth);
    if (eligibilityCriteria?.minAge != null && clientAge < eligibilityCriteria!.minAge!) {
      return false;
    }
    if (eligibilityCriteria?.maxAge != null && clientAge > eligibilityCriteria!.maxAge!) {
      return false;
    }
    if (eligibilityCriteria?.diagnosis != null) {
      return client.currentDiagnoses
          .any((clientDiagnosis) => clientDiagnosis.diagnosisName == eligibilityCriteria!.diagnosis!.diagnosisName);
    }
    return true;
  }

  /// Allows creating a modified copy of the current instance.
  HealthProgramEntity copyWith({
    String? imagePath,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    EligibilityCriteriaEntity? eligibilityCriteria,
    UserEntity? createdByUser,
  }) {
    return HealthProgramEntity(
      id: id,
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      eligibilityCriteria: eligibilityCriteria ?? this.eligibilityCriteria,
      createdByUser: createdByUser ?? this.createdByUser,
      createdAt: createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return (other is HealthProgramEntity &&
        id == other.id &&
        imagePath == other.imagePath &&
        name == other.name &&
        description == other.description &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        eligibilityCriteria == other.eligibilityCriteria &&
        createdByUser == other.createdByUser &&
        createdAt == other.createdAt);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        imagePath.hashCode ^
        name.hashCode ^
        description.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        eligibilityCriteria.hashCode ^
        createdByUser.hashCode ^
        createdAt.hashCode;
  }

  @override
  String toString() {
    return """HealthProgramEntity: {
      id: $id,
      imagePath: $imagePath,
      name: $name,
      description: $description,
      startDate: $startDate,
      endDate: $endDate,
      eligibilityCriteria: $eligibilityCriteria,
      createdByUser: $createdByUser,
      createdAt: $createdAt
    }""";
  }
}
