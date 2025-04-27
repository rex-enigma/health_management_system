import 'package:flutter/material.dart';
import 'package:health_managment_system/ui/common/ui_helpers.dart';
import 'package:health_managment_system/ui/views/health_program/health_program_viewmodel.dart';
import 'package:stacked/stacked.dart';

class HealthProgramView extends StackedView<HealthProgramViewModel> {
  final int programId;

  const HealthProgramView({Key? key, required this.programId}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HealthProgramViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.isBusy) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (viewModel.healthProgram == null) {
      return const Scaffold(
        body: Center(child: Text('Health program not found')),
      );
    }

    final program = viewModel.healthProgram!;
    return Scaffold(
      appBar: AppBar(
        title: Text(program.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => viewModel.showDeleteProgramDialog(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              program.description,
              style: Theme.of(context).typography.black.bodyLarge,
            ),
            verticalSpaceMedium,
            Text(
              'Start Date: ${program.startDate.day}/${program.startDate.month}/${program.startDate.year}',
              style: Theme.of(context).typography.black.bodyMedium,
            ),
            if (program.endDate != null)
              Text(
                'End Date: ${program.endDate!.day}/${program.endDate!.month}/${program.endDate!.year}',
                style: Theme.of(context).typography.black.bodyMedium,
              ),
            verticalSpaceMedium,
            if (program.eligibilityCriteria != null) ...[
              Text(
                'Eligibility Criteria:',
                style: Theme.of(context).typography.black.headlineSmall,
              ),
              verticalSpaceSmall,
              if (program.eligibilityCriteria!.minAge != null)
                Text(
                  'Minimum Age: ${program.eligibilityCriteria!.minAge}',
                  style: Theme.of(context).typography.black.bodyMedium,
                ),
              if (program.eligibilityCriteria!.maxAge != null)
                Text(
                  'Maximum Age: ${program.eligibilityCriteria!.maxAge}',
                  style: Theme.of(context).typography.black.bodyMedium,
                ),
              Text(
                'Required Diagnosis: ${program.eligibilityCriteria!.requiredDiagnosis}',
                style: Theme.of(context).typography.black.bodyMedium,
              ),
            ],
            verticalSpaceMedium,
            Text(
              'Created By: ${program.createdByUser.firstName}',
              style: Theme.of(context).typography.black.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  @override
  HealthProgramViewModel viewModelBuilder(BuildContext context) => HealthProgramViewModel(programId);

  @override
  void onViewModelReady(HealthProgramViewModel viewModel) {
    viewModel.loadHealthProgram();
  }
}
