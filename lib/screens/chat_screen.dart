import 'package:flutter/material.dart';

import 'chat_room_screen.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Matches'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search your helpers',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // List of Matches
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Replace with your actual match count
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoomScreen(
                          matchName: 'Maria Lena',
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                      ),
                      title: Text('Maria Lena'),
                      subtitle: Text('Location: Brugg'),
                      trailing: Icon(Icons.chat),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}