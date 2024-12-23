import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

enum NotificationType {
  knowledgeRequest,
  requestDeclined,
  requestAccepted,
  meetupRequest,
  meetupConfirmation;

  factory NotificationType.fromString(String type) {
    switch (type) {
      case 'knowledgeRequest':
        return NotificationType.knowledgeRequest;
      case 'requestAccepted':
        return NotificationType.requestAccepted;
      case 'requestDeclined':
        return NotificationType.requestDeclined;
      case 'meetupRequest':
        return NotificationType.meetupRequest;
      case 'meetupConfirmation':
        return NotificationType.meetupConfirmation;
      default:
        throw ArgumentError('Invalid NotificationType: $type');
    }
  }

  String toShortString() => name;
}

class NotificationData {
  final String? requestID;
  final bool? isOpen;
  final NotificationType type;
  final String title;
  final String description;
  final Map<String, dynamic> body;
  final int targetUserId;
  final int sourceUserId;
  final DateTime? timestamp;

  NotificationData(
      {required this.type,
      required this.title,
      required this.description,
      required this.body,
      required this.targetUserId,
      required this.sourceUserId,
      this.timestamp,
      this.requestID,
      this.isOpen});

  factory NotificationData.fromFirestoreData(Map<String, dynamic> map) {
    String fireStoreTimestamp = map['timestamp'];
    return NotificationData(
        type: NotificationType.fromString(map['notification_type'] ?? ''),
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        body: map['body'] ?? '',
        targetUserId: int.parse(map['target_user_id'] ?? ''),
        sourceUserId: int.parse(map['source_user_id'] ?? ''),
        timestamp: DateTime.parse(fireStoreTimestamp).toLocal(),
        requestID: map['request_id'] ?? '',
        isOpen: bool.parse(map['is_open'] ?? true));
  }

  factory NotificationData.fromMessage(RemoteMessage message) {
    String fireStoreTimestamp = message.data['timestamp'];
    return NotificationData(
        type: NotificationType.fromString(message.data['notification_type']),
        title: message.notification?.title ?? '',
        description: message.data['description'] ?? '',
        body: jsonDecode(message.notification?.body ?? ''),
        targetUserId: int.tryParse(message.data['target_user_id']) ?? 0,
        sourceUserId: int.tryParse(message.data['source_user_id']) ?? 0,
        timestamp: DateTime.parse(fireStoreTimestamp).toLocal(),
        requestID: message.data['request_id'] ?? '',
        isOpen: message.data['is_open']);
  }
}
