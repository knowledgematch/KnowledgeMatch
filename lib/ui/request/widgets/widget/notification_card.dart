import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:knowledgematch/domain/models/notification_data.dart';
import 'package:knowledgematch/domain/models/userprofile.dart';
import 'package:knowledgematch/ui/core/themes/app_colors.dart';

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
            ? DateFormat(
              'HH:mm dd/MM',
            ).format(notification.timestamp!.toLocal()).toString()
            : 'Unknown time';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(radius: 50, backgroundImage: avatarImage),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(notification.type),
                      _buildSubtitle(notification.type, notification.title),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                _buildTrailingWidget(notification.type),
              ],
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                timeStamp,
                style: TextStyle(fontSize: 15, color: AppColors.greyLight),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(NotificationType type) {
    switch (type) {
      case NotificationType.knowledgeRequest:
        return Text(
          textAlign: TextAlign.start,
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
          "Meetup Request",
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
    String str = "";
    switch (type) {
      case NotificationType.knowledgeRequest:
        str = notification.body;
      case NotificationType.requestDeclined:
        str = "Your request has been declined";
      case NotificationType.requestAccepted:
        str = "Your request was accepted";
      case NotificationType.meetupRequest:
        str = notification.body;
      case NotificationType.meetupConfirmation:
        str = notification.body;
    }
    return Text(
      textAlign: TextAlign.start,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      str,
    );
  }

  Widget _buildTrailingWidget(NotificationType type) {
    double iconSize = 25.0;
    switch (type) {
      case NotificationType.knowledgeRequest:
        return Icon(
          size: iconSize,
          Icons.question_mark,
          color: AppColors.blueLight,
        );
      case NotificationType.requestDeclined:
        return Icon(size: 15.0, Icons.cancel, color: AppColors.redLight);
      case NotificationType.requestAccepted:
        return Icon(
          size: iconSize,
          Icons.check_circle,
          color: AppColors.greenLight,
        );
      case NotificationType.meetupRequest:
        return Icon(size: 15.0, Icons.date_range, color: AppColors.orangeLight);
      case NotificationType.meetupConfirmation:
        return Icon(
          size: iconSize,
          Icons.fact_check_outlined,
          color: AppColors.greenLight,
        );
    }
  }
}
