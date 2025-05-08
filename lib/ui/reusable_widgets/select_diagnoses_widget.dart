import 'package:flutter/material.dart';
import 'package:health_managment_system/domain/entities/diagnosis_entity.dart';
import 'package:health_managment_system/enums/diagnosis_selection_mode.dart';
import 'package:health_managment_system/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';

mixin DiagnosisSelectionViewModel {
  Set<DiagnosisEntity> get selectedDiagnoses;
  void openDiagnosisSelection();
  void removeDiagnosis(DiagnosisEntity diagnosis);
}

class SelectDiagnosesWidget extends StatelessWidget {
  final DiagnosisSelectionMode diagnosisSelectionMode;
  final BaseViewModel _baseViewModel;

  const SelectDiagnosesWidget({
    super.key,
    required this.diagnosisSelectionMode,
    required BaseViewModel baseViewModel,
  }) : _baseViewModel = baseViewModel;

  @override
  Widget build(BuildContext context) {
    // run this assertion in debug mode to ensure baseViewModel provided implements DiagnosisSelectionViewModel,
    assert(
      _baseViewModel is DiagnosisSelectionViewModel,
      'baseViewModel must implement DiagnosisSelectionViewModel',
    );

    final viewModel = _baseViewModel as DiagnosisSelectionViewModel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: viewModel.openDiagnosisSelection,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  viewModel.selectedDiagnoses.isEmpty
                      ? (diagnosisSelectionMode == DiagnosisSelectionMode.single
                          ? 'Select Diagnosis'
                          : 'Select Diagnoses')
                      : diagnosisSelectionMode == DiagnosisSelectionMode.single
                          ? 'Selected Diagnosis'
                          : '(${viewModel.selectedDiagnoses.length}) Selected Diagnoses ',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        verticalSpaceSmall,
        SizedBox(
          height: diagnosisSelectionMode == DiagnosisSelectionMode.multiple && viewModel.selectedDiagnoses.length > 1
              ? 200
              : 50,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: viewModel.selectedDiagnoses
                  .map(
                    (diagnosis) => Tooltip(
                      showDuration: Duration(seconds: 4),
                      message: diagnosis.diagnosisName,
                      child: Chip(
                        label: Text(
                          overflow: TextOverflow.ellipsis,
                          diagnosis.diagnosisName.length > screenWidth(context)
                              ? diagnosis.diagnosisName
                              : diagnosis.diagnosisName,
                        ),
                        onDeleted: () => viewModel.removeDiagnosis(diagnosis),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
