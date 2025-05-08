import 'package:flutter/material.dart';
import 'package:health_managment_system/app/app.dialogs.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/app/app.router.dart';
import 'package:health_managment_system/domain/usecases/get_all_health_programs_usecase.dart';
import 'package:health_managment_system/domain/usecases/get_health_programs_usecase.dart';
import 'package:health_managment_system/domain/usecases/search_health_programs_usecase.dart';
import 'package:health_managment_system/utils/debouncer.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../domain/entities/health_program_entity.dart';

class HealthProgramsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _getHealthProgramUseCase = locator<GetHealthProgramUseCase>();
  final _getAllHealthProgramsUseCase = locator<GetAllHealthProgramsUseCase>();
  final _searchHealthProgramsUseCase = locator<SearchHealthProgramsUseCase>();

  final Set<HealthProgramEntity> _healthPrograms = {};
  Set<HealthProgramEntity> get healthPrograms => _healthPrograms;

  Set<HealthProgramEntity> _filteredPrograms = {};
  Set<HealthProgramEntity> get filteredPrograms => _filteredPrograms;

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

  HealthProgramsViewModel() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMoreData && !isBusy) {
        loadHealthPrograms();
      }
    });

    _searchScrollController.addListener(() {
      if (_searchScrollController.position.pixels == _searchScrollController.position.maxScrollExtent &&
          _hasMoreSearchData) {
        loadSearchPrograms(_lastQuery);
      }
    });
  }

  Future<void> loadHealthPrograms() async {
    setBusy(true);
    final result = await _getAllHealthProgramsUseCase(GetAllHealthProgramsParams(page: _currentPage));

    result.fold(
      (failure) {
        _dialogService.showCustomDialog(
          variant: DialogType.infoAlert,
          title: 'Error',
          description: 'Failed to load health programs: ${failure.message}',
        );
      },
      (programs) {
        if (programs.length < _limit) {
          _hasMoreData = false;
        }
        _healthPrograms.addAll(programs);
        _filteredPrograms = _healthPrograms;

        if (programs.length == _limit) {
          _currentPage++;
        }
      },
    );
    setBusy(false); // will notify the listener/  will rebuild the ui as well
  }

  Future<void> loadSearchPrograms(String query) async {
    setBusyForObject('loadSearchPrograms', true);
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
          variant: DialogType.infoAlert,
          title: 'Error',
          description: 'Failed to search health programs: ${failure.message}',
        );
      },
      (programs) {
        if (programs.length < _limit) {
          _hasMoreSearchData = false;
        }
        if (_searchPage == 1) {
          _filteredPrograms = programs.toSet();
        } else {
          _filteredPrograms.addAll(programs);
        }
        if (programs.length == _limit) {
          _searchPage++;
        }
      },
    );
    setBusyForObject('loadSearchPrograms', false); // will also call notifyListener
  }

  void searchHealthPrograms(String query) {
    _searchPage = 1;
    _hasMoreSearchData = true;
    loadSearchPrograms(query);
  }

  void _getHealthProgram(int healthProgramId) async {
    setBusy(true);
    final result = await _getHealthProgramUseCase(GetHealthProgramParam(id: healthProgramId));

    result.fold((failure) {
      _dialogService.showCustomDialog(
        variant: DialogType.infoAlert,
        title: 'Error',
        description: 'Failed to load health program of id $healthProgramId: ${failure.message}',
      );
    }, (healthProgram) {
      _healthPrograms.add(healthProgram);
    });

    setBusy(false);
  }

  void navigateToCreateHealthProgram() async {
    final healthProgramId = await _navigationService.navigateToCreateHealthProgramView();
    _getHealthProgram(healthProgramId);
  }

  void navigateToHealthProgram(int programId) {
    _navigationService.navigateToHealthProgramView(programId: programId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchScrollController.dispose();
    super.dispose();
  }
}
