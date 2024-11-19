import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:knowledgematch/model/local_user.dart';
import 'package:knowledgematch/screens/request_screen.dart';
import 'package:knowledgematch/services/notification_service.dart';
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

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Instance of Firebase Messaging
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  LocalUser? localUser;

  @override
  void initState() {
    super.initState();
    NotificationService().init(navigatorKey);
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
        NotificationService().showNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: message.notification?.title ?? 'New Notification',
          body: message.notification?.body ?? '',
        );
      }
    });

    _handleInitialMessage();

    // Handle messages when the app is brought to foreground from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'App opened from terminated state by a message: ${message.notification}');
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => RequestScreen(
            requesterName: "Alice",
            requesterTitle: message.notification?.title ?? 'no title',
            requesterLocation: "Brugg",
            issueDescription: message.notification?.body ?? 'no description',
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
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => RequestScreen(
            requesterName: "Alice",
            requesterTitle: message.notification?.title ?? 'no title',
            requesterLocation: "Brugg",
            issueDescription: message.notification?.body ?? 'no description',
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
    appContext = context;
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Knowledge Match',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}
