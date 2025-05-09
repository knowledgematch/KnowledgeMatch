import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:knowledgematch/data/services/matching_algorithm.dart';

import '../../../data/services/notification_service.dart';
import '../../../domain/models/notification_data.dart';
import '../../../domain/models/search_criteria.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/userprofile.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../swipe_state.dart';

class SwipeViewModel extends ChangeNotifier {
  final SearchCriteria searchCriteria;
  late final Future<List<Userprofile>> profilesFuture;

  SwipeState _state = SwipeState(shouldShowGlow: false);

  SwipeState get state => _state;

  final SwipableStackController controller = SwipableStackController();

  List<Userprofile> profiles = [];

  SwipeViewModel({required this.searchCriteria}) {
    profilesFuture = MatchingAlgorithm().getMatchingUserProfiles(
      searchCriteria,
    );
    profilesFuture.then((loadedProfiles) {
      profiles = loadedProfiles;
      updateTitle();
    });
  }

  void updateTitle() {
    _state = _state.copyWith(title: "Matches (${profiles.length})");
    notifyListeners();
  }

  /// Use the NotificationService to send a [NotificationType.knowledgeRequest] request.
  ///
  /// Creates [NotificationData] from [SearchCriteria] and [Userprofile].
  /// Uses the [NotificationService] to send the data to the users [Userprofile.tokens]
  ///
  /// @param profile to send the request to.

  Future<void> sendSwipeRightNotification() async {
    var profile = profiles[controller.currentIndex];
    var topic = searchCriteria.keyword;
    var notificationData = NotificationData(
      type: NotificationType.knowledgeRequest,
      title: "Your knowledge has been requested!",
      body: "From: ${User.instance.name},on Topic: $topic",
      payload: searchCriteria.toJSON(),
      targetUserId: profile.id,
      sourceUserId: User.instance.id ?? 0,
    );
    profiles.removeAt(controller.currentIndex);
    await NotificationService().sendMessageToDevice(
      notificationData,
      profile.tokens ?? [],
    );
  }

  void handleSwipe(SwipeDirection direction, BuildContext context) {
    if (direction == SwipeDirection.right) {
      //send request
      final snackBar = SnackBar(
        content: const Text('Request sent'),
        duration: Duration(milliseconds: 500),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      sendSwipeRightNotification();
      controller.currentIndex--;
      updateTitle();
      notifyListeners();
    }
    if (controller.currentIndex == profiles.length - 1) {
      controller.currentIndex = -1;
    }
  }

  void checkSwipeDirection(double swipeDistance) {
    bool newShouldShowGlow = swipeDistance > 0.8;
    if (_state.shouldShowGlow != newShouldShowGlow) {
      _state = state.copyWith(shouldShowGlow: newShouldShowGlow);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}
