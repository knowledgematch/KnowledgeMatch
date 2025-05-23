import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/user.dart';
import 'package:knowledgematch/ui/request/view_model/request_view_model.dart';
import 'package:provider/provider.dart';

import '../widget/multi_date_time_picker.dart';

class OnMeetupRequestBottom extends StatelessWidget {
  const OnMeetupRequestBottom({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestViewModel>();
    bool isSentByMe =
        viewModel.notificationData.sourceUserId == User.instance.id;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed:
              viewModel.state.selectedDate == null ||
                      viewModel.notificationData.isOpen == false ||
                      isSentByMe
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
              viewModel.notificationData.isOpen == true || !isSentByMe
                  ? () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => ChangeNotifierProvider<RequestViewModel>.value(
                            value: viewModel,
                            child: Dialog(
                              insetPadding: EdgeInsets.all(24),
                              child: Builder(
                                builder: (dialogContext) {
                                  final viewModelWatch =
                                      dialogContext.watch<RequestViewModel>();

                                  return SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.8,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Scrollbar(
                                            controller: ScrollController(),
                                            thumbVisibility: true,
                                            thickness: 6,
                                            radius: Radius.circular(3),
                                            child: SingleChildScrollView(
                                              padding: EdgeInsets.all(16),
                                              child: MultiDateTimePicker(),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                onPressed:
                                                    viewModelWatch
                                                                .state
                                                                .selectedDates
                                                                .isEmpty ||
                                                            viewModelWatch
                                                                    .notificationData
                                                                    .isOpen ==
                                                                false ||
                                                            isSentByMe
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
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          }
                                                          viewModelWatch
                                                              .proposeSelectedDates();
                                                        },
                                                child: Text('Send New Dates'),
                                              ),
                                              ElevatedButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: Text('Cancel'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
