import 'package:health_managment_system/app/app.dialogs.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/app/app.router.dart';
import 'package:health_managment_system/domain/entities/client_entity.dart';
import 'package:health_managment_system/domain/usecases/delete_client_usecase.dart';
import 'package:health_managment_system/domain/usecases/get_client_usecase.dart';
import 'package:health_managment_system/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ClientViewModel extends BaseViewModel {
  final int clientId;
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _getClientUseCase = locator<GetClientUseCase>();
  final _deleteClientUseCase = locator<DeleteClientUseCase>();

  ClientEntity? _client;
  ClientEntity? get client => _client;

  ClientViewModel(this.clientId);

  Future<void> loadClient() async {
    setBusy(true);
    final result = await _getClientUseCase(GetClientParam(id: clientId));

    result.fold(
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
    setBusy(false); // will also call notifyListener
  }

  Future<void> showDeleteClientDialog() async {
    final response = await _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Delete Client',
      description: 'Are you sure you want to delete this client?',
    );
    if (response?.confirmed ?? false) {
      final result = await _deleteClientUseCase(DeleteClientParams(id: clientId));
      result.fold(
        (failure) {
          _dialogService.showCustomDialog(
            variant: DialogType.infoAlert,
            title: 'Error',
            description: 'Failed to delete client: ${failure.message}',
          );
        },
        (_) {
          _navigationService.back();

          ///
        },
      );
    }
  }

  void navigateToEnrollClient() async {
    await _navigationService.navigateToEnrollClientView(clientId: clientId);
    await loadClient();
  }
}
