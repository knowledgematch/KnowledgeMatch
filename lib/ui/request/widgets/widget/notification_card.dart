import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:knowledgematch/domain/models/notification_data.dart';
import 'package:knowledgematch/domain/models/request_date_data.dart';
import 'package:knowledgematch/domain/models/search_criteria.dart';
import 'package:knowledgematch/domain/models/user.dart';
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

    bool sentByMe = notification.sourceUserId == User.instance.id;

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
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: CircleAvatar(radius: 50, backgroundImage: avatarImage),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
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
    String descriptor1 = "About: ";
    String descriptor2 = "";
    String text1 = "";
    String text2 = "";
    switch (type) {
      case NotificationType.knowledgeRequest ||
          NotificationType.requestDeclined ||
          NotificationType.requestAccepted:
        var searchCriteria = SearchCriteria.fromJSON(notification.payload);
        from = name;
        text1 = searchCriteria.keyword;
        descriptor2 = "Description: ";
        text2 = searchCriteria.issue;
      case NotificationType.meetupRequest:
        var dates =
            RequestDateData.datesFromMeetupRequest(notification.payload) ?? [];
        from = name;
        descriptor1 = "Date: ";
        text1 =
            dates.isNotEmpty
                ? "${dates[0].getFormattedDate()}, ..."
                : "No dates to display";
        descriptor2 = "Time: ";
        text2 = "${dates[0].getFormattedTime()}, ...";
      case NotificationType.meetupConfirmation:
        var str = notification.body.split(" ");
        descriptor0 = "With: ";
        from = name;
        descriptor1 = "${str[1]}, ";
        text1 = str[0];
        descriptor2 = "Time: ";
        text2 = str[2];
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                softWrap: false,
                text1,
              ),
            ),
          ],
        ),
        if (descriptor2.isNotEmpty)
          Row(
            children: [
              Text(style: TextStyle(fontWeight: FontWeight.bold), descriptor2),
              Expanded(
                child: Text(
                  maxLines: 1,
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
    double iconSize = 28.0;
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
