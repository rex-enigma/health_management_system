import 'package:flutter/material.dart';
import 'package:health_managment_system/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'notice_sheet_model.dart';

class NoticeSheet extends StackedView<NoticeSheetModel> {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const NoticeSheet({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    NoticeSheetModel viewModel,
    Widget? child,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Notice',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          verticalSpaceMedium,
          Text(viewModel.message),
          verticalSpaceMedium,
          ElevatedButton(
            onPressed: viewModel.onConfirm,
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  NoticeSheetModel viewModelBuilder(BuildContext context) => NoticeSheetModel(completer, request.data as String);
}
