import 'package:flutter/material.dart';
import 'package:health_managment_system/app/app.bottomsheets.dart';
import 'package:health_managment_system/app/app.dialogs.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/domain/entities/diagnosis_entity.dart';
import 'package:health_managment_system/domain/usecases/create_health_program_usecase.dart';
import 'package:health_managment_system/enums/diagnosis_selection_mode.dart';
import 'package:health_managment_system/ui/reusable_widgets/select_diagnoses_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CreateHealthProgramViewModel extends BaseViewModel with DiagnosisSelectionViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _createHealthProgramUseCase = locator<CreateHealthProgramUseCase>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final minAgeController = TextEditingController();
  final maxAgeController = TextEditingController();

  DateTime? _startDate;
  DateTime? get startDate => _startDate;

  DateTime? _endDate;
  DateTime? get endDate => _endDate;

  DiagnosisEntity? _selectedDiagnoses;
  // Returns a set containing one selected diagnosis or an empty set if none is selected.
  // This is necessary because `CreateHealthProgramView` and `RegisterClientView` reuses the `select_diagnosis_widget`,
  // which expects an iterable (like a set) of selected diagnoses.
  // In this case, `_selectedDiagnosis` represents a single diagnosis,
  // so we wrap it in a set to maintain compatibility.
  @override
  Set<DiagnosisEntity> get selectedDiagnoses => _selectedDiagnoses != null ? {_selectedDiagnoses!} : {};

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

  @override
  void openDiagnosisSelection() async {
    final result = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.diagnosisSelection,
      ignoreSafeArea: false,
      isScrollControlled: true,
      // should always be in that order
      data: (_selectedDiagnoses, DiagnosisSelectionMode.single),
    );

    _selectedDiagnoses = result?.data;
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

    if ((_endDate != null) && _endDate!.isBefore(_startDate!)) {
      _dialogService.showCustomDialog(
        variant: DialogType.infoAlert,
        title: 'Error',
        description: 'End date cannot be earlier than the start date.',
      );
      return;
    }

    final minAge = minAgeController.text.isEmpty ? null : int.tryParse(minAgeController.text);
    final maxAge = maxAgeController.text.isEmpty ? null : int.tryParse(maxAgeController.text);

    if ((maxAge != null && minAge != null) && minAge > maxAge) {
      _dialogService.showCustomDialog(
        variant: DialogType.infoAlert,
        title: 'Error',
        description: "Minimum age can't be greater that maximum age",
      );
      return;
    }

    setBusy(true);
    final result = await _createHealthProgramUseCase(CreateHealthProgramParams(
      name: nameController.text,
      description: descriptionController.text,
      startDate: _startDate!.toIso8601String(),
      endDate: _endDate?.toIso8601String(),
      eligibilityCriteria: (minAge != null || maxAge != null || _selectedDiagnoses != null)
          ? EligibilityCriteriaParams(
              minAge: minAge,
              maxAge: maxAge,
              diagnosisParams: _selectedDiagnoses != null
                  ? DiagnosisParams(
                      id: _selectedDiagnoses!.id,
                      diagnosisName: _selectedDiagnoses!.diagnosisName,
                      icd11Code: _selectedDiagnoses!.icd11Code,
                    )
                  : null)
          : null,
    ));
    result.fold(
      (failure) {
        _dialogService.showCustomDialog(
          variant: DialogType.infoAlert,
          title: 'Error',
          description: 'Failed to create health program: ${failure.message}',
        );
      },
      (healthProgram) {
        _navigationService.back(result: healthProgram.id);
      },
    );
    setBusy(false);
  }

  @override
  void removeDiagnosis(DiagnosisEntity diagnosis) {
    _selectedDiagnoses = null;
    notifyListeners();
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
