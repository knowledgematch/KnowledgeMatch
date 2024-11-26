import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:knowledgematch/screens/main_screen.dart';

import '../model/notification_data.dart';
import '../services/notification_service.dart';

class RequestScreen extends StatelessWidget {
  final String requesterName;
  final String requesterTitle;
  final String userId;
  final String notificationType;
  final String requesterLocation;
  final String issueDescription;
  final String requesterToken;

  const RequestScreen({
    super.key,
    required this.requesterName,
    required this.requesterTitle,
    required this.userId,
    required this.notificationType,
    required this.requesterLocation,
    required this.issueDescription,
    required this.requesterToken,
  });

  factory RequestScreen.fromMessage(
      {Key? key, required RemoteMessage message}) {
    return RequestScreen(
      key: key,
      requesterName: message.data['requesterName'] ?? '',
      requesterTitle: message.data['requesterTitle'] ?? '',
      userId: message.data['userId'] ?? '',
      notificationType: message.data['notificationType'] ?? '',
      requesterLocation: message.data['requesterLocation'] ?? '',
      issueDescription: message.data['issueDescription'] ?? '',
      requesterToken: message.data['requesterToken'] ?? '',
    );
  }

  factory RequestScreen.fromData(Map<String, dynamic> data) {
    return RequestScreen(
      requesterName: data['requesterName'] ?? '',
      requesterTitle: data['requesterTitle'] ?? '',
      userId: data['userId'] ?? '',
      notificationType: data['notificationType'] ?? '',
      requesterLocation: data['requesterLocation'] ?? '',
      issueDescription: data['issueDescription'] ?? '',
      requesterToken: data['requesterToken'] ?? '',
    );
  }

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
                            requesterName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            requesterTitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Location: $requesterLocation',
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
                  issueDescription,
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
                        type: NotificationType.knowledgeResponse,
                        title: "Your request has been accepted",
                        body: "$requesterName has accepted your request",
                        userId: 1233415);
                    await NotificationService()
                        .sendMessageToDevice(notification);
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
                    var notificationData = NotificationData(
                        type: NotificationType.knowledgeResponse,
                        title: 'Your request has been declined',
                        body: '',
                        userId: 14123123);
                    await NotificationService()
                        .sendMessageToDevice(notificationData);
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
