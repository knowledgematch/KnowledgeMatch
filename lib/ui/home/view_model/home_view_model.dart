import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:knowledgematch/data/services/api_db_connection.dart';
import 'package:knowledgematch/data/services/matching_algorithm.dart';

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

  StreamSubscription? _openRequestSub;
  StreamSubscription? _plannedRequestSub;

  /// Creates a [HomeViewModel] and begins loading the [NotificationData] for the request
  //
  /// Registers a Listener on the ChangeNotifier[User.instance] to rebuild the HomeScreen.
  HomeViewModel() {
    _loadData();
    User.instance.addListener(() => notifyListeners());
  }

  /// Loads the data and rebuilds HomeScreen
  void refresh() {
    _loadData();
    notifyListeners();
  }

  /// Loads open and planned requests for current user
  Future<void> _loadData() async {
    await getAndListenForOpenRequests();
    await getAndListenForPlannedRequests();
    notifyListeners();
  }

  /// Cancel the StreamSubscription
  ///
  /// Manually close [_openRequestSub] and [_plannedRequestSub] StreamSubscription
  /// To prevent memory leaks.
  @override
  void dispose() {
    _openRequestSub?.cancel();
    _plannedRequestSub?.cancel();
    super.dispose();
  }

  /// Loads all open requests for the current user.
  ///
  /// Opens a [FirestoreService.openNotificationsStream] to retrieve all open
  /// [NotificationData] and listen for updates on Firestore. Looks up each source user via
  /// [ApiDbConnection.fetchUserByInput], and updates [_state]. Then nofies the listeners;
  getAndListenForOpenRequests() async {
    _openRequestSub = FirestoreService()
        .openNotificationsStream(userID: User.instance.id ?? 0, isOpen: true)
        .listen((list) async {
          final HashMap<NotificationData, Userprofile> notifications =
              HashMap();

          for (var notification in list) {
            final usersList = await ApiDbConnection().fetchUserByInput(
              uId: notification.sourceUserId.toString(),
            );
            final userJson = usersList.first;
            Userprofile source = Userprofile.fromJson(userJson);
            notifications.putIfAbsent(notification, () => source);
          }
          _state = _state.copyWith(openRequests: notifications);
          notifyListeners();
        });
  }

  /// Loads all confirmed (planned) requests up to now for the current user.
  ///
  /// Uses [FirestoreService.fetchConfirmed] to retrieve
  /// [NotificationData], filters out future [RequestDateData], then
  /// looks up each source user via [ApiDbConnection.fetchUserByInput],
  /// and updates [_state].
  getAndListenForPlannedRequests() async {
    _plannedRequestSub = FirestoreService()
        .confirmedNotificationsStream(userID: User.instance.id ?? 0)
        .listen((list) async {
          HashMap<NotificationData, Userprofile> notifications = HashMap();
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
            final user = await MatchingAlgorithm().getUserProfileById(
              notification.sourceUserId,
            );
            notifications.putIfAbsent(notification, () => user);
          }

          _state = state.copyWith(plannedRequests: notifications);
          notifyListeners();
        });
  }
}
