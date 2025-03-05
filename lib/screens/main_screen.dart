import 'package:flutter/material.dart';
import 'package:knowledgematch/screens/profile_screen.dart';
import 'package:knowledgematch/screens/search_helpers_screen.dart';

import 'chat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 1;

  final List<Widget> _screens = [
    ProfileScreen(),
    FindMatchesScreen(),
    ChatScreen(),
  ];

  /// Updates the state with the new tab [index]
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              // color: Colors.white,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              // color: Colors.white,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              // color: Colors.white,
            ),
            label: 'Chat',
          ),
        ],
        selectedItemColor: Colors.grey[700],
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black87,
      ),
    );
  }
}
