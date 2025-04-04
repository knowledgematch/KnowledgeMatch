import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/services/matching_algorithm.dart';
import '../../../data/services/notification_service.dart';
import '../../../domain/models/notification_data.dart';
import '../../../domain/models/userprofile.dart';
import '../../chat/widgets/chat_screen.dart';
import '../../find_matches/widgets/find_matches_screen.dart';
import '../../profile/widget/profile_screen.dart';
import '../../request/view_model/request_view_model.dart';
import '../../request/widgets/request_screen.dart';
import '../view_model/main_view_model.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeFCM();
  }

  /// Updates the state with the new tab [index]
  //void onTabTapped(int index) {}

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainScreenViewModel>();

    return Scaffold(
        body: _screens[viewModel.state.currentIndex],
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          child: Material(
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            child: BottomNavigationBar(
              currentIndex: viewModel.state.currentIndex,
              onTap: viewModel.updateIndex,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
              ],
            ),
          ),
        ));
  }

  // Initialize Firebase Messaging
  void _initializeFCM() {
    final navigatorKey = context.read<GlobalKey<NavigatorState>>();
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print(message);
        NotificationService().showNotification(message: message);
      }
    });

    _handleInitialMessage(navigatorKey: navigatorKey);

    // Handle messages when the app is brought to foreground from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
        'App opened from terminated state by a message: ${message.notification}',
      );
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => FutureBuilder<Userprofile>(
            future: MatchingAlgorithm().getUserProfileById(
              int.tryParse(message.data['source_user_id']) ?? 0,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  appBar: AppBar(title: Text('Loading...')),
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Scaffold(
                  appBar: AppBar(title: Text('Error')),
                  body: Center(child: Text('Error: ${snapshot.error}')),
                );
              } else {
                return ChangeNotifierProvider<RequestViewModel>(
                  create: (_) => RequestViewModel(
                    userprofile: snapshot.data!,
                    notificationData: NotificationData.fromMessage(
                      message,
                    ),
                  ),
                  child: RequestScreen(),
                );
              }
            },
          ),
        ),
      );
    });
  }

  void _handleInitialMessage({
    required GlobalKey<NavigatorState> navigatorKey,
  }) async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      print(
        'App opened from terminated state by a message: ${message.notification}',
      );
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => FutureBuilder<Userprofile>(
            future: MatchingAlgorithm().getUserProfileById(
              int.parse(message.data['source_user_id'] ?? 0),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  appBar: AppBar(title: Text('Loading...')),
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Scaffold(
                  appBar: AppBar(title: Text('Error')),
                  body: Center(child: Text('Error: ${snapshot.error}')),
                );
              } else {
                return ChangeNotifierProvider<RequestViewModel>(
                  create: (_) => RequestViewModel(
                    notificationData: NotificationData.fromMessage(
                      message,
                    ),
                    userprofile: snapshot.data!,
                  ),
                  child: RequestScreen(),
                );
              }
            },
          ),
        ),
      );
    }
  }
}
