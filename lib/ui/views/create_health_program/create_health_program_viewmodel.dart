import 'package:flutter/material.dart';
import 'package:health_managment_system/app/app.dialogs.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/domain/usecases/create_health_program_usecase.dart';
import 'package:health_managment_system/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../domain/entities/health_program_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../enums/diagnosis.dart';

class CreateHealthProgramViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _createHealthProgramUseCase = locator<CreateHealthProgramUseCase>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final minAgeController = TextEditingController();
  final maxAgeController = TextEditingController();

  DateTime? _startDate;
  DateTime? get startDate => _startDate;

  DateTime? _endDate;
  DateTime? get endDate => _endDate;

  Diagnosis? _requiredDiagnosis = Diagnosis.none;
  Diagnosis? get requiredDiagnosis => _requiredDiagnosis;

  Future<void> selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _startDate = picked;
      notifyListeners();
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _endDate = picked;
      notifyListeners();
    }
  }

  void setSelectedDiagnosis(Diagnosis? diagnosis) {
    _requiredDiagnosis = diagnosis;
    notifyListeners();
  }

  Future<void> createHealthProgram() async {
    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
      _dialogService.showCustomDialog(
        variant: DialogType.infoAlert,
        title: 'Error',
        description: 'Name and description are required.',
      );
      return;
    }

    if (_startDate == null) {
      _dialogService.showCustomDialog(
        variant: DialogType.infoAlert,
        title: 'Error',
        description: 'Start date is required.',
      );
      return;
    }

    final minAge = minAgeController.text.isEmpty ? null : int.tryParse(minAgeController.text);
    final maxAge = maxAgeController.text.isEmpty ? null : int.tryParse(maxAgeController.text);

    setBusy(true);
    final result = await _createHealthProgramUseCase(CreateHealthProgramParams(
      name: nameController.text,
      description: descriptionController.text,
      startDate: _startDate!.toIso8601String(),
      endDate: _endDate?.toIso8601String(),
      eligibilityCriteria: (minAge != null || maxAge != null || _requiredDiagnosis != Diagnosis.none)
          ? {
              'min_age': minAge,
              'max_age': maxAge,
              'required_diagnosis': _requiredDiagnosis?.name ?? Diagnosis.none.name,
            }
          : null,
    ));
    setBusy(false);
    result.fold(
      (failure) {
        _dialogService.showCustomDialog(
          variant: DialogType.infoAlert,
          title: 'Error',
          description: 'Failed to create health program: ${failure.message}',
        );
      },
      (_) {
        _navigationService.back();
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    minAgeController.dispose();
    maxAgeController.dispose();
    super.dispose();
  }
}
