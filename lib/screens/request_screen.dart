import 'package:flutter/material.dart';
import 'package:knowledgematch/services/firestore_service.dart';
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
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              // Optional search functionality
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

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
                  // If there's an error, display it
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // If the data is empty, show a message
                  return Center(child: Text('No requests found.'));
                } else {
                  // When data is available, display it
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
                              builder: (context) => ChatRoomScreen(
                                matchName: "Title" //title ?? 'No Title',
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              // Optionally display an avatar
                            ),
                            title: Text(notification.title),
                            subtitle: Text(notification.body),
                            trailing: Icon(Icons.chat),
                          ),
                        ),
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
