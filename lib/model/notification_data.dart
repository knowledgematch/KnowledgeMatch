
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

enum NotificationType {
  knowledgeRequest,
  requestDeclined,
  requestAccepted,
  meetupRequest,
  meetupResponse;

  factory NotificationType.fromString(String type) {
    switch (type) {
      case 'knowledgeRequest':
        return NotificationType.knowledgeRequest;
      case 'requestAccepted':
        return NotificationType.requestAccepted;
      case 'requestDeclined' :
        return NotificationType.requestDeclined;
      case 'meetupRequest':
        return NotificationType.meetupRequest;
      case 'meetupResponse':
        return NotificationType.meetupResponse;
      default:
        throw ArgumentError('Invalid NotificationType: $type');
    }
  }

  String toShortString() => name;
}

class NotificationData {
  final NotificationType type;
  final String title;
  final String body;
  final int targetUserId;
  final int sourceUserId;
  final DateTime? timestamp;

  NotificationData({
        required this.type,
        required this.title,
        required this.body,
        required this.targetUserId,
        required this.sourceUserId,
        this.timestamp
  });

  factory NotificationData.fromFirestoreData(Map<String, dynamic> map){
      String fireStoreTimestamp = map['timestamp'];
    return NotificationData(
        type: NotificationType.fromString(map['notification_type'] ?? ''),
        title: map['title'] ?? '',
        body: map['body'] ?? '',
        targetUserId: int.parse(map['target_user_id'] ?? ''),
        sourceUserId: int.parse(map['source_user_id'] ?? ''),
        timestamp: DateTime.parse(fireStoreTimestamp)
      );
  }

  factory NotificationData.fromMessage(RemoteMessage message){
    String fireStoreTimestamp = message.data['timestamp'];
    return NotificationData(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        targetUserId: int.tryParse(message.data['target_user_id']) ?? 0,
        sourceUserId: int.tryParse(message.data['source_user_id']) ?? 0,
        type: NotificationType.fromString(message.data['notification_type']),
        timestamp: DateTime.parse(fireStoreTimestamp)
    );
  }
}