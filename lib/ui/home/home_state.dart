import '../../domain/models/notification_data.dart';
import '../../domain/models/user.dart';

class HomeState {
  late List<NotificationData> openRequests = [];
  late List<NotificationData> plannedRequests = [];
  String userName = User.instance.name ?? "Update your name please";
  String profilePicture = User.instance.picture ?? 'assets/images/profile.png';

  HomeState({required this.openRequests, required this.plannedRequests});

  HomeState copyWith({
    String? userName,
    List<NotificationData>? openRequests,
    List<NotificationData>? plannedRequests,
  }) {
    return HomeState(
      openRequests: openRequests ?? this.openRequests,
      plannedRequests: plannedRequests ?? this.plannedRequests,
    );
  }
}
