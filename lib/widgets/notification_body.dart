import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:knowledgematch/models/notification_data.dart';
import 'package:knowledgematch/models/reachability.dart';
import 'package:knowledgematch/models/request_date_data.dart';
import 'package:knowledgematch/models/search_criteria.dart';
import 'package:knowledgematch/models/user.dart';
import 'package:knowledgematch/models/userprofile.dart';
import 'package:knowledgematch/services/firestore_service.dart';
import 'package:knowledgematch/services/forward_to_external.dart';
import 'package:knowledgematch/services/notification_service.dart';

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
  List<RequestDateData> selectedDates = [];
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
    SearchCriteria searchCriteria =
        SearchCriteria.fromJSON(widget.notificationData.payload);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
              title: Text(
                "New Knowledge request",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(Icons.question_mark_rounded,
                  color: Colors.orange, size: 40)),
        ),

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
              searchCriteria.issue,
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
              onPressed: widget.notificationData.isOpen ==
                      true //Check if the notificaion is still Open -> null if 'false' or null, which disables button
                  ? () async {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Request accepted.")));
                        Navigator.pop(context);
                      }

                      var notification = NotificationData(
                          type: NotificationType.requestAccepted,
                          title: "Accepted request",
                          body:
                              "Your request has been accepted by ${User.instance.name} ${User.instance.surname}",
                          payload: searchCriteria.toJSON(),
                          targetUserId: widget.userprofile.id,
                          sourceUserId: User.instance.id!,
                          requestID: widget.notificationData.requestID);
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
                'Accept',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: widget.notificationData.isOpen == true
                  ? () async {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Request declined.")));
                        Navigator.pop(context);
                      }

                      var notification = NotificationData(
                        type: NotificationType.requestDeclined,
                        title: "Declined request",
                        body:
                            "Your request was declined by ${User.instance.name} ${User.instance.surname}",
                        payload: searchCriteria.toJSON(),
                        targetUserId: widget.notificationData.sourceUserId,
                        sourceUserId: widget.userprofile.id,
                        requestID: widget.notificationData.requestID,
                      );

                      await NotificationService().sendMessageToDevice(
                          notification, widget.userprofile.tokens ?? []);
                      FirestoreService()
                          .closeRequest(widget.notificationData.requestID);
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
    SearchCriteria searchCriteria =
        SearchCriteria.fromJSON(widget.notificationData.payload);
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
          searchCriteriaReachability:
              searchCriteria.reachability ?? Reachability.onlineOrInPerson,
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
    List<RequestDateData> incomingDates = []; // To store parsed dates
    RequestDateData? selectedDate; // To track the selected date
    SearchCriteria? searchCriteria;

    try {
      var jsonData = widget.notificationData.payload;

      print("JsonData: $jsonData}");
      //Extract the list of requested meetups
      if (jsonData['dates'] is Map) {
        var datesData = jsonData['dates'];
        if (datesData['meetupsRequested'] is List) {
          List<dynamic> meetups = datesData['meetupsRequested'];

          // Parse each meetup entry
          incomingDates = meetups.map((item) {
            return RequestDateData.fromJson(item);
          }).toList();
        }
      }
      if (jsonData['search_criteria'] is Map) {
        searchCriteria = SearchCriteria.fromJSON(jsonData['search_criteria']);
        print(searchCriteria.toString());
      }
    } catch (e) {
      print('Error parsing JSON: $e');
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
              ...incomingDates.map((RequestDateData requestedDate) {
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
                  groupValue: selectedDate,
                  onChanged: (value) {
                    setState(() {
                      selectedDate = value;
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
                  onPressed: selectedDate == null ||
                          widget.notificationData.isOpen == false
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

                          // Confirm the selected date
                          var notification = NotificationData(
                            type: NotificationType.meetupConfirmation,
                            title: "Meetup Confirmation",
                            body:
                                "${selectedDate!.reachability} ${selectedDate!.getFormattedDate()} ${selectedDate!.getFormattedTime()}",
                            payload: selectedDate!.toJson(),
                            requestID: widget.notificationData.requestID,
                            targetUserId: widget.userprofile.id,
                            sourceUserId: User.instance.id!,
                          );

                          await NotificationService().sendMessageToDevice(
                              notification, widget.userprofile.tokens ?? []);

                          FirestoreService()
                              .addConfirmationToFirestore(notification);

                          //Close all notifications associated with the request
                          FirestoreService()
                              .closeRequest(widget.notificationData.requestID);
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
                  onPressed: widget.notificationData.isOpen == true
                      ? () {
                          // Request different dates
                          List<RequestDateData> selectedNewDates =
                              []; // Track new dates locally
                          showDialog(
                            context: context,
                            builder: (context) => StatefulBuilder(
                              builder: (context, setState) {
                                return Dialog(
                                  insetPadding: EdgeInsets.zero,
                                  child: Column(
                                    children: [
                                      MultiDateTimePicker(
                                        searchCriteriaReachability:
                                            searchCriteria == null ||
                                                    searchCriteria
                                                            .reachability ==
                                                        null
                                                ? Reachability.onlineOrInPerson
                                                : searchCriteria.reachability!,
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
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            "New dates proposed successfully!")),
                                                  );
                                                  Navigator.pop(context);
                                                }
                                                final dates = RequestDateData
                                                    .buildDatesMap(
                                                        selectedNewDates);
                                                Map<String, dynamic>
                                                    combineJson = {
                                                  "dates": dates,
                                                  "search_criteria":
                                                      searchCriteria?.toJSON(),
                                                };

                                                var notification =
                                                    NotificationData(
                                                  type: NotificationType
                                                      .meetupRequest,
                                                  title:
                                                      "Request for New Dates",
                                                  body:
                                                      "${User.instance.name} requested new dates!",
                                                  payload: combineJson,
                                                  targetUserId:
                                                      widget.userprofile.id,
                                                  sourceUserId:
                                                      User.instance.id!,
                                                );

                                                //close previous request and send new notification
                                                FirestoreService()
                                                    .notificationStatusUpdate(
                                                        false,
                                                        widget.notificationData
                                                            .documentID);
                                                await NotificationService()
                                                    .sendMessageToDevice(
                                                        notification,
                                                        widget.userprofile
                                                                .tokens ??
                                                            []);
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

  Widget _onMeetupConfirmation(BuildContext context) {
    FirestoreService().closeRequest(widget.notificationData.requestID);
    final name = widget.userprofile.name;
    final email = widget.userprofile.email;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(
          ' Meetup Confirmation:',
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
        SizedBox(height: 8),
        Text(
          ' Keep in touch:',
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
                onTap: () async {
                  ForwardToExternal.openTeamsChat(email);
                },
                title: Text(
                  'Link to $name\'s Teams Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(email),
                trailing: Icon(Icons.chat, color: Colors.blue, size: 40)),
          ),
        ),
        SizedBox(height: 16),
        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Return to the previous screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Exit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        Spacer(),
      ],
    );
  }
}
