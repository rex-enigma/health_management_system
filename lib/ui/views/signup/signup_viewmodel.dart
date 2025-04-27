import 'package:flutter/material.dart';
import 'package:health_managment_system/app/app.locator.dart';
import 'package:health_managment_system/app/app.router.dart';
import 'package:health_managment_system/domain/usecases/sign_up_usecase.dart';
import 'package:health_managment_system/domain/usecases/usecase.dart';
import 'package:health_managment_system/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _signupUseCase = locator<SignupUseCase>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signup() async {
    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      _dialogService.showCustomDialog(
        variant: InfoAlertDialog,
        title: 'Error',
        description: 'Username, email, and password are required.',
      );
      return;
    }

    setBusy(true);
    final result = await _signupUseCase(SignupParams(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    ));
    setBusy(false);

    result.fold(
      (failure) {
        _dialogService.showCustomDialog(
          variant: InfoAlertDialog,
          title: 'Error',
          description: 'Signup failed: ${failure.message}',
        );
      },
      (user) {
        _navigationService.clearStackAndShow(Routes.homeView);
      },
    );
  }

  void navigateToLogin() {
    _navigationService.navigateToLoginView();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
