import 'package:flutter/material.dart';

import '../model/notification_data.dart';

class NotificationCard extends StatelessWidget {
  final NotificationData notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/images/profile.png'),
        ),
        isThreeLine: true,
        title: _buildTitle(notification.type),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubtitle(notification.type, notification.title), // First line (e.g., notification body)
            SizedBox(height: 4),
            Text(
              notification.timestamp!.toLocal().toString(),
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ), // Second line (e.g., timestamp)
          ],
        ),
        trailing: _buildTrailingWidget(notification.type)
      ),
    );
  }

  Widget _buildTitle(NotificationType type) {
    switch (type) {
      case NotificationType.knowledgeRequest:
        return Text("Open Request", style: TextStyle(fontWeight: FontWeight.bold));
      case NotificationType.requestDeclined:
        return Text("Declined Request", style: TextStyle(color: Colors.red));
      case NotificationType.requestAccepted:
        return Text("Accepted Request", style: TextStyle(color: Colors.green));
      case NotificationType.meetupRequest:
        return Text("New Meetup Request", style: TextStyle(fontStyle: FontStyle.italic));
      case NotificationType.meetupConfirmation:
        return Text("Meetup Confirmation", style: TextStyle(decoration: TextDecoration.underline));
      }
  }

  Widget _buildSubtitle(NotificationType type, String body) {
    switch (type) {
      case NotificationType.knowledgeRequest:
        return Text(notification.body);
      case NotificationType.requestDeclined:
        return Text("Your request has been declined");
      case NotificationType.requestAccepted:
        return Text("Your request was accepted");
      case NotificationType.meetupRequest:
        return Text(notification.body);
      case NotificationType.meetupConfirmation:
        return Text(notification.body);
      }
  }

  Widget _buildTrailingWidget(NotificationType type) {
    switch (type) {
      case NotificationType.knowledgeRequest:
        return Icon(Icons.question_mark, color: Colors.blue);
      case NotificationType.requestDeclined:
        return Icon(Icons.cancel, color: Colors.red);
      case NotificationType.requestAccepted:
        return Icon(Icons.check_circle, color: Colors.green);
      case NotificationType.meetupRequest:
        return Icon(Icons.date_range, color: Colors.orange);
      case NotificationType.meetupConfirmation:
        return Icon(Icons.fact_check_outlined, color: Colors.green);
    }
  }
}