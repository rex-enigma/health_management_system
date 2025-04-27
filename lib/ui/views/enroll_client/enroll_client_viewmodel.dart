import 'package:health_managment_system/app/app.bottomsheets.dart';
import 'package:health_managment_system/app/app.dialogs.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/domain/entities/client.dart';
import 'package:health_managment_system/domain/usecases/enroll_client_usecase.dart';
import 'package:health_managment_system/domain/usecases/get_all_health_programs_usecase.dart';
import 'package:health_managment_system/domain/usecases/get_client_usecase.dart';
import 'package:health_managment_system/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:health_managment_system/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../domain/entities/health_program_entity.dart';
import '../../../errors/failures.dart';

class EnrollClientViewModel extends BaseViewModel {
  final int clientId;
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _getClientUseCase = locator<GetClientUseCase>();
  final _getAllHealthProgramsUseCase = locator<GetAllHealthProgramsUseCase>();
  final _enrollClientUseCase = locator<EnrollClientUseCase>();

  List<HealthProgramEntity> _healthPrograms = [];
  List<HealthProgramEntity> get healthPrograms => _healthPrograms;

  List<int> _selectedPrograms = [];
  List<int> get selectedPrograms => _selectedPrograms;

  Map<int, (bool, String?)> _eligibilityInfo = {};
  Map<int, (bool, String?)> get eligibilityInfo => _eligibilityInfo;

  ClientEntity? _client;
  ClientEntity? get client => _client;

  EnrollClientViewModel(this.clientId);

  Future<void> loadData() async {
    setBusy(true);

    final clientResult = await _getClientUseCase(GetClientParams(id: clientId));
    final programsResult = await _getAllHealthProgramsUseCase(GetAllHealthProgramsParams(page: 1));

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
        _healthPrograms.removeWhere((program) => _client!.enrolledPrograms.any((p) => p.id == program.id));

        _eligibilityInfo = {};
        for (var program in _healthPrograms) {
          if (program.eligibilityCriteria != null) {
            final isEligible = program.eligibilityCriteria!.isClientEligible(_client!);
            String? reason;
            if (!isEligible) {
              final age = _client!.dateOfBirth != null ? DateTime.now().year - _client!.dateOfBirth!.year : null;
              if (program.eligibilityCriteria!.minAge != null && (age == null || age < program.eligibilityCriteria!.minAge!)) {
                reason = 'Client is too young (Min age: ${program.eligibilityCriteria!.minAge})';
              } else if (program.eligibilityCriteria!.maxAge != null && (age == null || age > program.eligibilityCriteria!.maxAge!)) {
                reason = 'Client is too old (Max age: ${program.eligibilityCriteria!.maxAge})';
              } else if (!_client!.currentDiagnoses.contains(program.eligibilityCriteria!.requiredDiagnosis)) {
                reason = 'Client does not have required diagnosis: ${program.eligibilityCriteria!.requiredDiagnosis}';
              }
            }
            _eligibilityInfo[program.id] = (isEligible, reason);
          } else {
            _eligibilityInfo[program.id] = (true, null);
          }
        }
      },
    );

    setBusy(false);
    notifyListeners();
  }

  void toggleProgramSelection(int programId) {
    if (_selectedPrograms.contains(programId)) {
      _selectedPrograms.remove(programId);
    } else {
      _selectedPrograms.add(programId);
    }
    notifyListeners();
  }

  Future<void> enrollClient() async {
    if (_selectedPrograms.isEmpty) {
      _dialogService.showCustomDialog(
        variant: DialogType.infoAlert,
        title: 'Error',
        description: 'Please select at least one program.',
      );
      return;
    }

    final result = await _enrollClientUseCase(EnrollClientParams(
      clientId: clientId,
      healthProgramIds: _selectedPrograms,
    ));

    result.fold(
      (failure) {
        if (failure is IneligibleClientFailure) {
          _bottomSheetService.showCustomSheet(
            variant: BottomSheetType.notice,
            data: 'Client is not eligible for programs with IDs: ${failure.ineligibleHealthProgramIds.join(", ")}',
          );
        } else {
          _dialogService.showCustomDialog(
            variant: DialogType.infoAlert,
            title: 'Error',
            description: 'Failed to enroll client: ${failure.message}',
          );
        }
      },
      (_) {
        _navigationService.back();
      },
    );
  }
}
