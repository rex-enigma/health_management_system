// RT: represent Return Type
// PT: represent Parameter Type to be passed to a usecase.
abstract class UseCase<RT, PT> {
  Future<RT> call(PT params);
}

class NoParams {
  const NoParams();
}

class SignupParams {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? phoneNumber;
  final String? profileImagePath;

  SignupParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.profileImagePath,
  });
}
