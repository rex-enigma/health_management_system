import 'package:flutter/material.dart';
import 'package:health_managment_system/app/app.dialogs.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/domain/entities/client_entity.dart';
import 'package:health_managment_system/domain/usecases/enroll_client_usecase.dart';
import 'package:health_managment_system/domain/usecases/get_all_health_programs_usecase.dart';
import 'package:health_managment_system/domain/usecases/get_client_usecase.dart';
import 'package:health_managment_system/utils/calculate_age.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../domain/entities/health_program_entity.dart';

class EnrollClientViewModel extends BaseViewModel {
  final int clientId;
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _getClientUseCase = locator<GetClientUseCase>();
  final _getAllHealthProgramsUseCase = locator<GetAllHealthProgramsUseCase>();
  final _enrollClientUseCase = locator<EnrollClientUseCase>();

  List<HealthProgramEntity> _healthPrograms = [];
  List<HealthProgramEntity> get healthPrograms => _healthPrograms;

  final List<int> _selectedProgramIds = [];
  List<int> get selectedProgramIds => _selectedProgramIds;

  Map<int, (bool, String?)> _eligibilityInfo = {};
  Map<int, (bool, String?)> get eligibilityInfo => _eligibilityInfo;

  ClientEntity? _client;
  ClientEntity? get client => _client;

  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMoreData = true;
  bool get hasMoreData => _hasMoreData;

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  EnrollClientViewModel(this.clientId) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          _hasMoreData &&
          !busy('loadMoreHealthPrograms')) {
        loadMoreHealthPrograms();
      }
    });
  }

  Future<void> loadData() async {
    setBusy(true);

    final clientResult = await _getClientUseCase(GetClientParam(id: clientId));
    final programsResult = await _getAllHealthProgramsUseCase(GetAllHealthProgramsParams(page: _currentPage));

    clientResult.fold(
      (failure) {
        _dialogService.showCustomDialog(
          variant: DialogType.infoAlert,
          title: 'Error',
          description: 'Failed to load client: ${failure.message}',
        );
      },
      (client) {
        _client = client;
      },
    );

    programsResult.fold(
      (failure) {
        _dialogService.showCustomDialog(
          variant: DialogType.infoAlert,
          title: 'Error',
          description: 'Failed to load health programs: ${failure.message}',
        );
      },
      (programs) {
        _healthPrograms = programs;
        _hasMoreData =
            programs.length == _limit; // assume more data if all the entries of a page (all entries == 10) are returned
        // filter out health programs which the client is already enrolled in
        _healthPrograms.removeWhere((program) => _client!.enrolledPrograms.any((p) => p.id == program.id));

        _eligibilityInfo = _computeEligibilityInfo(_healthPrograms, _client!);
      },
    );

    setBusy(false); // will also call notifyListener
  }

  Future<void> loadMoreHealthPrograms() async {
    if (!_hasMoreData) return;

    // sets busy to true for only loadMoreHealthPrograms method
    setBusyForObject('loadMoreHealthPrograms', true);
    final programsResult = await _getAllHealthProgramsUseCase(GetAllHealthProgramsParams(page: _currentPage + 1));

    programsResult.fold(
      (failure) {
        _dialogService.showCustomDialog(
          variant: DialogType.infoAlert,
          title: 'Error',
          description: 'Failed to load more health programs: ${failure.message}',
        );
      },
      (programs) {
        _hasMoreData = programs.length == _limit;

        // filter out duplicates and client already enrolled programs
        final newPrograms = programs
            .where((program) =>
                !_healthPrograms.any((p) => p.id == program.id) &&
                !_client!.enrolledPrograms.any((p) => p.id == program.id))
            .toList();
        _healthPrograms.addAll(newPrograms);

        _eligibilityInfo = _computeEligibilityInfo(_healthPrograms, _client!);

        if (newPrograms.isNotEmpty) {
          _currentPage++;
        }
      },
    );

    setBusyForObject('loadMoreHealthPrograms', false); // will also call notifyListener
  }

  Map<int, (bool, String?)> _computeEligibilityInfo(List<HealthProgramEntity> programs, ClientEntity client) {
    final eligibilityInfo = <int, (bool, String?)>{};
    for (var healthProgram in _healthPrograms) {
      if (healthProgram.eligibilityCriteria != null) {
        final isEligible = healthProgram.isClientEligible(_client!);
        String? reason;
        if (!isEligible) {
          final age = calculateAge(_client!.dateOfBirth);
          if (healthProgram.eligibilityCriteria!.minAge != null && age < healthProgram.eligibilityCriteria!.minAge!) {
            reason = 'Client is too young (Min age: ${healthProgram.eligibilityCriteria!.minAge})';
          } else if (healthProgram.eligibilityCriteria!.maxAge != null &&
              age > healthProgram.eligibilityCriteria!.maxAge!) {
            reason = 'Client is too old (Max age: ${healthProgram.eligibilityCriteria!.maxAge})';
          } else if (healthProgram.eligibilityCriteria!.diagnosis != null) {
            reason =
                'Client does not have required diagnosis: ${healthProgram.eligibilityCriteria!.diagnosis?.diagnosisName}';
          }
        }
        eligibilityInfo[healthProgram.id] = (isEligible, reason);
      } else {
        eligibilityInfo[healthProgram.id] = (true, null);
      }
    }
    return eligibilityInfo;
  }

  void toggleProgramSelection(int programId) {
    if (_selectedProgramIds.contains(programId)) {
      _selectedProgramIds.remove(programId);
    } else {
      _selectedProgramIds.add(programId);
    }
    notifyListeners();
  }

  Future<void> enrollClient() async {
    setBusy(true);
    if (_selectedProgramIds.isEmpty) {
      _dialogService.showCustomDialog(
        variant: DialogType.infoAlert,
        title: 'Error',
        description: 'Please select at least one program.',
      );
      setBusy(false);
      return;
    }

    final result = await _enrollClientUseCase(EnrollClientParams(
      clientId: clientId,
      healthProgramIds: _selectedProgramIds,
    ));

    result.fold(
      (failure) {
        _dialogService.showCustomDialog(
          variant: DialogType.infoAlert,
          title: 'Error',
          description: 'Failed to enroll client: ${failure.message}',
        );
      },
      (_) {
        _navigationService.back();
      },
    );
    setBusy(false);
  }
}
