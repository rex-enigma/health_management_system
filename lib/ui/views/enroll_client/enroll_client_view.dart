import 'package:flutter/material.dart';
import 'package:health_managment_system/ui/common/ui_helpers.dart';
import 'package:health_managment_system/ui/reusable_widgets/app_button.dart';
import 'package:health_managment_system/ui/reusable_widgets/selectable_program_card.dart';
import 'package:stacked/stacked.dart';
import 'enroll_client_viewmodel.dart';

class EnrollClientView extends StackedView<EnrollClientViewModel> {
  final int clientId;

  const EnrollClientView({Key? key, required this.clientId}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    EnrollClientViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.isBusy) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enroll Client'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.healthPrograms.length,
                itemBuilder: (context, index) {
                  final program = viewModel.healthPrograms[index];
                  final isSelected = viewModel.selectedPrograms.contains(program.id);
                  final eligibilityInfo = viewModel.eligibilityInfo[program.id] ?? (true, null);
                  return SelectableProgramCard(
                    program: program,
                    isSelected: isSelected,
                    isEligible: eligibilityInfo.$1,
                    ineligibilityReason: eligibilityInfo.$2,
                    onTap: () => viewModel.toggleProgramSelection(program.id),
                  );
                },
              ),
            ),
            verticalSpaceMedium,
            AppButton(
              label: 'Enroll',
              onPressed: viewModel.enrollClient,
            ),
          ],
        ),
      ),
    );
  }

  @override
  EnrollClientViewModel viewModelBuilder(BuildContext context) => EnrollClientViewModel(clientId);

  @override
  void onViewModelReady(EnrollClientViewModel viewModel) {
    viewModel.loadData();
  }
}
