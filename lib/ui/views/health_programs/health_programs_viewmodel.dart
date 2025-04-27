import 'package:flutter/material.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/domain/usecases/get_all_health_programs_usecase.dart';
import 'package:health_managment_system/domain/usecases/search_health_programs_usecase.dart';
import 'package:health_managment_system/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../domain/entities/health_program_entity.dart';

class HealthProgramsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _getAllHealthProgramsUseCase = locator<GetAllHealthProgramsUseCase>();
  final _searchHealthProgramsUseCase = locator<SearchHealthProgramsUseCase>();

  List<HealthProgramEntity> _healthPrograms = [];
  List<HealthProgramEntity> get healthPrograms => _healthPrograms;

  List<HealthProgramEntity> _filteredPrograms = [];
  List<HealthProgramEntity> get filteredPrograms => _filteredPrograms;

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

  HealthProgramsViewModel() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMoreData) {
        loadHealthPrograms();
      }
    });

    _searchScrollController.addListener(() {
      if (_searchScrollController.position.pixels == _searchScrollController.position.maxScrollExtent && _hasMoreSearchData) {
        loadMoreSearchPrograms(_lastQuery);
      }
    });
  }

  Future<void> loadHealthPrograms() async {
    setBusy(true);
    final result = await _getAllHealthProgramsUseCase(GetAllHealthProgramsParams(page: _currentPage));
    setBusy(false);

    result.fold(
      (failure) {
        _dialogService.showCustomDialog(
          variant: InfoAlertDialog,
          title: 'Error',
          description: 'Failed to load health programs: ${failure.message}',
        );
      },
      (programs) {
        if (programs.length < 10) {
          _hasMoreData = false;
        }
        _healthPrograms.addAll(programs);
        _filteredPrograms = _healthPrograms;
        _currentPage++;
        notifyListeners();
      },
    );
  }

  Future<void> loadMoreSearchPrograms(String query) async {
    _lastQuery = query;
    if (query.isEmpty) {
      _filteredPrograms = _healthPrograms;
      _hasMoreSearchData = _hasMoreData;
      _searchPage = _currentPage;
      notifyListeners();
      return;
    }

    final result = await _searchHealthProgramsUseCase(SearchHealthProgramsParams(query: query, page: _searchPage));
    result.fold(
      (failure) {
        _dialogService.showCustomDialog(
          variant: InfoAlertDialog,
          title: 'Error',
          description: 'Failed to search health programs: ${failure.message}',
        );
      },
      (programs) {
        if (programs.length < 10) {
          _hasMoreSearchData = false;
        }
        if (_searchPage == 1) {
          _filteredPrograms = programs;
        } else {
          _filteredPrograms.addAll(programs);
        }
        _searchPage++;
        notifyListeners();
      },
    );
  }

  List<HealthProgramEntity> searchHealthPrograms(String query) {
    _searchPage = 1;
    _hasMoreSearchData = true;
    loadMoreSearchPrograms(query);
    return _filteredPrograms;
  }

  void navigateToCreateHealthProgram() {
    // _navigationService.navigateToCreateHealthProgramView();
  }

  void navigateToHealthProgram(int programId) {
    //_navigationService.navigateToHealthProgramView(programId: programId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchScrollController.dispose();
    super.dispose();
  }
}
