import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/request/view_model/request_view_model.dart';

import '../../../domain/models/reachability.dart';
import '../../../domain/models/request_date_data.dart';
import '../../../widgets/multi_date_time_picker.dart';

class OnMeetupRequestBody extends StatefulWidget {
  final RequestViewModel viewModel;
  const OnMeetupRequestBody({super.key, required this.viewModel});

  @override
  OnMeetupRequestBodyState createState() => OnMeetupRequestBodyState();
}

class OnMeetupRequestBodyState extends State<OnMeetupRequestBody> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.parseIncomingDates();
  }

  @override
  Widget build(BuildContext context) {
    //RequestDateData? selectedDate; // To track the selected date
    // SearchCriteria? searchCriteria;
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                  title: Text(
                    'Meetup Request:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing:
                      Icon(Icons.date_range, color: Colors.orange, size: 40)),
            ),
            SizedBox(height: 8),
            if (widget.viewModel.incomingDates.isNotEmpty)
              Text(
                'Select a proposed date and time:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 8),

            // Display incoming dates
            if (widget.viewModel.incomingDates.isNotEmpty)
              ...widget.viewModel.incomingDates
                  .map((RequestDateData requestedDate) {
                String date = requestedDate.getFormattedDate();
                String time = requestedDate.getFormattedTime();
                return RadioListTile<RequestDateData>(
                  title: Row(
                    children: [
                      Text('Date: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(date),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Text('Time: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(time),
                    ],
                  ),
                  value: requestedDate,
                  groupValue: widget.viewModel.selectedDate,
                  onChanged: (value) {
                    setState(() {
                      widget.viewModel.selectedDate = value;
                    });
                  },
                  secondary: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(requestedDate.reachability.toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }),

            if (widget.viewModel.incomingDates.isEmpty)
              Text(
                'No dates proposed. Please suggest new dates.',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),

            Spacer(),

            // Confirm or Request Different Dates
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: widget.viewModel.selectedDate == null ||
                          widget.viewModel.notificationData.isOpen == false
                      ? null
                      : () async {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text("Date confirmed successfully!")),
                            );
                            Navigator.pop(context);
                          }
                          widget.viewModel.confirmDate();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.viewModel.selectedDate == null
                        ? Colors.grey
                        : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: widget.viewModel.notificationData.isOpen == true
                      ? () {
                          // Request different dates
                          showDialog(
                            context: context,
                            builder: (context) => StatefulBuilder(
                              builder: (context, setState) {
                                return Dialog(
                                  insetPadding: EdgeInsets.zero,
                                  child: Column(
                                    children: [
                                      MultiDateTimePicker(
                                        searchCriteriaReachability: widget
                                                .viewModel
                                                .searchCriteria
                                                .reachability ??
                                            Reachability.onlineOrInPerson,
                                        onDatesSelected: (dates) async {
                                          setState(() {
                                            widget.viewModel.newDates = dates;
                                          });
                                        },
                                      ),
                                      Spacer(),
                                      // Confirm Button for Sending the Notification
                                      ElevatedButton(
                                        onPressed: widget
                                                .viewModel.newDates.isEmpty
                                            ? null
                                            : () async {
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            "New dates proposed successfully!")),
                                                  );
                                                  Navigator.pop(context);
                                                }
                                                widget.viewModel
                                                    .proposeNewDates();
                                              },
                                        child: Text('Send New Dates'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Request Different Dates',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
