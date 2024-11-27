
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
  final int userId;

  NotificationData({
        required this.type,
        required this.title,
        required this.body,
        required this.userId
  });

  factory NotificationData.fromFirestoreRequest(Map<String, dynamic> map){
      final String combinedBody = [
        map['body'] ?? '',
        map['sourceUserId'] ?? '',
        map['success'] ?? '',
        map['targetUserId'] ?? '',
        map['timestamp'] ?? '',
      ].join(', ');

      return NotificationData(
        type: NotificationType.fromString(map['notificationType'] ?? ''),
        title: map['title'] ?? '',
        body: combinedBody,
        userId: int.parse(map['targetUserId'] ?? ''),
      );

  }
}