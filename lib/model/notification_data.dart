enum NotificationType {
  knowledgeRequest,
  knowledgeResponse,
  meetupRequest,
  meetupResponse
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