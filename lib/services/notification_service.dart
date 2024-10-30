import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
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
  late final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  Future<void> init() async {
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
      'default_channel', // Channel ID
      'Default Notifications', // Channel Name
      description: 'This channel is used for default notifications.', // Description
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Handle notification tapped logic here
  Future<void> onSelectNotification(NotificationResponse notificationResponse) async {
    // You can navigate the user to a specific screen or perform other actions
    if (notificationResponse.payload != null) {
      print('Notification payload: ${notificationResponse.payload}');
      // Implement your logic here
    }
  }

  // Method to display a notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = 'default_channel',
    String channelName = 'Default Notifications',
    String channelDescription = 'This channel is used for default notifications.',
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'default_channel', // Channel ID
      'Default Notifications', // Channel Name
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

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
