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

class NotFoundFailure extends Failure {
  final int? statusCode;
  NotFoundFailure(super.message, {this.statusCode});
}

class IneligibleClientFailure extends Failure {
  IneligibleClientFailure(super.message);
}
