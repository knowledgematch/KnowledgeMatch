import 'package:flutter/material.dart';
import 'package:knowledgematch/screens/swipe_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SwipeScreen()),
            );
          },
          child: Text('Search for Matches'),
        ),
      ),
    );
  }
}
