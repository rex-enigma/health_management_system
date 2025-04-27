import 'package:health_managment_system/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    super.phoneNumber,
    super.profileImagePath,
    super.createdAt,
  });

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      profileImagePath: entity.profileImagePath,
      createdAt: entity.createdAt,
    );
  }

  factory UserModel.fromMap({required Map<String, dynamic> userMap}) {
    return UserModel(
      id: userMap['id'] as int,
      firstName: userMap['first_name'] as String,
      lastName: userMap['last_name'] as String,
      email: userMap['email'] as String,
      phoneNumber: userMap['phone_number'] as String?,
      profileImagePath: userMap['profile_image_path'] as String?,
      // modify the backend to return this data
      // createdAt: DateTime.parse(userMap['created_at'] as String),
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      profileImagePath: profileImagePath,
      createdAt: createdAt,
    );
  }
}
