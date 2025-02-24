import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:knowledgematch/domain/models/notification_data.dart';
import 'package:knowledgematch/domain/models/user.dart';
import 'package:knowledgematch/domain/models/userprofile.dart';

import '../../ui/request/request_screen.dart';
import 'matching_algorithm.dart';

late BuildContext appContext;

class NotificationService {
  GlobalKey<NavigatorState>? navigatorKey;
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  /// Instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialization settings for Android
  final AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  /// Initialization settings for iOS
  final DarwinInitializationSettings initializationSettingsIOS =
      const DarwinInitializationSettings();

  /// Initialization settings for both platforms
  late final InitializationSettings initializationSettings =
      InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  /// Create the notification channel for Android
  Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
    this.navigatorKey = navigatorKey;
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );

    await _createNotificationChannel();
  }

  /// Create a notification channel for Android (8.0+)
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

  /// Handles the notification selection action.
  ///
  /// This method processes the payload of the notification, decodes it, and uses the
  /// `source_user_id` to fetch the corresponding [Userprofile]. The profile is then passed
  /// to a `RequestScreen` for display. If the notification payload is null or invalid,
  /// appropriate actions are taken.
  ///
  /// Parameters:
  /// - [notificationResponse]: The response object containing the notification data.
  Future<void> onSelectNotification(
      NotificationResponse notificationResponse) async {
    if (notificationResponse.payload != null) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(
        jsonDecode(notificationResponse.payload!),
      );
      navigatorKey?.currentState?.push(
        MaterialPageRoute(
          builder: (context) => FutureBuilder<Userprofile>(
            future: MatchingAlgorithm().getUserProfileById(
              int.parse(data['source_user_id'] ?? 0),
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
                    notificationData: NotificationData.fromFirestoreData(data));
              }
            },
          ),
        ),
      );
    }
  }

  /// Displays a notification with the given message and payload.
  ///
  /// This method is responsible for creating and displaying notifications on both
  /// Android and iOS platforms. It uses `flutterLocalNotificationsPlugin` to show
  /// the notification and sets up the notification details (e.g., channel, importance,
  /// and priority). The payload (optional) is also included in the notification data.
  ///
  /// Parameters:
  /// - [message]: The notification message to display.
  /// - [payload]: Optional data to associate with the notification.
  /// - [channelId]: The ID of the notification channel (defaults to 'default_channel').
  /// - [channelName]: The name of the notification channel (defaults to 'Default Notifications').
  /// - [channelDescription]: The description of the notification channel (defaults to a generic description).
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

    var data = NotificationData.fromMessage(message);

    await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        data.title,
        data.body,
        platformChannelSpecifics,
        payload: jsonEncode(data.toJson()));
  }

  /// Sends a message to the specified devices using Firebase Cloud Functions.
  ///
  /// This method is responsible for invoking a Firebase Cloud Function to send
  /// a notification to a list of device tokens. It sends the notification details
  /// such as title, body, payload, and additional metadata (e.g., user IDs, timestamps).
  /// The result of the function call is logged for success or failure.
  ///
  /// Parameters:
  /// - [notificationData]: The notification data to send to the devices.
  /// - [tokens]: The list of device tokens to which the notification will be sent.
  Future<void> sendMessageToDevice(
      NotificationData notificationData, List<String> tokens) async {
    final result =
        await FirebaseFunctions.instance.httpsCallable('sendToDevice').call(
      {
        'tokens': tokens,
        'title': notificationData.title,
        'body': notificationData.body,
        'payload': notificationData.payload,
        'target_user_id': notificationData.targetUserId.toString(),
        'source_user_id': User.instance.id,
        'notification_type': notificationData.type.toShortString(),
        'timestamp': notificationData.timestamp.toString(),
        'request_id': notificationData.requestID,
        'is_open': notificationData.isOpen,
        'document_id': notificationData.documentID,
      },
    );
    if (result.data['success']) {
      print('Message sent successfully');
    } else {
      print('Failed to send message: ${result.data['error']}');
    }
  }
}
