import 'package:flutter/material.dart';
import 'package:health_managment_system/domain/entities/health_program_entity.dart';
import 'package:health_managment_system/ui/common/ui_helpers.dart';

class SelectableProgramCard extends StatelessWidget {
  final HealthProgramEntity program;
  final bool isSelected;
  final bool isEligible;
  final String? ineligibilityReason;
  final VoidCallback onTap;

  const SelectableProgramCard({
    Key? key,
    required this.program,
    required this.isSelected,
    required this.isEligible,
    this.ineligibilityReason,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: isEligible ? onTap : null,
        tileColor: isEligible ? null : Colors.grey[200],
        leading: Checkbox(
          value: isSelected,
          onChanged: isEligible ? (value) => onTap() : null,
        ),
        title: Text(
          program.name,
          style: Theme.of(context).typography.black.headlineSmall,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpaceSmall,
            Text(
              program.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).typography.black.bodyMedium,
            ),
            verticalSpaceSmall,
            Text(
              'Start: ${program.startDate.day}/${program.startDate.month}/${program.startDate.year}',
              style: Theme.of(context).typography.black.bodySmall,
            ),
            if (program.endDate != null)
              Text(
                'End: ${program.endDate!.day}/${program.endDate!.month}/${program.endDate!.year}',
                style: Theme.of(context).typography.black.bodySmall,
              ),
            if (!isEligible && ineligibilityReason != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Ineligible: $ineligibilityReason',
                  style: Theme.of(context).typography.black.bodySmall?.copyWith(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
