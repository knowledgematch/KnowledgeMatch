import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:knowledgematch/data/services/matching_algorithm.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../../../data/services/notification_service.dart';
import '../../../domain/models/notification_data.dart';
import '../../../domain/models/search_criteria.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/userprofile.dart';
import '../swipe_state.dart';

class SwipeViewModel extends ChangeNotifier {
  final SearchCriteria searchCriteria;
  late Future<List<Userprofile>> profilesFuture;

  final SwipableStackController controller = SwipableStackController();
  ValueNotifier<bool> hasFinishedNotifier = ValueNotifier<bool>(false);

  SwipeState _state = SwipeState(shouldShowGlow: false);
  SwipeState get state => _state;

  List<Userprofile> profiles = [];
  List<Userprofile> likedProfiles = [];
  List<Userprofile> skippedProfiles = [];

  SwipeViewModel({required this.searchCriteria, bool skipMatching = false}) {
    if (!skipMatching) {
      profilesFuture = MatchingAlgorithm().getMatchingUserProfiles(
        searchCriteria,
      );
    }
    profilesFuture.then((loadedProfiles) {
      profiles = [...loadedProfiles];

      updateTitle();
    });
  }

  void updateTitle() {
    _state = _state.copyWith(title: "Matches (${profiles.length})");
    notifyListeners();
  }

  void handleSwipe(SwipeDirection direction, {VoidCallback? onRightSwipe}) {
    if (controller.currentIndex < 0 || controller.currentIndex >= profiles.length) return;

    final currentProfile = profiles[controller.currentIndex];

    if (direction == SwipeDirection.right) {
      likedProfiles.add(currentProfile);
      sendSwipeRightNotification();
      onRightSwipe?.call();
    } else if (direction == SwipeDirection.left) {
      skippedProfiles.add(currentProfile);
    }
    profiles.removeAt(controller.currentIndex);
    controller.currentIndex--;
    if (profiles.isEmpty) {
      controller.currentIndex = -1;
      hasFinishedNotifier.value = true;
    }
    updateTitle();
    notifyListeners();
  }

  Future<void> sendSwipeRightNotification() async {
    if (controller.currentIndex < 0 || controller.currentIndex >= profiles.length) return;
    var profile = profiles[controller.currentIndex];
    var topic = searchCriteria.keyword;
    var notificationData = NotificationData(
      type: NotificationType.knowledgeRequest,
      title: "Your knowledge has been requested!",
      body: "From: ${User.instance.name}, on Topic: $topic",
      payload: searchCriteria.toJSON(),
      targetUserId: profile.id,
      sourceUserId: User.instance.id ?? 0,
    );
    await NotificationService().sendMessageToDevice(notificationData, profile.tokens ?? []);
  }


  void checkSwipeDirection(double swipeDistance, {bool skipScheduler = false}) {
    bool newShouldShowGlow = swipeDistance > 0.3;
    if (_state.shouldShowGlow != newShouldShowGlow) {
      _state = state.copyWith(shouldShowGlow: newShouldShowGlow);
      if (skipScheduler) {
        notifyListeners();
      } else {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
    }
  }

  void resetStack() {
    if (skippedProfiles.isEmpty) {
      profiles = [];
      hasFinishedNotifier.value = true;
      updateTitle();
      notifyListeners();
      return;
    }
    profiles = [...skippedProfiles];
    skippedProfiles.clear();
    controller.currentIndex = 0;
    hasFinishedNotifier.value = false;
    updateTitle();
    notifyListeners();
  }
}
