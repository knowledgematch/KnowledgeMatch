import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:knowledgematch/domain/models/notification_data.dart';
import 'package:knowledgematch/domain/models/userprofile.dart';
import 'package:knowledgematch/ui/core/themes/app_colors.dart';
import 'package:knowledgematch/ui/core/ui/decorations.dart';

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
              'dd/MM HH:mm',
            ).format(notification.timestamp!.toLocal()).toString()
            : 'Unknown time';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: Decorations.container,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: 20),
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
                      _buildTitle(notification.type, context),
                      _buildSubtitle(notification.type, notification.title),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                _buildTrailingWidget(notification.type),
              ],
            ),
            SizedBox(width: 30),
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

  Widget _buildTitle(NotificationType type, BuildContext context) {
    String title = "";
    switch (type) {
      case NotificationType.knowledgeRequest:
        title = "New Request";
      case NotificationType.requestDeclined:
        title = "Declined Request";
      case NotificationType.requestAccepted:
        title = "Accepted Request";
      case NotificationType.meetupRequest:
        title = "Meetup Request";
      case NotificationType.meetupConfirmation:
        title = "Meetup Confirmed";
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Text(title, style: Theme.of(context).textTheme.titleSmall),
    );
  }

  Widget _buildSubtitle(NotificationType type, String body) {
    final String name = userprofile.name.split(" ")[0];
    String descriptor0 = "From: ";
    String from = "";
    String descriptor1 = "";
    String text1 = "";
    String descriptor2 = "";
    String text2 = "";
    switch (type) {
      case NotificationType.knowledgeRequest:
        from = name;
        descriptor1 = "Keyword: ";
        text1 = notification.payload["keyword"];
      case NotificationType.requestDeclined:
        from = name;
        descriptor1 = "Keyword: ";
        text1 = notification.payload["keyword"];
        text2 = "Your request has been declined";
      case NotificationType.requestAccepted:
        from = name;
        descriptor1 = "Keyword: ";
        text1 = notification.payload["keyword"];
        text2 = "Your request was accepted";
      case NotificationType.meetupRequest:
        from = name;
        text2 = "New meetup suggestions!";
      case NotificationType.meetupConfirmation:
        var str = notification.body.split(" ");
        descriptor0 = "With: ";
        from = name;
        descriptor1 = str[2];
        text1 = "";
        descriptor2 = "";
        text2 = str[0] + str[1];
    }
    return Column(
      children: [
        Row(
          children: [
            Text(style: TextStyle(fontWeight: FontWeight.bold), descriptor0),
            Expanded(
              child: Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                from,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(style: TextStyle(fontWeight: FontWeight.bold), descriptor1),
            Expanded(
              child: Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                softWrap: false,
                text1,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(style: TextStyle(fontWeight: FontWeight.bold), descriptor2),
            Expanded(
              child: Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                softWrap: false,
                text2,
              ),
            ),
          ],
        ),
      ],
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
        return Icon(size: iconSize, Icons.cancel, color: AppColors.redLight);
      case NotificationType.requestAccepted:
        return Icon(
          size: iconSize,
          Icons.check_circle,
          color: AppColors.greenLight,
        );
      case NotificationType.meetupRequest:
        return Icon(
          size: iconSize,
          Icons.date_range,
          color: AppColors.orangeLight,
        );
      case NotificationType.meetupConfirmation:
        return Icon(
          size: iconSize,
          Icons.fact_check_outlined,
          color: AppColors.greenLight,
        );
    }
  }
}
