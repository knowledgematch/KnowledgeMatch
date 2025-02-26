import 'package:flutter/material.dart';

import '../../../domain/models/reachability.dart';
import '../../../domain/models/search_criteria.dart';
import '../../../widgets/multi_date_time_picker.dart';
import '../view_model/request_view_model.dart';

class OnAcceptBody extends StatefulWidget {
  const OnAcceptBody({super.key, required this.viewModel});
  final RequestViewModel viewModel;

  @override
  OnAcceptBodyState createState() => OnAcceptBodyState();
}

class OnAcceptBodyState extends State<OnAcceptBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
              title: Text(
                widget.viewModel.notificationData.body,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing:
                  Icon(Icons.check_circle, color: Colors.green, size: 40)),
        ),
        SizedBox(height: 8),
        Text(
          'Create a meetup request:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        MultiDateTimePicker(
          searchCriteriaReachability:
              widget.viewModel.searchCriteria.reachability ??
                  Reachability.onlineOrInPerson,
          onDatesSelected: (dates) async {
            setState(() {
              selectedDates = dates;
            });
          },
        ),
        Spacer(),
        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: widget.notificationData.isOpen == true
                  ? () async {
                      if (selectedDates.isEmpty) {
                        // Show error if no dates are selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Please select at least one date!")),
                        );
                        return;
                      }
                      // Show success message and close
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Meetup request sent!")),
                        );
                        Navigator.pop(context);
                      }
                      var dates = RequestDateData.buildDatesMap(selectedDates);
                      Map<String, dynamic> combineJson = {
                        "dates": dates,
                        "search_criteria": searchCriteria.toJSON(),
                      };

                      var notification = NotificationData(
                        type: NotificationType.meetupRequest,
                        title: "Meetup has been requested",
                        body: "${User.instance.name} suggests meetup dates!",
                        payload: combineJson,
                        requestID: widget.notificationData.requestID,
                        targetUserId: widget.userprofile.id,
                        sourceUserId: User.instance.id!,
                      );

                      //Update Status of the previous request
                      FirestoreService().notificationStatusUpdate(
                          false, widget.notificationData.documentID);

                      await NotificationService().sendMessageToDevice(
                          notification, widget.userprofile.tokens ?? []);
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
                'Send',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        Spacer()
      ],
    );
  }
}
