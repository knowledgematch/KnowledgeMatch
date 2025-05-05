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
  final String? documentID;
  final String? requestID;
  final bool? isOpen;
  final NotificationType type;
  final String title;
  final String body;
  final Map<String, dynamic> payload;
  final int targetUserId;
  final int sourceUserId;
  final DateTime? timestamp;

  NotificationData({
    required this.type,
    required this.title,
    required this.body,
    required this.payload,
    required this.targetUserId,
    required this.sourceUserId,
    this.timestamp,
    this.requestID,
    this.isOpen,
    this.documentID,
  });

  /// A factory constructor that creates a [NotificationData] instance from a Firestore data map.
  factory NotificationData.fromFirestoreData({
    required Map<String, dynamic> jsonMap,
    String? documentID = '',
  }) {
    String fireStoreTimestamp = jsonMap['timestamp'];
    return NotificationData(
      type: NotificationType.fromString(jsonMap['notification_type'] ?? ''),
      title: jsonMap['title'] ?? '',
      body: jsonMap['body'] ?? '',
      payload: jsonMap['payload'] ?? '',
      targetUserId: int.parse(jsonMap['target_user_id'] ?? ''),
      sourceUserId: int.parse(jsonMap['source_user_id'] ?? ''),
      timestamp: DateTime.parse(fireStoreTimestamp).toLocal(),
      requestID: jsonMap['request_id'] ?? '',
      isOpen: bool.tryParse(jsonMap['is_open'] ?? true),
      documentID: documentID,
    );
  }

  /// A factory constructor that creates a [NotificationData] instance from a [RemoteMessage].
  factory NotificationData.fromMessage(RemoteMessage message) {
    String fireStoreTimestamp = message.data['timestamp'];
    return NotificationData(
      type: NotificationType.fromString(message.data['notification_type']),
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      payload: jsonDecode(message.data['payload'] ?? ''),
      targetUserId: int.tryParse(message.data['target_user_id']) ?? 0,
      sourceUserId: int.tryParse(message.data['source_user_id']) ?? 0,
      timestamp: DateTime.parse(fireStoreTimestamp).toLocal(),
      requestID: message.data['request_id'] ?? '',
      isOpen: bool.tryParse(message.data['is_open']),
      documentID: message.data['document_id'] ?? '',
    );
  }

  /// Converts this NotificationData object into a [json]-serializable Map.
  Map<String, dynamic> toJson() {
    return {
      'request_id': requestID,
      'is_open': isOpen.toString(),
      'notification_type': type.toShortString(),
      'title': title,
      'body': body,
      'payload': payload,
      'target_user_id': targetUserId.toString(),
      'source_user_id': sourceUserId.toString(),
      'timestamp': timestamp?.toUtc().toIso8601String(),
      'document_id': documentID,
    };
  }

  ///For using NotificationData in Maps
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationData && other.documentID == documentID;

  @override
  int get hashCode => documentID.hashCode;
}
