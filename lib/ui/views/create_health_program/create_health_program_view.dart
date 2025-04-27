import 'package:flutter/material.dart';

import 'package:health_managment_system/ui/common/ui_helpers.dart';
import 'package:health_managment_system/ui/reusable_widgets/app_button.dart';
import 'package:health_managment_system/ui/reusable_widgets/app_text_field.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import '../../../enums/diagnosis.dart';
import 'create_health_program_viewmodel.dart';

class CreateHealthProgramView extends StackedView<CreateHealthProgramViewModel> {
  const CreateHealthProgramView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CreateHealthProgramViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Health Program'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Name',
              controller: viewModel.nameController,
            ),
            verticalSpaceMedium,
            AppTextField(
              label: 'Description',
              controller: viewModel.descriptionController,
            ),
            verticalSpaceMedium,
            GestureDetector(
              onTap: () => viewModel.selectStartDate(context),
              child: AbsorbPointer(
                child: AppTextField(
                  label: 'Start Date',
                  controller: TextEditingController(
                    text: viewModel.startDate != null ? DateFormat('dd/MM/yyyy').format(viewModel.startDate!) : '',
                  ),
                ),
              ),
            ),
            verticalSpaceMedium,
            GestureDetector(
              onTap: () => viewModel.selectEndDate(context),
              child: AbsorbPointer(
                child: AppTextField(
                  label: 'End Date (Optional)',
                  controller: TextEditingController(
                    text: viewModel.endDate != null ? DateFormat('dd/MM/yyyy').format(viewModel.endDate!) : '',
                  ),
                ),
              ),
            ),
            verticalSpaceMedium,
            Text(
              'Eligibility Criteria (Optional)',
              style: Theme.of(context).typography.black.headlineSmall,
            ),
            verticalSpaceSmall,
            AppTextField(
              label: 'Minimum Age',
              controller: viewModel.minAgeController,
              keyboardType: TextInputType.number,
            ),
            verticalSpaceMedium,
            AppTextField(
              label: 'Maximum Age',
              controller: viewModel.maxAgeController,
              keyboardType: TextInputType.number,
            ),
            verticalSpaceMedium,
            DropdownButtonFormField<Diagnosis>(
              value: viewModel.requiredDiagnosis,
              decoration: InputDecoration(
                labelText: 'Required Diagnosis',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: Diagnosis.values.map((diagnosis) {
                return DropdownMenuItem<Diagnosis>(
                  value: diagnosis,
                  child: Text(diagnosis.name),
                );
              }).toList(),
              onChanged: viewModel.setSelectedDiagnosis,
            ),
            verticalSpaceLarge,
            AppButton(
              label: 'Create Program',
              onPressed: () => viewModel.createHealthProgram(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  CreateHealthProgramViewModel viewModelBuilder(BuildContext context) => CreateHealthProgramViewModel();
}
