import 'package:flutter/material.dart';
import 'package:health_managment_system/ui/common/ui_helpers.dart';

class HealthProgramCard extends StatelessWidget {
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final VoidCallback onTap;

  const HealthProgramCard({
    Key? key,
    required this.name,
    required this.description,
    required this.startDate,
    this.endDate,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.medical_services,
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
                      style: Theme.of(context).typography.black.headlineMedium,
                    ),
                    verticalSpaceSmall,
                    Text(
                      description,
                      style: Theme.of(context).typography.black.bodyMedium,
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
      ),
    );
  }
}
