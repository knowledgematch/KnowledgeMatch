import 'package:flutter/foundation.dart';
import 'package:knowledgematch/ui/chat/chat_state.dart';

import '../../../data/services/firestore_service.dart';
import '../../../data/services/matching_algorithm.dart';
import '../../../domain/models/notification_data.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/userprofile.dart';

class ChatViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  ChatState _state;

  ChatState get state => _state;

  ChatViewModel() : _state = ChatState();

  /// Loads notifications and user profiles asynchronously.
  ///
  /// This method fetches notifications of type [NotificationType.knowledgeRequest]
  /// for the current user using the [firestoreService]. It limits the notifications
  /// to the first 20 and then retrieves the user profile for each request's
  /// source user. The notifications and user profiles are stored in local variables
  /// and the UI is updated accordingly.
  ///
  /// If an error occurs during the process, the error message is captured and the
  /// loading state is updated.
  ///
  /// Returns:
  /// - A [Future] that completes when notifications and user profiles have been
  ///   loaded and the UI state has been updated.
  Future<void> loadNotificationsAndProfiles() async {
    try {
      final notifications = await _firestoreService.fetchNotifications(
        userID: User.instance.id ?? 0,
        type: NotificationType.knowledgeRequest,
      );

      final limitedNotifications = notifications.take(20).toList();

      Map<int, Userprofile?> userProfiles = {};
      for (final notification in limitedNotifications) {
        final userProfile = await MatchingAlgorithm()
            .getUserProfileById(notification.sourceUserId);
        userProfiles[notification.sourceUserId] = userProfile;
      }
      _state = state.copyWith(
        userProfiles: userProfiles,
        notifications: limitedNotifications,
      );
    } catch (error) {
      _state = state.copyWith(errorMessage: error.toString());
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }
}