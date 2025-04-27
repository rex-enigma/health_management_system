import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class InfoAlertDialogModel extends BaseViewModel {
  final Function(DialogResponse) completer;

  InfoAlertDialogModel(this.completer);

  void onCancel() {
    completer(DialogResponse(confirmed: false));
  }

  void onConfirm() {
    completer(DialogResponse(confirmed: true));
  }
}
