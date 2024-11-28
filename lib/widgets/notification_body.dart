import 'dart:convert';

import 'package:flutter/material.dart';
import '../model/notification_data.dart';
import '../model/userprofile.dart';
import '../services/notification_service.dart';
import 'multi_date_time_picker.dart';

class NotificationBody extends StatelessWidget {
  final NotificationData notificationData;
  final Userprofile userprofile;

  const NotificationBody({
    super.key,
    required this.userprofile,
    required this.notificationData,
  });

  @override
  Widget build(BuildContext context) {
    var type = notificationData.type;
    return switch (type) {
      NotificationType.knowledgeRequest => _onRequestBody(context),
      NotificationType.requestDeclined => _onDeclinedBody(context),
      NotificationType.requestAccepted => _onAcceptBody(context),
      NotificationType.meetupRequest => throw UnimplementedError(),
      // TODO: Handle this case.
      NotificationType.meetupResponse => throw UnimplementedError(),
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
              notificationData.body,
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
                  title: " ${userprofile.name} accepted your request",
                  body: "${userprofile.name} accepted!",
                  targetUserId: notificationData.targetUserId,
                  sourceUserId: notificationData.sourceUserId,
                );
                await NotificationService().sendMessageToDevice(notification);
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
                  title: "${userprofile.name} declined your request",
                  body: "${userprofile.name} declined.",
                  targetUserId: notificationData.targetUserId,
                  sourceUserId: notificationData.sourceUserId,
                );
                await NotificationService().sendMessageToDevice(notification);
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
                notificationData.body,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(Icons.check_circle, color: Colors.green, size: 40)),
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
          onDatesSelected: (selectedDates) async {
            final jsonString = jsonEncode(selectedDates);
            Navigator.pop(context);
            var notification = NotificationData(
              type: NotificationType.meetupResponse,
              title: "Meetup Request",
              body: "Dates selected: $jsonString",
              targetUserId: notificationData.targetUserId,
              sourceUserId: notificationData.sourceUserId,
            );
            await NotificationService().sendMessageToDevice(notification);
          },
        ),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              notificationData.body,
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
                  title: "Your request has been accepted",
                  body: "${userprofile.name} accepted!",
                  targetUserId: notificationData.targetUserId,
                  sourceUserId: notificationData.sourceUserId,
                );
                await NotificationService().sendMessageToDevice(notification);
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
              onPressed: () async {
                Navigator.pop(context);
                var notification = NotificationData(
                  type: NotificationType.requestDeclined,
                  title: "Your request has been declined",
                  body: "${userprofile.name} has declined your request",
                  targetUserId: notificationData.targetUserId,
                  sourceUserId: notificationData.sourceUserId,
                );
                await NotificationService().sendMessageToDevice(notification);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
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
      ],
    );
  }

  Widget _onDeclinedBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
              title: Text(
                notificationData.body,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(
          'Meetup Request:',
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
              notificationData.body,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),

        // Use MultiDateTimePicker here
        MultiDateTimePicker(
          onDatesSelected: (selectedDates) async {
            final jsonString = jsonEncode(selectedDates);
            Navigator.pop(context);
            var notification = NotificationData(
              type: NotificationType.meetupResponse,
              title: "Meetup Request",
              body: "Dates selected: $jsonString",
              targetUserId: notificationData.targetUserId,
              sourceUserId: notificationData.sourceUserId,
            );
            await NotificationService().sendMessageToDevice(notification);
          },
        ),
      ],
    );
  }
  
}
