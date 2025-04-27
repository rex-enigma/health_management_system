import 'package:flutter/material.dart';
import 'package:health_managment_system/ui/common/ui_helpers.dart';
import 'package:health_managment_system/ui/reusable_widgets/app_button.dart';
import 'package:health_managment_system/ui/reusable_widgets/app_text_field.dart';
import 'package:health_managment_system/ui/views/signup/signup_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SignupView extends StackedView<SignupViewModel> {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SignupViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'First Name',
              controller: viewModel.firstNameController,
            ),
            verticalSpaceMedium,
            AppTextField(
              label: 'Last Name',
              controller: viewModel.lastNameController,
            ),
            verticalSpaceMedium,
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
              label: 'Sign Up',
              onPressed: viewModel.signup,
              isLoading: viewModel.isBusy,
            ),
            verticalSpaceMedium,
            Center(
              child: TextButton(
                onPressed: viewModel.navigateToLogin,
                child: const Text('Already have an account? Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  SignupViewModel viewModelBuilder(BuildContext context) => SignupViewModel();
}
