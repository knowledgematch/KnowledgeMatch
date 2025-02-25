import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/notification_data.dart';

import '../../../domain/models/userprofile.dart';
import '../view_model/request.dart';
import 'notification_body.dart';

class RequestScreen extends StatelessWidget {
  final Request request; //viewmodel

  const RequestScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    print('UserProfile ID: ${request.userprofile.name}');
    return Scaffold(
        appBar: AppBar(
          title: _buildTitle(),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _userProfileCard(request.userprofile),
          Expanded(
            child: NotificationBody(
                userprofile: request.userprofile,
                notificationData: request.notificationData),
          )
        ]));
  }

  Widget _buildTitle() {
    var type = request.notificationData.type;
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
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Location: ${userprofile.reachability}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
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
