import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'package:knowledgematch/model/local_user.dart';
import 'package:knowledgematch/screens/request_screen.dart';
import 'package:knowledgematch/services/matching_algorithm.dart';
import 'package:knowledgematch/services/notification_service.dart';
import 'model/notification_data.dart';
import 'model/userprofile.dart';
import 'screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase is working');
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    appContext = context;
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'KnowledgeMatch',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(navigatorKey: navigatorKey),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const SplashScreen({super.key, required this.navigatorKey});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {


  // Instance of Firebase Messaging
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  LocalUser? localUser;

  @override
  void initState() {
    super.initState();
    NotificationService().init(widget.navigatorKey);
    _checkLoggedInStatus();
    _setLocalUser();
    _requestPermissions();

    // Initialize FCM
    _initializeFCM();
    _getToken();
  }

  void _setLocalUser() {
    localUser = LocalUser(
        name: "Alice",
        location: "Location",
        expertString: "expertString",
        availability: "availability",
        langString: "langString",
        description: "description");
  }


  Future<void> _checkLoggedInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userDataString = prefs.getString('userData');
    if (token != null && userDataString != null) {
      // User is logged in, navigate to MainScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      // User is not logged in, navigate to LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()));
          }
  }
  // Request notification permissions (especially for iOS)
  void _requestPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('User denied permission');
    }
  }

  // Initialize Firebase Messaging
  void _initializeFCM() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print(message);
        NotificationService().showNotification(
          message: message
        );
      }
    });

    _handleInitialMessage();

    // Handle messages when the app is brought to foreground from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'App opened from terminated state by a message: ${message.notification}');
      widget.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => FutureBuilder<Userprofile>(
            future: MatchingAlgorithm().getUserProfileById(
              int.tryParse(message.data['target_user_id']) ?? 0,
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
                return RequestScreen(
                  userprofile: snapshot.data!,
                  notificationData: NotificationData.fromMessage(message)
                );
              }
            },
          ),
        ),
      );
    });
  }

  void _handleInitialMessage() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      print(
          'App opened from terminated state by a message: ${message.notification}');
      widget.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => FutureBuilder<Userprofile>(
            future: MatchingAlgorithm().getUserProfileById(
              int.tryParse(message.data['target_user_id']) ?? 0,
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
                return RequestScreen(
                  userprofile: snapshot.data!,
                  notificationData:
                    NotificationData.fromMessage(message)
                );
              }
            },
          ),
        ),
      );

    }
  }

  // Retrieve and print the device's FCM token
  void _getToken() async {
    String? token = await _messaging.getToken();
    print('FCM Token: $token');
    localUser?.getTokensList()?.add(token!);
    print('FCM Token: ${localUser?.getTokensList()?.single}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
