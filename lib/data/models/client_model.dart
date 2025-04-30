import 'package:health_managment_system/data/models/health_program_model.dart';
import 'package:health_managment_system/data/models/user_model.dart';
import 'package:health_managment_system/domain/entities/client.dart';
import 'package:health_managment_system/enums/diagnosis.dart';
import 'package:health_managment_system/enums/gender.dart';

class ClientModel extends ClientEntity {
  ClientModel({
    required super.id,
    super.profileImagePath,
    required super.firstName,
    required super.lastName,
    required super.gender,
    required super.dateOfBirth,
    required super.contactInfo,
    super.address,
    required super.currentDiagnoses,
    required super.enrolledPrograms,
    required super.registeredByUser,
    super.createdAt,
  });

  factory ClientModel.fromEntity(ClientEntity entity) {
    return ClientModel(
      id: entity.id,
      profileImagePath: entity.profileImagePath,
      firstName: entity.firstName,
      lastName: entity.lastName,
      gender: entity.gender,
      dateOfBirth: entity.dateOfBirth,
      contactInfo: entity.contactInfo,
      address: entity.address,
      currentDiagnoses: entity.currentDiagnoses,
      enrolledPrograms: entity.enrolledPrograms,
      registeredByUser: entity.registeredByUser,
      createdAt: entity.createdAt,
    );
  }

  factory ClientModel.fromMap({required Map<String, dynamic> clientMap}) {
    return ClientModel(
      id: clientMap['id'] as int,
      profileImagePath: clientMap['profile_image_path'] as String?,
      firstName: clientMap['first_name'] as String,
      lastName: clientMap['last_name'] as String,
      gender: Gender.fromString(clientMap['gender']),
      dateOfBirth: DateTime.parse(clientMap['date_of_birth'] as String),
      contactInfo: clientMap['contact_info'] as String,
      address: clientMap['address'] as String?,
      enrolledPrograms:
          (clientMap['enrolled_programs'] as List<dynamic>).cast<Map<String, dynamic>>().map((program) => HealthProgramModel.fromMap(healthProgramMap: program)).toList(),
      currentDiagnoses: (clientMap['diagnoses'] as List<dynamic>).cast<String>().map((diagnosis) => Diagnosis.fromString(diagnosis)).toList(),
      registeredByUser: UserModel.fromMap(userMap: clientMap['registered_by'] as Map<String, dynamic>),
      // modify the backend to return this data
      // createdAt: DateTime.parse(clientMap['created_at'] as String),
    );
  }

  ClientEntity toEntity() {
    return ClientEntity(
      id: id,
      profileImagePath: profileImagePath,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      dateOfBirth: dateOfBirth,
      contactInfo: contactInfo,
      address: address,
      currentDiagnoses: currentDiagnoses,
      enrolledPrograms: enrolledPrograms,
      registeredByUser: registeredByUser,
      createdAt: createdAt,
    );
  }
}
