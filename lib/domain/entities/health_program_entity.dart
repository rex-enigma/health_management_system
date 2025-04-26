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

  bool get isEmpty => minAge == null && maxAge == null && requiredDiagnosis == null;

  bool isClientEligible(ClientEntity client) {
    throw Exception();
  }

  int _getClientAge() {
    throw Exception();
  }

  /// Named constructor to create an `EligibilityCriteria` from a map.
  factory EligibilityCriteria.fromMap({required Map<String, dynamic> eligibilityCriteriaMap}) {
    return EligibilityCriteria(
      id: eligibilityCriteriaMap['id'] as int,
      minAge: eligibilityCriteriaMap['min_age'] as int?,
      maxAge: eligibilityCriteriaMap['max_age'] as int?,
      requiredDiagnosis: Diagnosis.fromString(eligibilityCriteriaMap['diagnosis_name'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'min_age': minAge,
      'max_age': maxAge,
      'diagnosis_name': requiredDiagnosis.name,
    };
  }
}
