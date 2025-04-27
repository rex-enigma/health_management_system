// RT: represent Return Type
// PT: represent Parameter Type to be passed to a usecase.
abstract class UseCase<RT, PT> {
  Future<RT> call(PT params);
}

class NoParams {
  const NoParams();
}
