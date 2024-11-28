import 'package:flutter/material.dart';
import 'package:knowledgematch/model/notification_data.dart';
import 'package:knowledgematch/screens/main_screen.dart';

import '../model/userprofile.dart';
import '../services/notification_service.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Request from'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Profile Picture
                    CircleAvatar(
                      radius: 30,
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
                            "requesterTitle",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Location: ${userprofile.location}',
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
            ),
            SizedBox(height: 24),
            Text(
              'The issue',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MainScreen()));
                    var notification = NotificationData(
                        type: NotificationType.requestAccepted,
                        title: "Your request has been accepted",
                        body: "${userprofile.name} has accepted your request",
                        userId: notificationData.userId);
                    await NotificationService()
                        .sendMessageToDevice(notification, userprofile.tokens ?? []);
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
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MainScreen()));
                    var notification = NotificationData(
                        type: NotificationType.requestDeclined,
                        title: 'Your request has been declined',
                        body: '',
                        userId: notificationData.userId);
                    await NotificationService()
                        .sendMessageToDevice(notification, userprofile.tokens ?? []);
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
        ),
      ),
    );
  }
}
