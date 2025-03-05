import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/chat/view_model/chat_view_model.dart';
import 'package:knowledgematch/ui/find_matches/view_model/find_matches_view_model.dart';

import '../chat/chat_screen.dart';
import '../profile/profile_screen.dart';
import '../find_matches/widgets/find_matches_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 1;

  final List<Widget> _screens = [
    ProfileScreen(),
    FindMatchesScreen(
      viewModel: FindMatchesViewModel(),
    ),
    ChatScreen(viewModel: ChatViewModel(),),
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black87,
      ),
    );
  }
}
