class UserEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String? profileImagePath;
  final DateTime? createdAt;

  UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.profileImagePath,
    this.createdAt,
  });

  /// Constructor for creating a new user instance before persistence.
  // UserEntity.insert({
  //   required this.id,
  //   required this.firstName,
  //   required this.lastName,
  //   required this.email,
  //   this.phoneNumber,
  //   this.profileImagePath,
  //   required this.createdAt,
  // });

  /// Allows creating a modified copy of the current instance.
  UserEntity copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? profileImagePath,
  }) {
    return UserEntity(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      createdAt: createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return (other is UserEntity &&
        id == other.id &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        email == other.email &&
        phoneNumber == other.phoneNumber &&
        profileImagePath == other.profileImagePath &&
        createdAt == other.createdAt);
  }

  @override
  int get hashCode {
    return id.hashCode ^ firstName.hashCode ^ lastName.hashCode ^ email.hashCode ^ phoneNumber.hashCode ^ profileImagePath.hashCode ^ createdAt.hashCode;
  }

  @override
  String toString() {
    return """UserEntity: {
      id: $id,
      firstName: $firstName,
      lastName: $lastName,
      email: $email,
      phoneNumber: $phoneNumber,
      profileImagePath: $profileImagePath,
      createdAt: $createdAt
    }""";
  }
}
