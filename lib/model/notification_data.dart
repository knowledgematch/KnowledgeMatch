enum NotificationType {
  knowledgeRequest,
  knowledgeResponse,
  meetupRequest,
  meetupResponse;

  factory NotificationType.fromString(String type) {
    switch (type) {
      case 'knowledgeRequest':
        return NotificationType.knowledgeRequest;
      case 'knowledgeResponse':
        return NotificationType.knowledgeResponse;
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
}