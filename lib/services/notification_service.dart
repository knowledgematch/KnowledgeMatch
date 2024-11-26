import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../model/notification_data.dart';
import '../model/userprofile.dart';
import '../screens/request_screen.dart';
import 'matching_algorithm.dart';


late BuildContext appContext;

class NotificationService {
  GlobalKey<NavigatorState>? navigatorKey;
  // Singleton pattern
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  // Instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialization settings for Android
  final AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  // Initialization settings for iOS
  final DarwinInitializationSettings initializationSettingsIOS =
      const DarwinInitializationSettings();

  // Initialization settings for both platforms
  late final InitializationSettings initializationSettings =
      InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );


  Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
    this.navigatorKey = navigatorKey;
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );

    // Create the notification channel for Android
    await _createNotificationChannel();
  }

  // Create a notification channel for Android (8.0+)
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel',
      'Default Notifications',
      description: 'This channel is used for default notifications.',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> onSelectNotification(
      NotificationResponse notificationResponse) async {
    if (notificationResponse.payload != null) {
      print('Notification payload: ${notificationResponse.payload}');

      final Map<String, dynamic> data = Map<String, dynamic>.from(
        jsonDecode(notificationResponse.payload!),
      );
      print(int.tryParse(data['target_user_id']) ?? 0);
      navigatorKey?.currentState?.push(
        MaterialPageRoute(
          builder: (context) => FutureBuilder<Userprofile>(
            future: MatchingAlgorithm().getUserProfile(
              int.tryParse(data['target_user_id']) ?? 0,
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
                  notificationData: NotificationData(
                    title: data['title'],
                    body: data['body'],
                    userId: int.tryParse(data['target_user_id']) ?? 0,
                    type: NotificationType.fromString(data['notification_type']),
                  ),
                );
              }
            },
          ),
        ),
      );
    }
  }

  Future<void> showNotification({
    required RemoteMessage message,
    String? payload,
    String channelId = 'default_channel',
    String channelName = 'Default Notifications',
    String channelDescription =
    'This channel is used for default notifications.',
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      channelDescription: 'This channel is used for default notifications.',
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
    final String notificationPayload = jsonEncode({
      ...message.data,
      'title': message.notification?.title ?? '',
      'body': message.notification?.body ?? '',
    });
    print(notificationPayload);

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: notificationPayload,
    );
  }


  Future<void> sendMessageToDevice(
      NotificationData notificationData) async {
    List<String> tokens = [];
    tokens.add(
      "eA5YhA32RJWALJsDphXdfG:APA91bEh6s3D7vlrk0RkL4FlicsBqDi4o63HxNnnSIYiEyaw6XspZ9JO7H7mZ2bDBHTE_zenOzVucVhfbsMlttO-2YO-B8JgK9RCcZrFzWTRArxuiNMsd4U"
    );
    tokens.add(
        "d8wMnn4NR7S41Sc7dAjppd:APA91bEoCbXE2X-sCf9iXqo7CDQGEjvtRCI2KU2YQXoiJnMYeD7i2Rfs3XYQWUzbKXbMUSPENK0cyWQ_V-3X_pzSb-_PQHeVX5LLhh6n6kC98Ed9GfBbvVw"
    );

    final result =
        await FirebaseFunctions.instance.httpsCallable('sendToDevice').call(
      {
        'tokens': tokens,
        'title': notificationData.title,
        'body': notificationData.body,
        'target_user_id': notificationData.userId.toString(),
        'source_user_id': "1234",
        'notification_type': notificationData.type.toShortString()
      },
    );
    if (result.data['success']) {
      print('Message sent successfully');
    } else {
      print('Failed to send message: ${result.data['error']}');
    }
  }
}
