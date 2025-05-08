import 'package:flutter/material.dart';
import 'package:health_managment_system/app/app.dialogs.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/app/app.router.dart';
import 'package:health_managment_system/domain/entities/client_entity.dart';
import 'package:health_managment_system/domain/usecases/get_all_clients_usecase.dart';
import 'package:health_managment_system/domain/usecases/get_client_usecase.dart';
import 'package:health_managment_system/domain/usecases/search_clients_usecase.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ClientsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _getClientUseCase = locator<GetClientUseCase>();
  final _getAllClientsUseCase = locator<GetAllClientsUseCase>();
  final _searchClientsUseCase = locator<SearchClientsUseCase>();

  Set<ClientEntity> _clients = {};
  Set<ClientEntity> get clients => _clients;

  Set<ClientEntity> _filteredClients = {};
  Set<ClientEntity> get filteredClients => _filteredClients;

  int _currentPage = 1;
  int _searchPage = 1;
  final int _limit = 10;
  bool _hasMoreData = true;
  bool _hasMoreSearchData = true;

  bool get hasMoreData => _hasMoreData;
  bool get hasMoreSearchData => _hasMoreSearchData;

  String _lastQuery = '';

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  final ScrollController _searchScrollController = ScrollController();
  ScrollController get searchScrollController => _searchScrollController;

  ClientsViewModel() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMoreData && !isBusy) {
        loadClients();
      }
    });

    _searchScrollController.addListener(() {
      if (_searchScrollController.position.pixels == _searchScrollController.position.maxScrollExtent &&
          _hasMoreSearchData &&
          !busy('loadSearchClients')) {
        loadSearchClients(_lastQuery);
      }
    });
  }

  Future<void> loadClients() async {
    setBusy(true);
    final result = await _getAllClientsUseCase(GetAllClientsParams(page: _currentPage));
    print(result);
    result.fold(
      (failure) {
        _dialogService.showCustomDialog(
          variant: DialogType.infoAlert,
          title: 'Error',
          description: 'Failed to load clients: ${failure.message}',
        );
      },
      (clients) {
        if (clients.length < _limit) {
          _hasMoreData = false;
        }
        _clients.addAll(clients);
        _filteredClients = _clients;

        if (clients.length == _limit) {
          _currentPage++;
        }
      },
    );
    setBusy(false); // will also call notifyListener
  }

  Future<void> loadSearchClients(String query) async {
    setBusyForObject('loadSearchClients', true);
    _lastQuery = query;
    if (query.isEmpty) {
      _filteredClients = _clients;
      _hasMoreSearchData = _hasMoreData;
      _searchPage = _currentPage;
      notifyListeners();
      return;
    }

    final result = await _searchClientsUseCase(SearchParams(query: query, page: _searchPage));
    result.fold(
      (failure) {
        _dialogService.showCustomDialog(
          variant: InfoAlertDialog,
          title: 'Error',
          description: 'Failed to search clients: ${failure.message}',
        );
      },
      (clients) {
        if (clients.length < _limit) {
          _hasMoreSearchData = false;
        }
        if (_searchPage == 1) {
          _filteredClients = clients.toSet();
        } else {
          _filteredClients.addAll(clients);
        }
        if (clients.length == _limit) {
          _searchPage++;
        }
      },
    );
    setBusyForObject('loadSearchClients', false); // will also call notifyListener
  }

  void searchClients(String query) {
    _searchPage = 1;
    _hasMoreSearchData = true;
    loadSearchClients(query);
  }

  void _getClient(int clientId) async {
    setBusy(true);
    final result = await _getClientUseCase(GetClientParam(id: clientId));

    result.fold((failure) {
      _dialogService.showCustomDialog(
        variant: DialogType.infoAlert,
        title: 'Error',
        description: 'Failed to load client of id $clientId: ${failure.message}',
      );
    }, (client) {
      _clients.add(client);
    });

    setBusy(false);
  }

  void navigateToRegisterClient() async {
    final clientId = await _navigationService.navigateToRegisterClientView();
    _getClient(clientId);
  }

  void navigateToClientProfile(int clientId) async {
    await _navigationService.navigateToClientView(clientId: clientId);
    loadClients();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchScrollController.dispose();
    super.dispose();
  }
}
