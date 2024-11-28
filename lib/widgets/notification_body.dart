
import 'package:flutter/material.dart';
import 'package:knowledgematch/services/matching_algorithm.dart';
import '../model/notification_data.dart';
import '../model/userprofile.dart';
import '../services/notification_service.dart';
import 'multi_date_time_picker.dart';

class NotificationBody extends StatefulWidget {
  final NotificationData notificationData;
  final Userprofile userprofile;

  const NotificationBody({
    super.key,
    required this.userprofile,
    required this.notificationData,
  });

  @override
  NotificationBodyState createState() => NotificationBodyState();
}

class NotificationBodyState extends State<NotificationBody> {
  List<Map<String, dynamic>> selectedDates = []; // Store selected dates
  @override
  Widget build(BuildContext context) {
    var type = widget.notificationData.type;
    return switch (type) {
      NotificationType.knowledgeRequest => _onRequestBody(context),
      NotificationType.requestDeclined => _onDeclinedBody(context),
      NotificationType.requestAccepted => _onAcceptBody(context),
      NotificationType.meetupRequest => _onMeetupRequestBody(context),
      NotificationType.meetupConfirmation => _onMeetupConfirmation(context),
    };
  }

  Widget _onRequestBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(
          'Problem description:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.notificationData.body,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        Spacer(),

        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                var notification = NotificationData(
                  type: NotificationType.requestAccepted,
                  title: "Accepted request",
                  body: "Your request was accepted!",
                  targetUserId: widget.notificationData.targetUserId,
                  sourceUserId: widget.notificationData.sourceUserId,
                );
                //Userprofile targetUser = await MatchingAlgorithm().getUserProfileById(widget.notificationData.targetUserId);
                await NotificationService().sendMessageToDevice(notification, widget.userprofile.tokens ?? []);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Accept',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                var notification = NotificationData(
                  type: NotificationType.requestDeclined,
                  title: "Declined request",
                  body: "Your request was declined.",
                  targetUserId: widget.notificationData.targetUserId,
                  sourceUserId: widget.notificationData.sourceUserId,
                );
                //Userprofile targetUser = await MatchingAlgorithm().getUserProfileById(widget.notificationData.targetUserId);
                await NotificationService().sendMessageToDevice(notification, widget.userprofile.tokens ?? []);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Decline',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _onAcceptBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
              title: Text(
                widget.notificationData.body,
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
              onPressed: () async {
                if (selectedDates.isEmpty) {
                  // Show error if no dates are selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select at least one date!")),
                  );
                  return;
                }

                String dates = buildRequestString(selectedDates);

                var notification = NotificationData(
                  type: NotificationType.meetupRequest,
                  title: "Meetup has been requested",
                  body: dates,
                  targetUserId: widget.notificationData.targetUserId,
                  sourceUserId: widget.notificationData.sourceUserId,
                );

                // Call the notification service
                await NotificationService().sendMessageToDevice(notification, widget.userprofile.tokens ?? []);

                // Show success message and close
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Meetup request sent!")),
                  );
                  Navigator.pop(context);
                }
              },
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
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 8)
      ],
    );
  }

  Widget _onDeclinedBody(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 24),
      Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
            title: Text(
              widget.notificationData.body,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(Icons.cancel, color: Colors.red, size: 40)),
      ),
      SizedBox(height: 8),
    ]);
  }

  Widget _onMeetupRequestBody(BuildContext context) {
    List<Map<String, String>> incomingDates = []; // To store parsed dates
    Map<String, String>? selectedDate; // To track the selected date

    // Parse incoming dates from plain string
    String body = widget.notificationData.body;
    List<String> lines = body.split('\n'); // Split the string into lines

    if (lines.isNotEmpty && lines[0].startsWith('Meetups requested on:')) {
      for (int i = 1; i < lines.length; i++) {
        // Skip the header and parse each date-time line
        final line = lines[i];
        if (line.startsWith('Date:')) {
          final parts = line.split(', Time: ');
          if (parts.length == 2) {
            final date = parts[0].replaceFirst('Date: ', '').trim();
            final time = parts[1].trim();
            incomingDates.add({'date': date, 'time': time});
          }
        }
      }
    }

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
            if (incomingDates.isNotEmpty)
              Text(
                'Select a proposed date and time:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 8),

            // Display incoming dates
            if (incomingDates.isNotEmpty)
              ...incomingDates.map((dateTime) {
                String date = dateTime['date']!;
                String time = dateTime['time']!;
                return RadioListTile<Map<String, String>>(
                  title: Text('Date: $date, Time: $time'),
                  value: dateTime,
                  groupValue: selectedDate,
                  onChanged: (value) {
                    setState(() {
                      selectedDate = value; // Update selected date
                    });
                  },
                );
              }).toList(),

            if (incomingDates.isEmpty)
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
                  onPressed: selectedDate == null
                      ? null
                      : () async {
                          // Confirm the selected date
                          var notification = NotificationData(
                            type: NotificationType.meetupConfirmation,
                            title: "Meetup Confirmation",
                            body:
                                "Confirmed Date: ${selectedDate!['date']}, Time: ${selectedDate!['time']}",
                            targetUserId: widget.notificationData.targetUserId,
                            sourceUserId: widget.notificationData.sourceUserId,
                          );
                          await NotificationService().sendMessageToDevice(notification, widget.userprofile.tokens ?? []);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Date confirmed successfully!")),
                          );
                          Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedDate == null ? Colors.grey : Colors.black,
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
                  onPressed: () {
                    // Request different dates
                    List<Map<String, dynamic>> selectedNewDates =
                        []; // Track new dates locally
                    showDialog(
                      context: context,
                      builder: (context) => StatefulBuilder(
                        builder: (context, setState) {
                          return Dialog(
                            child: Column(
                              children: [
                                MultiDateTimePicker(
                                  onDatesSelected: (newDates) {
                                    setState(() {
                                      selectedNewDates =
                                          newDates; // Update the local list
                                    });
                                  },
                                ),
                                Spacer(),
                                // Confirm Button for Sending the Notification
                                ElevatedButton(
                                  onPressed: selectedNewDates.isEmpty
                                      ? null
                                      : () async {
                                          final dates = buildRequestString(
                                              selectedNewDates);
                                          var notification = NotificationData(
                                            type:
                                                NotificationType.meetupRequest,
                                            title: "Request for New Dates",
                                            body:
                                                dates,
                                            targetUserId: widget
                                                .notificationData.targetUserId,
                                            sourceUserId: widget
                                                .notificationData.sourceUserId,
                                          );
                                          //Userprofile targetUser = await MatchingAlgorithm().getUserProfileById(widget.notificationData.targetUserId);
                                          await NotificationService().sendMessageToDevice(notification, widget.userprofile.tokens ?? []);
                                          if (mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "New dates proposed successfully!")),
                                            );
                                          }
                                          Navigator.pop(
                                              context); // Close the dialog
                                        },
                                  child: Text('Send New Dates'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
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

  Widget _onMeetupConfirmation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(
          'Meetup Confirmation:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
                title: Text(
                  'Your confirmed meetup details:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(widget.notificationData.body),
                trailing:
                    Icon(Icons.date_range, color: Colors.green, size: 40)),
          ),
        ),

        Spacer(),

        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                // Go back to edit the date
                Navigator.pop(context); // Return to the previous screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Edit Date',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String buildRequestString(List<Map<String, dynamic>> selectedDates) {
    StringBuffer requestString = StringBuffer();
    requestString.writeln('Meetups requested on: ');

    for (var item in selectedDates) {
      String date = item['date'];
      String time = item['time'];
      requestString.writeln('Date: $date, Time: $time');
    }

    return requestString.toString();
  }
}
