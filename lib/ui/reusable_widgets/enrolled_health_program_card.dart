import 'package:flutter/material.dart';
import 'package:health_managment_system/ui/common/ui_helpers.dart';

class EnrolledProgramCard extends StatelessWidget {
  final String name;
  final DateTime startDate;
  final DateTime? endDate;

  const EnrolledProgramCard({
    super.key,
    required this.name,
    required this.startDate,
    this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: getResponsiveMediumFontSize(context) * 1.5,
              ),
            ),
            horizontalSpaceMedium,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).typography.black.bodyLarge,
                  ),
                  verticalSpaceSmall,
                  Text(
                    'Start: ${startDate.day}/${startDate.month}/${startDate.year}',
                    style: Theme.of(context).typography.black.bodySmall,
                  ),
                  if (endDate != null)
                    Text(
                      'End: ${endDate!.day}/${endDate!.month}/${endDate!.year}',
                      style: Theme.of(context).typography.black.bodySmall,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
