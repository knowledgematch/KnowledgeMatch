import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:knowledgematch/ui/chat/chat_state.dart';

import '../../../data/services/firestore_service.dart';
import '../../../data/services/matching_algorithm.dart';
import '../../../domain/models/notification_data.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/userprofile.dart';

class ChatViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  StreamSubscription? _notificationSub;

  ChatState _state;

  ChatState get state => _state;

  ChatViewModel() : _state = ChatState() {
    _loadData();
  }

  /// Loads open and planned requests for current user
  Future<void> _loadData() async {
    loadNotificationsPerRequestID();
    notifyListeners();
  }

  /// Cancel the StreamSubscription
  ///
  /// Manually close [_openRequestSub] and [_plannedRequestSub] StreamSubscription
  /// To prevent memory leaks.
  @override
  void dispose() {
    _notificationSub?.cancel();
    super.dispose();
  }

  /// Subscribes to the Firestore notifications stream, grouping notifications by request ID,
  /// fetching and caching user profiles in parallel, and throttling UI updates to every five new items.
  ///
  /// - Listens to a stream of `NotificationData` for the current user.
  /// - Groups incoming notifications into a `Map<String, List<NotificationData>>` keyed by `requestID`.
  /// - Extracts unique source user IDs and fetches their profiles in parallel,
  /// 	caching each `Future<Userprofile?>` to avoid redundant network calls.
  /// - Tracks the total notification count (`lastNotifiedCount`) and notifies the listeners
  ///
  void loadNotificationsPerRequestID() {
    final Map<int, Future<Userprofile?>> profileCache = {};

    _notificationSub = _firestoreService
        .allNotificationsStream(userID: User.instance.id ?? 0)
        .listen((list) async {
          final feedMap = <String, List<NotificationData>>{};
          for (final n in list) {
            feedMap.putIfAbsent(n.requestID ?? '', () => []).add(n);
          }

          final ids = list.map((n) => n.sourceUserId).toSet();

          final futures =
              ids.map((id) {
                return profileCache[id] ??= MatchingAlgorithm()
                    .getUserProfileById(id);
              }).toList();
          final profiles = await Future.wait(futures);
          final userProfiles = Map.fromIterables(ids, profiles);

          _state = state.copyWith(
            notification: feedMap,
            userProfiles: userProfiles,
          );
          notifyListeners();
        });
  }
}
