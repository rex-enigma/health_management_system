import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SettingsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void logout() {
    _navigationService.clearStackAndShow(Routes.startupView);
  }
}
