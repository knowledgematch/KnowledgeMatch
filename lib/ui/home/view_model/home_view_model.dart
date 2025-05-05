import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:knowledgematch/data/services/api_db_connection.dart';

import '../../../data/services/firestore_service.dart';
import '../../../domain/models/notification_data.dart';
import '../../../domain/models/request_date_data.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/userprofile.dart';
import '../home_state.dart';

class HomeViewModel extends ChangeNotifier {
  HomeState _state = HomeState(
    openRequests: HashMap(),
    plannedRequests: HashMap(),
  );

  get state => _state;

  /// Creates a [HomeViewModel] and begins loading the [NotificationData] for the request
  HomeViewModel() {
    _loadData();
    User.instance.addListener(_onUserChanged);
  }

  void refresh() {
    _loadData();
    notifyListeners();
  }

  /// Loads open and planned requests for current user
  Future<void> _loadData() async {
    await getOpenRequests();
    await getPlannedRequests();
    notifyListeners();
  }

  void _onUserChanged() {
    notifyListeners();
  }

  /// Loads all open (unconfirmed) requests for the current user.
  ///
  /// Uses [FirestoreService.fetchNotifications] to retrieve
  /// [NotificationData], then looks up each source user via
  /// [ApiDbConnection.fetchUserByInput], and updates [_state].
  getOpenRequests() async {
    HashMap<NotificationData, Userprofile> notifications = HashMap();
    List<NotificationData> list = await FirestoreService().fetchNotifications(
      userID: User.instance.id ?? 0,
      isOpen: true,
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
  }

  /// Loads all confirmed (planned) requests up to now for the current user.
  ///
  /// Uses [FirestoreService.fetchConfirmed] to retrieve
  /// [NotificationData], filters out future [RequestDateData], then
  /// looks up each source user via [ApiDbConnection.fetchUserByInput],
  /// and updates [_state].
  getPlannedRequests() async {
    HashMap<NotificationData, Userprofile> notifications = HashMap();
    List<NotificationData> list = await FirestoreService().fetchConfirmed(
      userID: User.instance.id ?? 0,
    );

    for (var element in list) {
      print(element.payload.toString());
    }
    if (list.isNotEmpty) {
      list.removeWhere(
        (element) => DateTime.now().isAfter(
          RequestDateData.fromConfirmationJson(
            element.payload,
          ).dateTime.toLocal(),
        ),
      );
    }

    for (var notification in list) {
      final usersList = await ApiDbConnection().fetchUserByInput(
        uId: notification.sourceUserId.toString(),
      );
      final userJson = usersList.first;
      Userprofile source = Userprofile.fromJson(userJson);
      notifications.putIfAbsent(notification, () => source);
    }

    _state = state.copyWith(plannedRequests: notifications);
  }
}
