import 'package:flutter/material.dart';
import 'package:knowledgematch/screens/request_screen.dart';

import '../model/notification_data.dart';
import '../model/user.dart';
import '../model/userprofile.dart';
import '../services/firestore_service.dart';
import '../services/matching_algorithm.dart';
import '../widgets/notification_card.dart';

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
