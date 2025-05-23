import 'dart:collection';

import '../../domain/models/notification_data.dart';
import '../../domain/models/userprofile.dart';

class HomeState {
  late LinkedHashMap<NotificationData, Userprofile> openRequests;
  late LinkedHashMap<NotificationData, Userprofile> plannedRequests;
  late LinkedHashMap<NotificationData, Userprofile> pendingRequests;

  HomeState({
    required this.openRequests,
    required this.plannedRequests,
    required this.pendingRequests,
  });

  HomeState copyWith({
    LinkedHashMap<NotificationData, Userprofile>? openRequests,
    LinkedHashMap<NotificationData, Userprofile>? plannedRequests,
    LinkedHashMap<NotificationData, Userprofile>? pendingRequests,
  }) {
    return HomeState(
      openRequests: openRequests ?? this.openRequests,
      plannedRequests: plannedRequests ?? this.plannedRequests,
      pendingRequests: pendingRequests ?? this.pendingRequests,
    );
  }
}
