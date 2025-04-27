import 'package:flutter/material.dart';
import 'package:health_managment_system/ui/common/ui_helpers.dart';
import 'package:health_managment_system/ui/reusable_widgets/app_button.dart';
import 'package:health_managment_system/ui/reusable_widgets/app_text_field.dart';
import 'package:health_managment_system/ui/views/login/login_viewmodel.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Management system'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 30),
                ),
                verticalSpaceSmall,
                AppTextField(
                  label: 'Email',
                  controller: viewModel.emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                verticalSpaceMedium,
                AppTextField(
                  label: 'Password',
                  controller: viewModel.passwordController,
                  obscureText: true,
                ),
                verticalSpaceLarge,
                AppButton(
                  label: 'Login',
                  onPressed: viewModel.login,
                  isLoading: viewModel.isBusy,
                ),
                verticalSpaceMedium,
                Center(
                  child: TextButton(
                    onPressed: viewModel.navigateToSignup,
                    child: const Text("Don't have an account? Sign Up"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();
}
