import '../../../domain/models/notification_data.dart';
import '../../../domain/models/userprofile.dart';

class Request {
  final NotificationData notificationData;
  final Userprofile userprofile;

  const Request({required this.notificationData, required this.userprofile});
}
