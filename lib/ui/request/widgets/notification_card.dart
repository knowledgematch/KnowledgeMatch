import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/notification_data.dart';
import 'package:knowledgematch/domain/models/userprofile.dart';

import '../../core/themes/app_colors.dart';

class NotificationCard extends StatelessWidget {
  final NotificationData notification;
  final Userprofile userprofile;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.userprofile,
  });

  @override
  Widget build(BuildContext context) {
    var profilePicture = userprofile.getPicture();

    final avatarImage =
        (profilePicture != null && profilePicture.isNotEmpty)
            ? MemoryImage(profilePicture)
            : const AssetImage('assets/images/profile.png') as ImageProvider;

    final timeStamp =
        notification.timestamp != null
            ? notification.timestamp!.toLocal().toString()
            : 'Unknown time';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(radius: 50, backgroundImage: avatarImage),
        isThreeLine: true,
        title: _buildTitle(notification.type),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubtitle(notification.type, notification.title),
            SizedBox(height: 4),
            Text(
              timeStamp,
              style: TextStyle(fontSize: 15, color: AppColors.greyLight),
            ),
          ],
        ),
        trailing: _buildTrailingWidget(notification.type),
      ),
    );
  }

  Widget _buildTitle(NotificationType type) {
    switch (type) {
      case NotificationType.knowledgeRequest:
        return Text(
          "New Request",
          style: TextStyle(fontWeight: FontWeight.bold),
        );
      case NotificationType.requestDeclined:
        return Text(
          "Declined Request",
          style: TextStyle(color: AppColors.redLight),
        );
      case NotificationType.requestAccepted:
        return Text(
          "Accepted Request",
          style: TextStyle(color: AppColors.greenLight),
        );
      case NotificationType.meetupRequest:
        return Text(
          "New Meetup Request",
          style: TextStyle(fontStyle: FontStyle.italic),
        );
      case NotificationType.meetupConfirmation:
        return Text(
          "Meetup Confirmation",
          style: TextStyle(decoration: TextDecoration.underline),
        );
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
        return Icon(Icons.question_mark, color: AppColors.blueLight);
      case NotificationType.requestDeclined:
        return Icon(Icons.cancel, color: AppColors.redLight);
      case NotificationType.requestAccepted:
        return Icon(Icons.check_circle, color: AppColors.greenLight);
      case NotificationType.meetupRequest:
        return Icon(Icons.date_range, color: AppColors.orangeLight);
      case NotificationType.meetupConfirmation:
        return Icon(Icons.fact_check_outlined, color: AppColors.greenLight);
    }
  }
}
