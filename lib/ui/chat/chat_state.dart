import '../../domain/models/notification_data.dart';
import '../../domain/models/userprofile.dart';

class ChatState {
  final bool isLoading;
  final Map<int, Userprofile?> userProfiles;
  final List<NotificationData> notification;
  final String? errorMessage;

  ChatState({
    this.isLoading = true,
    this.userProfiles = const {},
    this.notification = const [],
    this.errorMessage,
  });

  ChatState copyWith({
    bool? isLoading,
    Map<int, Userprofile?>? userProfiles,
    List<NotificationData>? notification,
    String? errorMessage,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      userProfiles: userProfiles ?? this.userProfiles,
      notification: notification ?? this.notification,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
