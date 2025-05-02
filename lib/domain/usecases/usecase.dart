// RT: represent Return Type
// PT: represent Parameter Type to be passed to a usecase.
abstract class UseCase<RT, PT> {
  Future<RT> call(PT params);
}

class NoParams {
  const NoParams();
}

class SearchParams {
  final String query;
  final int page;
  final int limit;

  SearchParams({
    required this.query,
    this.page = 1,
    this.limit = 10,
  });
}
