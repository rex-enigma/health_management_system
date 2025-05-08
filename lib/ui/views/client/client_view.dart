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
  Widget builder(BuildContext context, ClientViewModel viewModel, Widget? child) {
    if (viewModel.isBusy) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (viewModel.client == null) {
      return const Scaffold(
        body: Center(child: Text('Failed to load client')),
      );
    }

    final client = viewModel.client!;
    return Scaffold(
      appBar: AppBar(
        title: Text('${client.firstName} ${client.lastName}'),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.delete),
          //   onPressed: () => viewModel.showDeleteClientDialog(),
          // ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upper Section: Profile Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
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
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          verticalSpaceSmall,
                          Text(
                            'Gender: ${client.gender}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Age: ${calculateAge(client.dateOfBirth)} years',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpaceLarge,

            // Contact and Address Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(Icons.phone, color: Theme.of(context).colorScheme.primary),
                      title: Text('Contact Info'),
                      subtitle: Text(client.contactInfo),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
                      title: Text('Address'),
                      subtitle: Text(client.address ?? 'Not provided'),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpaceLarge,

            // Diagnoses Section
            Text(
              'Diagnoses',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            verticalSpaceSmall,
            client.currentDiagnoses.isEmpty
                ? const Text(
                    "None",
                    style: TextStyle(color: Colors.grey),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: client.currentDiagnoses.length,
                    itemBuilder: (context, index) {
                      final diagnosis = client.currentDiagnoses[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Icon(
                            Icons.medical_information_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(diagnosis.diagnosisName),
                          subtitle: Text('Code: ${diagnosis.icd11Code}'),
                        ),
                      );
                    },
                  ),
            verticalSpaceLarge,
            // Enrolled Programs Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enrolled Programs',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                FloatingActionButton(
                  elevation: 0,
                  onPressed: () => viewModel.navigateToEnrollClient(),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  mini: true, // Makes it smaller for subtle alignment
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            verticalSpaceSmall,
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
