import 'package:flutter/material.dart';
import 'package:health_managment_system/app/app.dialogs.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/domain/entities/client.dart';
import 'package:health_managment_system/domain/usecases/get_all_clients_usecase.dart';
import 'package:health_managment_system/domain/usecases/search_clients_usecase.dart';
import 'package:health_managment_system/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ClientsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _getAllClientsUseCase = locator<GetAllClientsUseCase>();
  final _searchClientsUseCase = locator<SearchClientsUseCase>();

  List<ClientEntity> _clients = [];
  List<ClientEntity> get clients => _clients;

  List<ClientEntity> _filteredClients = [];
  List<ClientEntity> get filteredClients => _filteredClients;

  int _currentPage = 1;
  int _searchPage = 1;
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
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMoreData) {
        loadClients();
      }
    });

    _searchScrollController.addListener(() {
      if (_searchScrollController.position.pixels == _searchScrollController.position.maxScrollExtent && _hasMoreSearchData) {
        loadMoreSearchClients(_lastQuery);
      }
    });
  }

  Future<void> loadClients() async {
    setBusy(true);
    final result = await _getAllClientsUseCase(GetAllClientsParams(page: _currentPage));
    setBusy(false);

    result.fold(
      (failure) {
        _dialogService.showCustomDialog(
          variant: DialogType.infoAlert,
          title: 'Error',
          description: 'Failed to load clients: ${failure.message}',
        );
      },
      (clients) {
        if (clients.length < 10) {
          _hasMoreData = false;
        }
        _clients.addAll(clients);
        _filteredClients = _clients;
        _currentPage++;
        notifyListeners();
      },
    );
  }

  Future<void> loadMoreSearchClients(String query) async {
    _lastQuery = query;
    if (query.isEmpty) {
      _filteredClients = _clients;
      _hasMoreSearchData = _hasMoreData;
      _searchPage = _currentPage;
      notifyListeners();
      return;
    }

    final result = await _searchClientsUseCase(SearchClientsParams(query: query, page: _searchPage));
    result.fold(
      (failure) {
        _dialogService.showCustomDialog(
          variant: InfoAlertDialog,
          title: 'Error',
          description: 'Failed to search clients: ${failure.message}',
        );
      },
      (clients) {
        if (clients.length < 10) {
          _hasMoreSearchData = false;
        }
        if (_searchPage == 1) {
          _filteredClients = clients;
        } else {
          _filteredClients.addAll(clients);
        }
        _searchPage++;
        notifyListeners();
      },
    );
  }

  List<ClientEntity> searchClients(String query) {
    _searchPage = 1;
    _hasMoreSearchData = true;
    loadMoreSearchClients(query);
    return _filteredClients;
  }

  void navigateToRegisterClient() {
    // _navigationService.navigateToRegisterClientView();
  }

  void navigateToClientProfile(int clientId) {
    // _navigationService.navigateToClientProfileView(clientId: clientId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchScrollController.dispose();
    super.dispose();
  }
}
