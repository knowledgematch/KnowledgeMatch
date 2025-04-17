import 'package:flutter/material.dart';

import '../../../data/services/firestore_service.dart';
import '../../../domain/models/notification_data.dart';
import '../../../domain/models/user.dart';
import '../home_state.dart';

class HomeViewModel extends ChangeNotifier {
  HomeState _state = HomeState(openRequests: [], plannedRequests: []);

  get state => _state;

  HomeViewModel() {
    _loadData();
  }

  Future<void> _loadData() async {
    getOpenRequests();
    getPlannedRequests();
  }

  getOpenRequests() async {
    List<NotificationData> notifications = await FirestoreService()
        .fetchNotifications(userID: User.instance.id ?? 0);
    _state = state.copyWith(openRequests: notifications);

    notifyListeners();
  }

  getPlannedRequests() async {
    List<NotificationData> plannedNotifications = await FirestoreService()
        .fetchNotifications(userID: User.instance.id ?? 0);
    _state = state.copyWith(plannedRequests: plannedNotifications);

    notifyListeners();
  }
}
