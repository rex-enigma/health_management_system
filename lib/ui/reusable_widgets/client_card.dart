import 'package:flutter/material.dart';
import 'package:health_managment_system/enums/gender.dart';
import 'package:health_managment_system/ui/common/ui_helpers.dart';
import 'package:health_managment_system/utils/calculate_age.dart';

class ClientCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final Gender gender;
  final DateTime dateOfBirth;
  final String? address;
  final VoidCallback onTap;

  const ClientCard({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    this.address,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final age = calculateAge(dateOfBirth);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        title: Text(
          '$firstName $lastName',
          style: Theme.of(context).typography.black.headlineSmall,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpaceSmall,
            Text(
              'Gender: $gender',
              style: Theme.of(context).typography.black.bodySmall,
            ),
            Text(
              'Age: $age years',
              style: Theme.of(context).typography.black.bodySmall,
            ),
            if (address != null)
              Text(
                'Address: $address',
                style: Theme.of(context).typography.black.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
