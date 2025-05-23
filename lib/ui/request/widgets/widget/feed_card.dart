import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:knowledgematch/domain/models/notification_data.dart';
import 'package:knowledgematch/domain/models/userprofile.dart';
import 'package:knowledgematch/ui/core/themes/app_colors.dart';
import 'package:knowledgematch/ui/core/themes/app_constants.dart';

class FeedCard extends StatelessWidget {
  final NotificationData notification;
  final Userprofile userprofile;

  const FeedCard({
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
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppConstants.borderRadiusLarge,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: 20),
            Column(
              children: [
                Text("Communication with: "),
                Text(
                  userprofile.name,
                  style: Theme.of(context).textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(radius: 30, backgroundImage: avatarImage),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Last message: ",
                  style: TextStyle(fontSize: 15, color: AppColors.greyLight),
                ),
                SizedBox(width: 12),
                Text(
                  timeStamp,
                  style: TextStyle(fontSize: 15, color: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
