import 'package:flutter/material.dart';
import 'package:knowledgematch/services/firestore_service.dart';
import 'package:knowledgematch/widgets/notification_card.dart';
import '../model/notification_data.dart';
import 'chat_room_screen.dart';

class ChatScreen extends StatelessWidget {
  final firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
      ),
      body: Column(
        children: [
          // List of Matches
          Expanded(
            child: FutureBuilder<List<NotificationData>>(
              future: firestoreService.fetchNotifications(
                userID: 1234,
                type: NotificationType.knowledgeRequest,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While the data is loading, show a loading indicator
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No requests found.'));
                } else {
                  final notifications = snapshot.data!;
                  return ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to chat room
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RequestDetailScreen(notification: notification
                              ),
                            ),
                          );
                        },
                        child: NotificationCard(notification: notification)
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}