import 'package:flutter/material.dart';
import 'package:knowledgematch/screens/request_screen.dart';
import 'package:knowledgematch/services/firestore_service.dart';
import 'package:knowledgematch/widgets/notification_card.dart';
import '../model/notification_data.dart';
import '../model/user.dart';
import '../services/matching_algorithm.dart';

class ChatScreen extends StatelessWidget {
  final firestoreService = FirestoreService();

  ChatScreen({super.key});

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
                userID: User.instance.id ?? 0,
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
                          onTap: () async {
                            final userProfile = await MatchingAlgorithm().getUserProfileById(notification.sourceUserId); // Replace with your actual method and parameters

                            // Navigate to RequestDetailScreen with the userProfile
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestScreen(
                                  notificationData: notification,
                                  userprofile: userProfile,
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