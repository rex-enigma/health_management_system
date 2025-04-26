abstract class Failure {
  final String message;

  Failure(this.message);
}

class ServerFailure extends Failure {
  final int? statusCode;

  ServerFailure(super.message, {this.statusCode});
}

class AuthenticationFailure extends Failure {
  AuthenticationFailure(super.message);
}
