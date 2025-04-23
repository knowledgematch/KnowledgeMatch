import 'dart:collection';

import '../../domain/models/notification_data.dart';
import '../../domain/models/user.dart';
import '../../domain/models/userprofile.dart';

class HomeState {
  late HashMap<NotificationData, Userprofile> openRequests;
  late HashMap<NotificationData, Userprofile> plannedRequests;
  String userName = User.instance.name ?? "";
  final profilePicture = User.instance.getDecodedPicture();

  HomeState({required this.openRequests, required this.plannedRequests});

  HomeState copyWith({
    HashMap<NotificationData, Userprofile>? openRequests,
    HashMap<NotificationData, Userprofile>? plannedRequests,
  }) {
    return HomeState(
      openRequests: openRequests ?? this.openRequests,
      plannedRequests: plannedRequests ?? this.plannedRequests,
    );
  }
}
