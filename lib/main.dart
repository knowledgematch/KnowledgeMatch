import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//Globally accesible: Instance of Local Notifications Plugin
final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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

  // Instance of Firebase Messaging
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;



  @override
  void initState() {
    super.initState();

    // Request permission on iOS (optional for Android)
    _requestPermissions();

    // Initialize FCM
    _initializeFCM();

    // Retrieve the device token (optional)
    _getToken();

    //initialize local notifications
    _initializeLocalNotifications();
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');


    //TODO when adding IOS
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
    );

    //TODO: Add logic for when message gets selected!
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: null,
    );

    // Create notification channel (Android 8.0 and above)
    _createNotificationChannel();
  }

  void _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // ID
      'High Importance Notifications', // Name
      description: 'This channel is used for important notifications.', // Description
      importance: Importance.max,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
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
      print('Received a message while in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // You can show a local notification here using flutter_local_notifications
      }
    });

    // Handle messages when the app is opened from a terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print('App opened from terminated state by a message: ${message.data}');
        // Navigate to a specific screen if needed
      }
    });

    // Handle messages when the app is brought to foreground from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!: ${message.data}');
      // Navigate to a specific screen if needed
    });
  }

  // Retrieve and print the device's FCM token
  void _getToken() async {
    String? token = await _messaging.getToken();
    print('FCM Token: $token');
    // You can send the token to your server or save it locally
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profiles Swipe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }

  Future<void> _sendTestNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'test_channel', // Channel ID
      'Test Notifications', // Channel Name
      channelDescription: 'This channel is used for test notifications.', // Description
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
    DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Test Notification', // Notification Title
      'This is a test notification generated locally.', // Notification Body
      platformChannelSpecifics,
      payload: 'Test Payload', // Optional payload
    );
  }



}
