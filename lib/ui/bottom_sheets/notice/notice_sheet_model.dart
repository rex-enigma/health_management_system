import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NoticeSheetModel extends BaseViewModel {
  final Function(SheetResponse) completer;
  final String message;

  NoticeSheetModel(this.completer, this.message);

  void onConfirm() {
    completer(SheetResponse(confirmed: true));
  }
}
