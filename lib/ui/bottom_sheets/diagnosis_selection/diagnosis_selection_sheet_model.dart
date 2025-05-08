import 'package:flutter/material.dart';
import 'package:health_managment_system/app/app.dialogs.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/domain/entities/diagnosis_entity.dart';
import 'package:health_managment_system/domain/usecases/search_diagnoses_usecase.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/enums/diagnosis_selection_mode.dart';
import 'package:health_managment_system/utils/debouncer.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DiagnosisSelectionSheetModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _searchDiagnosesUseCase = locator<SearchDiagnosesUseCase>();
  final List<DiagnosisEntity> _diagnoses = [];
  Set<DiagnosisEntity> _selectedDiagnoses = {};
  final DiagnosisSelectionMode diagnosisSelectionMode;
  Debouncer searchQueryDebouncer = Debouncer(delayMilliseconds: 300);
  final Function(SheetResponse response) completer;

  String _searchQuery = '';
  int _page = 1;
  final int _limit = 10;
  bool _hasMore = false;
  final ScrollController _scrollController = ScrollController();

  List<DiagnosisEntity> get diagnoses => _diagnoses;
  Set<DiagnosisEntity> get selectedDiagnoses => _selectedDiagnoses;
  ScrollController get scrollController => _scrollController;
  bool get hasMore => _hasMore;

  DiagnosisSelectionSheetModel({required this.diagnosisSelectionMode, required this.completer}) {
    _scrollController.addListener(_onScroll);
  }

  // if DiagnosisSelectionMode.multiple, then should receive zero, one or more diagnoses, if isMultiSelect is false, the should receive zero or one diagnosis.
  void initState(Set<DiagnosisEntity> diagnoses) {
    _selectedDiagnoses = diagnoses;
    notifyListeners();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMore && !isBusy) {
      _fetchDiagnoses();
    }
  }

  Future<void> _fetchDiagnoses({bool isSearch = false}) async {
    if (!_hasMore && !isSearch) return;

    // Show a CircularProgressIndicator covering the entire BottomSheet only when the user is actively searching by typing
    // a query.
    if (isSearch) setBusy(true);
    final result = await _searchDiagnosesUseCase(SearchParams(
      query: _searchQuery,
      page: _page,
      limit: _limit,
    ));

    result.fold(
      (failure) {
        print('Error fetching diagnoses: ${failure.message}');
        _hasMore = false;
      },
      (newDiagnoses) {
        if (isSearch) {
          _diagnoses.clear();
          _page = 1;
        }

        _diagnoses.addAll(newDiagnoses);
        _page += 1;
        _hasMore = newDiagnoses.length == _limit;
      },
    );
    setBusy(false); // will also call notifyListener
  }

  void updateSearchQuery(String query) {
    searchQueryDebouncer.run(() {
      _searchQuery = query;
      _page = 1;
      _hasMore = true;
      _fetchDiagnoses(isSearch: true);
    });
  }

  void toggleSelection(DiagnosisEntity diagnosis) {
    if (diagnosisSelectionMode == DiagnosisSelectionMode.multiple) {
      if (_selectedDiagnoses.contains(diagnosis)) {
        _selectedDiagnoses.remove(diagnosis);
      } else {
        _selectedDiagnoses.add(diagnosis);
      }
    } else if (diagnosisSelectionMode == DiagnosisSelectionMode.single) {
      if (_selectedDiagnoses.contains(diagnosis)) {
        _selectedDiagnoses.clear();
      } else {
        _selectedDiagnoses.clear();
        _selectedDiagnoses.add(diagnosis);
      }
    }
    notifyListeners();
  }

  void confirmSelection() {
    if (_selectedDiagnoses.isEmpty) {
      _dialogService.showCustomDialog(
        variant: DialogType.infoAlert,
        title: 'Selection Error',
        description: diagnosisSelectionMode == DiagnosisSelectionMode.multiple
            ? 'Please select at least one diagnosis before confirming.'
            : 'Please select a diagnosis before confirming.',
      );
      return;
    }

    if (diagnosisSelectionMode == DiagnosisSelectionMode.multiple) {
      completer(SheetResponse(data: _selectedDiagnoses));
    } else if (diagnosisSelectionMode == DiagnosisSelectionMode.single) {
      completer(SheetResponse(data: _selectedDiagnoses.first));
    }
  }

  void cancelSelection() {
    if (_selectedDiagnoses.isNotEmpty) {
      if (diagnosisSelectionMode == DiagnosisSelectionMode.multiple) {
        completer(SheetResponse(data: _selectedDiagnoses));
      } else if (diagnosisSelectionMode == DiagnosisSelectionMode.single) {
        completer(SheetResponse(data: _selectedDiagnoses.first));
      }
    } else {
      _navigationService.back();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
