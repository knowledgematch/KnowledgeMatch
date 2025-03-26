import 'package:flutter/material.dart';
import 'package:knowledgematch/models/notification_data.dart';
import 'package:knowledgematch/theme/colors.dart';
import 'package:knowledgematch/widgets/notification_body.dart';

import '../models/userprofile.dart';

class RequestScreen extends StatelessWidget {
  final NotificationData notificationData;
  final Userprofile userprofile;

  const RequestScreen({
    super.key,
    required this.userprofile,
    required this.notificationData,
  });

  @override
  Widget build(BuildContext context) {
    print('UserProfile ID: ${userprofile.name}');
    return Scaffold(
        appBar: AppBar(
          title: _buildTitle(notificationData),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          backgroundColor: AppColors.whiteLight,
          foregroundColor: AppColors.blackLight,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _userProfileCard(userprofile),
          Expanded(
            child: NotificationBody(
                userprofile: userprofile, notificationData: notificationData),
          )
        ]));
  }

  Widget _buildTitle(NotificationData notification) {
    var type = notification.type;
    switch (type) {
      case NotificationType.knowledgeRequest:
        return Text("New request:");
      case NotificationType.requestDeclined:
        return Text("Declined request:");
      case NotificationType.requestAccepted:
        return Text("Accepted request");
      case NotificationType.meetupRequest:
        return Text("Meetup request");
      case NotificationType.meetupConfirmation:
        return Text("Meetup confirmation");
    }
  }

  Widget _userProfileCard(Userprofile userprofile) {
    var profilePicture = userprofile.getPicture();
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: profilePicture != null
                  ? MemoryImage(profilePicture)
                  : const AssetImage('assets/images/profile.png')
                      as ImageProvider,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userprofile.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    userprofile.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey7Light,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Location: ${userprofile.reachability}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey7Light,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
