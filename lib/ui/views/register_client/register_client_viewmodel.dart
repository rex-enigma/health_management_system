import 'package:flutter/material.dart';
import 'package:health_managment_system/app/app.bottomsheets.dart';
import 'package:health_managment_system/app/app.dialogs.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/domain/entities/diagnosis_entity.dart';
import 'package:health_managment_system/domain/usecases/create_client_usecase.dart';
import 'package:health_managment_system/enums/diagnosis_selection_mode.dart';
import 'package:health_managment_system/ui/reusable_widgets/select_diagnoses_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../enums/gender.dart';

class RegisterClientViewModel extends BaseViewModel with DiagnosisSelectionViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _createClientUseCase = locator<CreateClientUseCase>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final contactInfoController = TextEditingController();
  final addressController = TextEditingController();

  Gender? _selectedGender;
  Gender? get selectedGender => _selectedGender;

  DateTime? _dateOfBirth;
  DateTime? get dateOfBirth => _dateOfBirth;

  Set<DiagnosisEntity> _selectedDiagnoses = {};
  @override
  Set<DiagnosisEntity> get selectedDiagnoses => _selectedDiagnoses;

  void setSelectedGender(Gender? gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  Future<void> selectDateOfBirth(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dateOfBirth = picked;
      notifyListeners();
    }
  }

  @override
  Future<void> openDiagnosisSelection() async {
    final result = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.diagnosisSelection,
      ignoreSafeArea: false,
      isScrollControlled: true,
      // should always be in that order
      data: (_selectedDiagnoses, DiagnosisSelectionMode.multiple),
    );

    _selectedDiagnoses = result?.data ?? {};
    notifyListeners();
  }

  @override
  void removeDiagnosis(DiagnosisEntity diagnosis) {
    _selectedDiagnoses.remove(diagnosis);
    notifyListeners();
  }

  Future<void> registerClient() async {
    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty || contactInfoController.text.isEmpty) {
      _dialogService.showCustomDialog(
        variant: DialogType.infoAlert,
        title: 'Error',
        description: 'First name, last name, and contact info are required.',
      );
      return;
    }

    if (_dateOfBirth == null) {
      _dialogService.showCustomDialog(
        variant: DialogType.infoAlert,
        title: 'Error',
        description: 'Date of birth is required.',
      );
      return;
    }

    if (_selectedGender == null) {
      _dialogService.showCustomDialog(
        variant: DialogType.infoAlert,
        title: 'Error',
        description: 'Gender is required.',
      );
      return;
    }

    final client = CreateClientParams(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      gender: _selectedGender!.name,
      dateOfBirth: _dateOfBirth!.toIso8601String(),
      contactInfo: contactInfoController.text,
      address: addressController.text,
      diagnosisIds: _selectedDiagnoses.map((diagnosis) => diagnosis.id).toList(),
    );

    setBusy(true);
    final result = await _createClientUseCase(client);

    result.fold(
      (failure) {
        _dialogService.showCustomDialog(
          variant: DialogType.infoAlert,
          title: 'Error',
          description: 'Failed to register client: ${failure.message}',
        );
      },
      (client) {
        _navigationService.back(result: client.id);
      },
    );
    setBusy(false); // will also call notifyListener
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    contactInfoController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
