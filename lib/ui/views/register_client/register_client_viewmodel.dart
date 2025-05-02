import 'package:flutter/material.dart';
import 'package:health_managment_system/app/app.dialogs.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/domain/usecases/create_client_usecase.dart';
import 'package:health_managment_system/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../enums/gender.dart';
import '../../../enums/diagnosis.dart';

class RegisterClientViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _createClientUseCase = locator<CreateClientUseCase>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final contactInfoController = TextEditingController();
  final addressController = TextEditingController();

  Gender? _selectedGender = Gender.other;
  Gender? get selectedGender => _selectedGender;

  DateTime? _dateOfBirth;
  DateTime? get dateOfBirth => _dateOfBirth;

  List<Diagnosis> _selectedDiagnoses = [];
  List<Diagnosis> get selectedDiagnoses => _selectedDiagnoses;

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

  void toggleDiagnosis(Diagnosis diagnosis) {
    if (_selectedDiagnoses.contains(diagnosis)) {
      _selectedDiagnoses.remove(diagnosis);
    } else {
      _selectedDiagnoses.add(diagnosis);
    }
    notifyListeners();
  }

  Future<void> registerClient() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        contactInfoController.text.isEmpty) {
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

    final client = CreateClientParams(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      gender: _selectedGender?.name ?? Gender.other.name,
      dateOfBirth: _dateOfBirth!.toIso8601String(),
      contactInfo: contactInfoController.text,
      address: addressController.text,
      diagnosisNames: _selectedDiagnoses.map((diagnosis) => diagnosis.name).toList(),
    );

    final result = await _createClientUseCase(client);

    result.fold(
      (failure) {
        _dialogService.showCustomDialog(
          variant: DialogType.infoAlert,
          title: 'Error',
          description: 'Failed to register client: ${failure.message}',
        );
      },
      (_) {
        _navigationService.back();
      },
    );
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
