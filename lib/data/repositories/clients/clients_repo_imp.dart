import 'package:dartz/dartz.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/data/data_sources/remote/clients/clients_remote_datasource_interface.dart';
import 'package:health_managment_system/domain/entities/client.dart';
import 'package:health_managment_system/domain/repository_interface/clients/clients_repo_interface.dart';
import 'package:health_managment_system/errors/failures.dart';

class ClientsRepositoryImpl implements ClientsRepo {
  late ClientsRemoteDataSource _clientsRemoteDataSource;

  ClientsRepositoryImpl({
    ClientsRemoteDataSource? clientsRemoteDataSource,
  }) {
    _clientsRemoteDataSource =
        clientsRemoteDataSource ?? locator<ClientsRemoteDataSource>();
  }

  @override
  Future<Either<Failure, ClientEntity>> createClient({
    required String firstName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
    required String contactInfo,
    String? address,
    String? profileImagePath,
    required List<String> diagnosisNames,
  }) async {
    final result = await _clientsRemoteDataSource.createClient(
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      dateOfBirth: dateOfBirth,
      contactInfo: contactInfo,
      address: address,
      profileImagePath: profileImagePath,
      diagnosisNames: diagnosisNames,
    );

    if (result.isRight()) {
      final clientModel = result.fold((failure) => null, (client) => client);
      final clientEntity = clientModel!.toEntity();
      return Right(clientEntity);
    }

    final failure = result.fold((failure) => failure, (client) => null);
    return Left(failure!);
  }

  @override
  Future<Either<Failure, List<ClientEntity>>> getAllClients({
    int page = 1,
    int limit = 10,
  }) async {
    final result =
        await _clientsRemoteDataSource.getAllClients(page: page, limit: limit);

    if (result.isRight()) {
      final clients = result.fold((failure) => null, (clients) => clients);
      final entities =
          clients?.map((clientModel) => clientModel.toEntity()).toList();
      return Right(entities!);
    }

    final failure = result.fold((failure) => failure, (clients) => null);
    return Left(failure!);
  }

  @override
  Future<Either<Failure, List<ClientEntity>>> searchClients({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    final result = await _clientsRemoteDataSource.searchClients(
        query: query, page: page, limit: limit);

    if (result.isRight()) {
      final clients = result.fold((failure) => null, (clients) => clients);
      final entities =
          clients?.map((clientModel) => clientModel.toEntity()).toList();
      return Right(entities!);
    }

    final failure = result.fold((failure) => failure, (clients) => null);
    return Left(failure!);
  }

  @override
  Future<Either<Failure, ClientEntity>> getClient(int id) async {
    final result = await _clientsRemoteDataSource.getClient(id);

    if (result.isRight()) {
      final clients = result.fold((failure) => null, (clients) => clients);
      final entities = clients!.toEntity();
      return Right(entities);
    }

    final failure = result.fold((failure) => failure, (client) => null);
    return Left(failure!);
  }

  @override
  Future<Either<Failure, Unit>> enrollClient(
      int id, List<int> healthProgramIds) async {
    final result =
        await _clientsRemoteDataSource.enrollClient(id, healthProgramIds);

    if (result.isRight()) {
      return const Right(unit);
    }

    final failure = result.fold((failure) => failure, (_) => null);
    return Left(failure!);
  }

  @override
  Future<Either<Failure, int>> deleteClient(int id) async {
    final result = await _clientsRemoteDataSource.deleteClient(id);

    if (result.isRight()) {
      final deletedId = result.fold((failure) => null, (id) => id);
      return Right(deletedId!);
    }

    final failure = result.fold((failure) => failure, (_) => null);
    return Left(failure!);
  }
}
