import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'info_alert_dialog_model.dart';

class InfoAlertDialog extends StackedView<InfoAlertDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const InfoAlertDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    InfoAlertDialogModel viewModel,
    Widget? child,
  ) {
    return AlertDialog(
      title: Text(request.title ?? 'Alert'),
      content: Text(request.description ?? ''),
      actions: [
        TextButton(
          onPressed: viewModel.onCancel,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: viewModel.onConfirm,
          child: const Text('OK'),
        ),
      ],
    );
  }

  @override
  InfoAlertDialogModel viewModelBuilder(BuildContext context) =>
      InfoAlertDialogModel(completer);
}
