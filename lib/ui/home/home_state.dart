import 'dart:collection';

import '../../domain/models/notification_data.dart';
import '../../domain/models/user.dart';
import '../../domain/models/userprofile.dart';

class HomeState {
  late HashMap<NotificationData, Userprofile> openRequests;
  late HashMap<NotificationData, Userprofile> plannedRequests;
  String userName = User.instance.name ?? "Update your name please";
  String profilePicture = User.instance.picture ?? 'assets/images/profile.png';

  HomeState({required this.openRequests, required this.plannedRequests});

  HomeState copyWith({
    String? userName,
    HashMap<NotificationData, Userprofile>? openRequests,
    HashMap<NotificationData, Userprofile>? plannedRequests,
  }) {
    return HomeState(
      openRequests: openRequests ?? this.openRequests,
      plannedRequests: plannedRequests ?? this.plannedRequests,
    );
  }
}
