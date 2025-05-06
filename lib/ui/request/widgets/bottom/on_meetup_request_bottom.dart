import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/request/view_model/request_view_model.dart';
import 'package:provider/provider.dart';

import '../widget/multi_date_time_picker.dart';

class OnMeetupRequestBottom extends StatelessWidget {
  const OnMeetupRequestBottom({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestViewModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed:
              viewModel.state.selectedDate == null ||
                      viewModel.notificationData.isOpen == false
                  ? null
                  : () async {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Date confirmed successfully!")),
                      );
                      Navigator.pop(context);
                    }
                    viewModel.confirmDate();
                  },
          child: Text('Confirm', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed:
              viewModel.notificationData.isOpen == true
                  ? () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => ChangeNotifierProvider<RequestViewModel>.value(
                            value: viewModel,
                            child: Dialog(
                              insetPadding: EdgeInsets.zero,
                              child: Builder(
                                builder: (dialogContext) {
                                  final viewModelWatch =
                                      dialogContext.watch<RequestViewModel>();
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      MultiDateTimePicker(),
                                      Spacer(),
                                      ElevatedButton(
                                        onPressed:
                                            viewModelWatch
                                                    .state
                                                    .selectedDates
                                                    .isEmpty
                                                ? null
                                                : () async {
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          "New dates proposed successfully!",
                                                        ),
                                                      ),
                                                    );
                                                    Navigator.pop(context);
                                                  }
                                                  viewModelWatch
                                                      .proposeSelectedDates();
                                                },
                                        child: Text('Send New Dates'),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                    );
                  }
                  : null,
          child: Text(
            'Request Different Dates',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
