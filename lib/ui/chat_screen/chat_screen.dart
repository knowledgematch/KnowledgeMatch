import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/userprofile.dart';
import 'package:knowledgematch/ui/request_screen/request_screen.dart';
import 'package:knowledgematch/data/services/firestore_service.dart';
import 'package:knowledgematch/widgets/notification_card.dart';
import 'package:knowledgematch/domain/models/notification_data.dart';
import 'package:knowledgematch/domain/models/user.dart';
import 'package:knowledgematch/data/services/matching_algorithm.dart';
import 'package:knowledgematch/ui/confirmed_meetup_screen/confirmed_meetup_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
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
  /// to the first 20 and then retrieves the user profile for each notification's
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
      final notifications = await firestoreService.fetchNotifications(
        userID: User.instance.id ?? 0,
        type: NotificationType.knowledgeRequest,
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
        title: const Text('Requests'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConfirmedMeetupsScreen(),
                ),
              );
            },
            child: const Text('Confirmed'),
          ),
        ],
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
