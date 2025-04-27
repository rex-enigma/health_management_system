import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/repositories/clients/clients_repo_imp.dart';
import 'package:health_managment_system/domain/entities/client.dart';
import 'package:health_managment_system/domain/repository_interface/clients/clients_repo_interface.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/errors/failures.dart';

class SearchClientsUseCase
    implements
        UseCase<Either<Failure, List<ClientEntity>>, SearchClientsParams> {
  final ClientsRepo _clientsRepos;

  SearchClientsUseCase({ClientsRepo? clientsRepos})
      : _clientsRepos = clientsRepos ?? locator<ClientsRepositoryImpl>();

  @override
  Future<Either<Failure, List<ClientEntity>>> call(SearchClientsParams params) {
    return _clientsRepos.searchClients(
      query: params.query,
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchClientsParams {
  final String query;
  final int page;
  final int limit;

  SearchClientsParams({
    required this.query,
    this.page = 1,
    this.limit = 10,
  });
}
