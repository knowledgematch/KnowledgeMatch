import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/core/themes/app_colors.dart';
import 'package:knowledgematch/ui/profile/widget/profile_screen.dart';
import 'package:provider/provider.dart';

import '../../../data/services/matching_algorithm.dart';
import '../../../data/services/notification_service.dart';
import '../../../domain/models/notification_data.dart';
import '../../../domain/models/userprofile.dart';
import '../../chat/widgets/chat_screen.dart';
import '../../find_matches/widgets/find_matches_screen.dart';
import '../../home/widgets/home_screen.dart';
import '../../request/view_model/request_view_model.dart';
import '../../request/widgets/request_screen.dart';
import '../view_model/main_view_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    _initializeFCM();
  }

  @override
  Widget build(BuildContext context) {
    List items = [{"name": "HOME","icon":Icons.home, "index": 0}, {"name": "FIND","icon":Icons.search, "index": 1}, {"name": "REQUESTS","icon":Icons.checklist, "index": 2},{"name": "PROFILE","icon":Icons.person, "index": 3}];

    BottomNavigationBarItem _barItem(bool isActive,IconData icon, String label){
      return BottomNavigationBarItem(
        icon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.white : AppColors.primary,
            shape: BoxShape.circle
          ),
          child: Icon(icon,color: isActive ? AppColors.primary : AppColors.white),
        ),
        label: label,
      );
    }

    final viewModel = context.watch<MainScreenViewModel>();
    final List<Widget> screens = [
      HomeScreen(mainViewModel: viewModel),
      FindMatchesScreen(),
      ChatScreen(),
      ProfileScreen(),
    ];
    return Scaffold(
      body: screens[viewModel.state.currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: BottomNavigationBar(
          currentIndex: viewModel.state.currentIndex,
          onTap: viewModel.updateIndex,
          items: items.map((i) => _barItem(viewModel.state.currentIndex == i["index"], i["icon"],i["name"])).toList(),
        ),
      ),
    );
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
          builder:
              (context) => FutureBuilder<Userprofile>(
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
                      create:
                          (_) => RequestViewModel(
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
          builder:
              (context) => FutureBuilder<Userprofile>(
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
                      create:
                          (_) => RequestViewModel(
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
