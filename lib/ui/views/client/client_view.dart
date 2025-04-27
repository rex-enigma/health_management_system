import 'package:flutter/material.dart';
import 'package:health_managment_system/ui/common/ui_helpers.dart';
import 'package:health_managment_system/ui/reusable_widgets/enrolled_health_program_card.dart';
import 'package:health_managment_system/ui/views/client/client_viewmodel.dart';
import 'package:health_managment_system/utils/calculate_age.dart';
import 'package:stacked/stacked.dart';

class ClientView extends StackedView<ClientViewModel> {
  final int clientId;

  const ClientView({Key? key, required this.clientId}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ClientViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.isBusy) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (viewModel.client == null) {
      return const Scaffold(
        body: Center(child: Text('Client not found')),
      );
    }

    final client = viewModel.client!;
    return Scaffold(
      appBar: AppBar(
        title: Text('${client.firstName} ${client.lastName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => viewModel.showDeleteClientDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                horizontalSpaceMedium,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${client.firstName} ${client.lastName}',
                        style: Theme.of(context).typography.black.headlineLarge,
                      ),
                      verticalSpaceSmall,
                      Text(
                        'Gender: ${client.gender}',
                        style: Theme.of(context).typography.black.bodyMedium,
                      ),
                      Text(
                        'Age: ${calculateAge(client.dateOfBirth)} years',
                        style: Theme.of(context).typography.black.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            verticalSpaceLarge,
            Text(
              'Contact Info: ${client.contactInfo}',
              style: Theme.of(context).typography.black.bodyMedium,
            ),
            verticalSpaceMedium,
            Text(
              'Address: ${client.address ?? "Not provided"}',
              style: Theme.of(context).typography.black.bodyMedium,
            ),
            verticalSpaceMedium,
            Text(
              'Diagnoses: ${client.currentDiagnoses.isEmpty ? "None" : client.currentDiagnoses.join(", ")}',
              style: Theme.of(context).typography.black.bodyMedium,
            ),
            verticalSpaceLarge,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enrolled Programs',
                  style: Theme.of(context).typography.black.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => viewModel.navigateToEnrollClient(),
                ),
              ],
            ),
            verticalSpaceMedium,
            client.enrolledPrograms.isEmpty
                ? const Text('No enrolled programs')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: client.enrolledPrograms.length,
                    itemBuilder: (context, index) {
                      final program = client.enrolledPrograms[index];
                      return EnrolledProgramCard(
                        name: program.name,
                        startDate: program.startDate,
                        endDate: program.endDate,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  @override
  ClientViewModel viewModelBuilder(BuildContext context) => ClientViewModel(clientId);

  @override
  void onViewModelReady(ClientViewModel viewModel) {
    viewModel.loadClient();
  }
}
