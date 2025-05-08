import 'package:flutter/material.dart';
import 'package:health_managment_system/domain/entities/diagnosis_entity.dart';
import 'package:health_managment_system/enums/diagnosis_selection_mode.dart';
import 'package:health_managment_system/ui/common/ui_helpers.dart';
import 'package:health_managment_system/ui/reusable_widgets/drag_handle.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'diagnosis_selection_sheet_model.dart';

class DiagnosisSelectionSheet extends StackedView<DiagnosisSelectionSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;
  const DiagnosisSelectionSheet({
    super.key,
    required this.completer,
    required this.request,
  });

  @override
  Widget builder(BuildContext context, DiagnosisSelectionSheetModel viewModel, Widget? child) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: screenHeight(context) * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const DragHandle(),
            verticalSpaceSmall,
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Diagnoses',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: viewModel.updateSearchQuery,
            ),
            const SizedBox(height: 16),
            // Diagnoses List with Infinite Scrolling
            Expanded(
              child: viewModel.isBusy
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.diagnoses.isEmpty
                      ? Center(child: Text('Search for condition'))
                      : ListView.builder(
                          controller: viewModel.scrollController,
                          itemCount: viewModel.diagnoses.length + (viewModel.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == viewModel.diagnoses.length) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            final diagnosis = viewModel.diagnoses[index];
                            final isSelected = viewModel.selectedDiagnoses.contains(diagnosis);
                            return ListTile(
                              title: Text(diagnosis.diagnosisName),
                              subtitle: Text('ICD-11: ${diagnosis.icd11Code}'),
                              trailing: isSelected
                                  ? const Icon(Icons.check_circle, color: Colors.green)
                                  : const Icon(Icons.circle_outlined),
                              onTap: () => viewModel.toggleSelection(diagnosis),
                            );
                          },
                        ),
            ),
            const SizedBox(height: 16),
            // Confirm and Cancel Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: viewModel.cancelSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: viewModel.selectedDiagnoses.isNotEmpty ? viewModel.confirmSelection : null,
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  DiagnosisSelectionSheetModel viewModelBuilder(BuildContext context) {
    assert(request.data.$2 is DiagnosisSelectionMode);
    final DiagnosisSelectionMode diagnosisSelectionMode = request.data.$2;
    return DiagnosisSelectionSheetModel(diagnosisSelectionMode: diagnosisSelectionMode, completer: completer!);
  }

  @override
  void onViewModelReady(DiagnosisSelectionSheetModel viewModel) {
    // if true, the navigation is coming from [RegisterClientViewModel.openDiagnosisSelection] method invocation
    if (request.data.$1 is Set<DiagnosisEntity>) {
      viewModel.initState(request.data.$1);
      // if true, the navigation is coming from CreateHealthProgramViewModel.openDiagnosisSelection] method invocation
    } else if (request.data.$1 != null && request.data.$1 is DiagnosisEntity) {
      viewModel.initState({request.data.$1});
    }
  }
}
