import 'package:health_managment_system/data/models/user_model.dart';
import 'package:health_managment_system/domain/entities/health_program_entity.dart';

class HealthProgramModel extends HealthProgramEntity {
  HealthProgramModel({
    required super.id,
    super.imagePath,
    required super.name,
    required super.description,
    required super.startDate,
    super.endDate,
    super.eligibilityCriteria,
    required super.createdByUser,
    super.createdAt,
  });

  factory HealthProgramModel.fromEntity(HealthProgramEntity entity) {
    return HealthProgramModel(
      id: entity.id,
      imagePath: entity.imagePath,
      name: entity.name,
      description: entity.description,
      startDate: entity.startDate,
      endDate: entity.endDate,
      eligibilityCriteria: entity.eligibilityCriteria,
      createdByUser: entity.createdByUser,
      createdAt: entity.createdAt,
    );
  }

  factory HealthProgramModel.fromMap(
      {required Map<String, dynamic> healthProgramMap}) {
    return HealthProgramModel(
      id: healthProgramMap['id'] as int,
      imagePath: healthProgramMap['image_path'] as String?,
      name: healthProgramMap['name'] as String,
      description: healthProgramMap['description'] as String,
      startDate: DateTime.parse(healthProgramMap['start_date'] as String),
      endDate: healthProgramMap['end_date'] != null
          ? DateTime.parse(healthProgramMap['end_date'] as String)
          : null,
      eligibilityCriteria: healthProgramMap['eligibility_criteria'] != null
          ? EligibilityCriteria.fromMap(
              eligibilityCriteriaMap: healthProgramMap['eligibility_criteria']
                  as Map<String, dynamic>)
          : null,
      createdByUser: UserModel.fromMap(
          userMap: healthProgramMap['created_by'] as Map<String, dynamic>),
      // modify the backend to return this data
      // createdAt: DateTime.parse(healthProgramMap['created_at'] as String),
    );
  }

  HealthProgramEntity toEntity() {
    return HealthProgramEntity(
      id: id,
      imagePath: imagePath,
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
      eligibilityCriteria: eligibilityCriteria,
      createdByUser: createdByUser,
      createdAt: createdAt,
    );
  }
}
