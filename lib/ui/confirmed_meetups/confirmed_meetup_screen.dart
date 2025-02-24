import 'package:flutter/material.dart';

import 'package:knowledgematch/domain/models/notification_data.dart';
import 'package:knowledgematch/domain/models/user.dart';
import 'package:knowledgematch/domain/models/userprofile.dart';
import 'package:knowledgematch/data/services/firestore_service.dart';
import 'package:knowledgematch/data/services/matching_algorithm.dart';

import '../request/widgets/notification_card.dart';
import '../request/widgets/request_screen.dart';


class ConfirmedMeetupsScreen extends StatefulWidget {
  const ConfirmedMeetupsScreen({super.key});

  @override
  ConfirmedMeetupsScreenState createState() => ConfirmedMeetupsScreenState();
}

class ConfirmedMeetupsScreenState extends State<ConfirmedMeetupsScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final Map<int, Userprofile?> _userProfiles = {};
  List<NotificationData> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotificationsAndProfiles();
  }

//TODO move to service class
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
  Future<void> _loadNotificationsAndProfiles() async {
    try {
      final notifications = await firestoreService.fetchConfirmed(
        userID: User.instance.id ?? 0,
      );

      final limitedNotifications = notifications.take(20).toList();

      for (final notification in limitedNotifications) {
        final userProfile = await MatchingAlgorithm()
            .getUserProfileById(notification.sourceUserId);
        _userProfiles[notification.sourceUserId] = userProfile;
      }

      setState(() {
        _notifications = limitedNotifications;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmed Requests'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Error: $_errorMessage'))
              : _notifications.isEmpty
                  ? const Center(child: Text('No requests found.'))
                  : ListView.builder(
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        final userProfile =
                            _userProfiles[notification.sourceUserId];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestScreen(
                                  notificationData: notification,
                                  userprofile: userProfile,
                                ),
                              ),
                            );
                          },
                          child: NotificationCard(
                            notification: notification,
                            userprofile: userProfile!,
                          ),
                        );
                      },
                    ),
    );
  }
}
