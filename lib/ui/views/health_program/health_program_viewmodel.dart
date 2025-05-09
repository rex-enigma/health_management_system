import 'package:health_managment_system/app/app.dialogs.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/app/app.router.dart';
import 'package:health_managment_system/domain/usecases/delete_health_program_usecase.dart';
import 'package:health_managment_system/domain/usecases/get_health_programs_usecase.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../domain/entities/health_program_entity.dart';

class HealthProgramViewModel extends BaseViewModel {
  final int programId;
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _getHealthProgramUseCase = locator<GetHealthProgramUseCase>();
  final _deleteHealthProgramUseCase = locator<DeleteHealthProgramUseCase>();

  HealthProgramEntity? _healthProgram;
  HealthProgramEntity? get healthProgram => _healthProgram;

  HealthProgramViewModel(this.programId);

  Future<void> loadHealthProgram() async {
    setBusy(true);
    final result = await _getHealthProgramUseCase(GetHealthProgramParam(id: programId));

    result.fold(
      (failure) {
        _dialogService.showCustomDialog(
          variant: DialogType.infoAlert,
          title: 'Error',
          description: 'Failed to load health program: ${failure.message}',
        );
      },
      (program) {
        _healthProgram = program;
      },
    );
    setBusy(false); // will also call notifyListener
  }

  Future<void> showDeleteProgramDialog() async {
    final response = await _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Delete Health Program',
      description: 'Are you sure you want to delete this health program?',
    );
    if (response?.confirmed ?? false) {
      final result = await _deleteHealthProgramUseCase(DeleteHealthProgramParams(id: programId));
      result.fold(
        (failure) {
          _dialogService.showCustomDialog(
            variant: DialogType.infoAlert,
            title: 'Error',
            description: 'Failed to delete health program: ${failure.message}',
          );
        },
        (_) {
          _navigationService.back();
          _navigationService.navigateToHomeView(); //resets HomeView as the last route in the nav stack.
        },
      );
    }
  }
}
