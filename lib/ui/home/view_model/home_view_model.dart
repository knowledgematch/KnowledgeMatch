import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:knowledgematch/data/services/api_db_connection.dart';

import '../../../data/services/firestore_service.dart';
import '../../../domain/models/notification_data.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/userprofile.dart';
import '../home_state.dart';

class HomeViewModel extends ChangeNotifier {
  HomeState _state = HomeState(
    openRequests: HashMap(),
    plannedRequests: HashMap(),
  );

  get state => _state;

  HomeViewModel() {
    _loadData();
  }

  Future<void> _loadData() async {
    getOpenRequests();
    getPlannedRequests();
    notifyListeners();
  }

  getOpenRequests() async {
    HashMap<NotificationData, Userprofile> notifications = HashMap();
    List<NotificationData> list = await FirestoreService().fetchNotifications(
      userID: User.instance.id ?? 0,
    );

    for (var notification in list) {
      final usersList = await ApiDbConnection().fetchUserByInput(
        uId: notification.sourceUserId.toString(),
      );
      final userJson = usersList.first;
      Userprofile source = Userprofile.fromJson(userJson);
      notifications.putIfAbsent(notification, () => source);
    }

    _state = state.copyWith(openRequests: notifications);
    // notifyListeners();
  }

  getPlannedRequests() async {
    HashMap<NotificationData, Userprofile> notifications = HashMap();
    List<NotificationData> list = await FirestoreService().fetchNotifications(
      userID: User.instance.id ?? 0,
    );

    for (var notification in list) {
      final usersList = await ApiDbConnection().fetchUserByInput(
        uId: notification.sourceUserId.toString(),
      );
      final userJson = usersList.first;
      Userprofile source = Userprofile.fromJson(userJson);
      notifications.putIfAbsent(notification, () => source);
    }

    _state = state.copyWith(openRequests: notifications);
    notifyListeners();
    // List<NotificationData> plannedNotifications = await FirestoreService()
    //     .fetchConfirmed(userID: User.instance.id ?? 0);
    // plannedNotifications.removeWhere(
    //   (element) => RequestDateData.fromJson(
    //     element.payload,
    //   ).dateTime.isAfter(DateTime.now()),
    // );
    // _state = state.copyWith(plannedRequests: plannedNotifications);
    //
    // notifyListeners();
  }
}
