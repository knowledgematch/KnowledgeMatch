import 'package:flutter/cupertino.dart';

import '../../../data/services/firestore_service.dart';
import '../../../data/services/matching_algorithm.dart';
import '../../../domain/models/notification_data.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/userprofile.dart';

class ChatViewModel extends ChangeNotifier {
  final FirestoreService firestoreService = FirestoreService();
  final Map<int, Userprofile?> userProfiles = {};
  List<NotificationData> notificationList = [];
  String? errorMessage;
  bool isLoading = true;

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
    isLoading = true;
    notifyListeners();

    try {
      final notifications = await firestoreService.fetchNotifications(
        userID: User.instance.id ?? 0,
        type: NotificationType.knowledgeRequest,
      );

      final limitedNotifications = notifications.take(20).toList();

      for (final notification in limitedNotifications) {
        final userProfile = await MatchingAlgorithm()
            .getUserProfileById(notification.sourceUserId);
        userProfiles[notification.sourceUserId] = userProfile;
      }

      notificationList = limitedNotifications;
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}