import 'package:flutter/foundation.dart';
import 'package:health_managment_system/domain/entities/health_program_entity.dart';
import 'package:health_managment_system/domain/entities/user_entity.dart';
import 'package:health_managment_system/enums/diagnosis.dart';
import 'package:health_managment_system/enums/gender.dart';

class ClientEntity {
  final int id;
  final String? profileImagePath;
  final String firstName;
  final String lastName;
  final Gender gender;
  final DateTime dateOfBirth;
  final String contactInfo;
  final String? address;
  final List<Diagnosis> currentDiagnoses; // The primary conditions or reasons for enrollment
  final List<HealthProgramEntity> enrolledPrograms; // List of enrolled programs
  final UserEntity registeredByUser;
  final DateTime? createdAt;

  ClientEntity({
    required this.id,
    this.profileImagePath,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.contactInfo,
    this.address,
    required this.currentDiagnoses,
    required this.enrolledPrograms,
    required this.registeredByUser,
    this.createdAt,
  });

  // /// Constructor for creating a new client instance before persistence.
  // ClientEntity.insert({
  //   required this.id,
  //   this.profileImagePath,
  //   required this.firstName,
  //   required this.lastName,
  //   required this.gender,
  //   required this.dateOfBirth,
  //   required this.contactInfo,
  //   this.address,
  //   this.currentDiagnoses = const [],
  //   this.enrolledPrograms = const [],
  //   required this.registeredByUser,
  //   required this.createdAt,
  // });

  /// Allows creating a modified copy of the current instance.
  ClientEntity copyWith({
    String? profileImagePath,
    String? firstName,
    String? lastName,
    Gender? gender,
    DateTime? dateOfBirth,
    String? contactInfo,
    String? address,
    List<Diagnosis>? currentDiagnoses,
    List<HealthProgramEntity>? enrolledPrograms,
  }) {
    return ClientEntity(
      id: id,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      contactInfo: contactInfo ?? this.contactInfo,
      address: address ?? this.address,
      currentDiagnoses: currentDiagnoses ?? this.currentDiagnoses,
      enrolledPrograms: enrolledPrograms ?? this.enrolledPrograms,
      registeredByUser: registeredByUser,
      createdAt: createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return (other is ClientEntity &&
        id == other.id &&
        profileImagePath == other.profileImagePath &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        gender == other.gender &&
        dateOfBirth == other.dateOfBirth &&
        contactInfo == other.contactInfo &&
        address == other.address &&
        listEquals(currentDiagnoses, other.currentDiagnoses) &&
        listEquals(enrolledPrograms, other.enrolledPrograms) &&
        registeredByUser == other.registeredByUser &&
        createdAt == other.createdAt);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        profileImagePath.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        gender.hashCode ^
        dateOfBirth.hashCode ^
        contactInfo.hashCode ^
        address.hashCode ^
        currentDiagnoses.hashCode ^
        enrolledPrograms.hashCode ^
        registeredByUser.hashCode ^
        createdAt.hashCode;
  }

  @override
  String toString() {
    return """ClientEntity: {
      id: $id,
      profileImagePath: $profileImagePath,
      firstName: $firstName,
      lastName: $lastName,
      gender: $gender,
      dateOfBirth: $dateOfBirth,
      contactInfo: $contactInfo,
      address: $address,
      currentDiagnoses: $currentDiagnoses,
      enrolledPrograms: $enrolledPrograms,
      registeredByUser: $registeredByUser,
      createdAt: $createdAt
    }""";
  }
}
