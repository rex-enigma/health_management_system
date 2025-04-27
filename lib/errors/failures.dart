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
  /// a list of HealthProgramIds which represent all HealthProgram that the client is ineligible
  final List<int> ineligibleHealthProgramIds;

  IneligibleClientFailure({
    required this.ineligibleHealthProgramIds,
  }) : super(
            'Client is not eligible for health programs: $ineligibleHealthProgramIds');
}
