import 'package:flutter/material.dart';
import 'package:health_managment_system/enums/diagnosis_selection_mode.dart';
import 'package:health_managment_system/ui/common/ui_helpers.dart';
import 'package:health_managment_system/ui/reusable_widgets/app_button.dart';
import 'package:health_managment_system/ui/reusable_widgets/app_text_field.dart';
import 'package:health_managment_system/ui/reusable_widgets/select_diagnoses_widget.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import '../../../enums/gender.dart';
import 'register_client_viewmodel.dart';

class RegisterClientView extends StackedView<RegisterClientViewModel> {
  const RegisterClientView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    RegisterClientViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Client'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'First Name*',
              controller: viewModel.firstNameController,
            ),
            verticalSpaceMedium,
            AppTextField(
              label: 'Last Name*',
              controller: viewModel.lastNameController,
            ),
            verticalSpaceMedium,
            DropdownButtonFormField<Gender>(
              decoration: InputDecoration(
                labelText: 'Gender*',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: Gender.values.map((gender) {
                return DropdownMenuItem<Gender>(
                  value: gender,
                  child: Text(gender.name),
                );
              }).toList(),
              onChanged: viewModel.setSelectedGender,
            ),
            verticalSpaceMedium,
            GestureDetector(
              onTap: () => viewModel.selectDateOfBirth(context),
              child: AbsorbPointer(
                child: AppTextField(
                  label: 'Date of Birth*',
                  controller: TextEditingController(
                    text: viewModel.dateOfBirth != null ? DateFormat('dd/MM/yyyy').format(viewModel.dateOfBirth!) : '',
                  ),
                ),
              ),
            ),
            verticalSpaceMedium,
            AppTextField(
              label: 'Contact Info*',
              controller: viewModel.contactInfoController,
            ),
            verticalSpaceMedium,
            AppTextField(
              label: 'Address',
              controller: viewModel.addressController,
            ),
            verticalSpaceMedium,
            Text(
              'Current Diagnoses',
              style: Theme.of(context).typography.black.headlineSmall,
            ),
            verticalSpaceSmall,
            SelectDiagnosesWidget(
              diagnosisSelectionMode: DiagnosisSelectionMode.multiple,
              baseViewModel: viewModel,
            ),
            verticalSpaceLarge,
            AppButton(
              label: 'Register Client',
              onPressed: () => viewModel.registerClient(),
              isLoading: viewModel.isBusy,
            ),
          ],
        ),
      ),
    );
  }

  @override
  RegisterClientViewModel viewModelBuilder(BuildContext context) => RegisterClientViewModel();
}
