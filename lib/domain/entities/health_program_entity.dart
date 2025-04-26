import 'package:health_managment_system/domain/entities/client.dart';
import 'package:health_managment_system/enums/diagnosis.dart';
import 'package:health_managment_system/domain/entities/user_entity.dart';

class HealthProgramEntity {
  final int id;
  final String? imagePath;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final EligibilityCriteria? eligibilityCriteria;
  final UserEntity createdByUser;
  final DateTime createdAt;

  HealthProgramEntity({
    required this.id,
    this.imagePath,
    required this.name,
    required this.description,
    required this.startDate,
    this.endDate,
    this.eligibilityCriteria,
    required this.createdByUser,
    required this.createdAt,
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

  /// Allows creating a modified copy of the current instance.
  HealthProgramEntity copyWith({
    String? imagePath,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    EligibilityCriteria? eligibilityCriteria,
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

class EligibilityCriteria {
  final int id;
  final int? minAge; // Minimum age in years
  final int? maxAge; // Maximum age in years
  final Diagnosis requiredDiagnosis;

  EligibilityCriteria({
    required this.id,
    this.minAge,
    this.maxAge,
    required this.requiredDiagnosis,
  });

  bool get isEmpty => minAge == null && maxAge == null;

  bool isClientEligible(ClientEntity client) {
    // Check age eligibility
    final clientAge = _getClientAge(client.dateOfBirth);
    if (minAge != null && clientAge < minAge!) {
      return false;
    }
    if (maxAge != null && clientAge > maxAge!) {
      return false;
    }

    // Check diagnosis eligibility
    return client.currentDiagnoses.any((diagnosis) => diagnosis.name == requiredDiagnosis.name);
  }

  int _getClientAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month || (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  @override
  bool operator ==(Object other) {
    return other is EligibilityCriteria && id == other.id && minAge == other.minAge && maxAge == other.maxAge && requiredDiagnosis == other.requiredDiagnosis;
  }

  @override
  int get hashCode {
    return id.hashCode ^ minAge.hashCode ^ maxAge.hashCode ^ requiredDiagnosis.hashCode;
  }
}
