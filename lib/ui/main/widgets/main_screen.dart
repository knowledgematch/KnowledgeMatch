import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../chat/widgets/chat_screen.dart';
import '../../profile/profile_screen.dart';
import '../../find_matches/widgets/find_matches_screen.dart';
import '../view_model/main_screen_view_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    ProfileScreen(),
    FindMatchesScreen(),
    ChatScreen(),
  ];

  /// Updates the state with the new tab [index]
  void onTabTapped(int index) {

  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainScreenViewModel>();

    return Scaffold(
      body: _screens[viewModel.state.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: viewModel.state.currentIndex,
        onTap: viewModel.updateIndex,
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
