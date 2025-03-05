import 'package:flutter/material.dart';

import '../../request/view_model/request_view_model.dart';
import '../../request/widgets/notification_card.dart';
import '../../request/widgets/request_screen.dart';
import '../view_model/confirmed_meetup_view_model.dart';

class ConfirmedMeetupsScreen extends StatefulWidget {
  final ConfirmedMeetupViewModel viewModel;

  const ConfirmedMeetupsScreen({super.key, required this.viewModel});

  @override
  ConfirmedMeetupsScreenState createState() => ConfirmedMeetupsScreenState();
}

class ConfirmedMeetupsScreenState extends State<ConfirmedMeetupsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.loadNotificationsAndProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Confirmed Requests'),
          ),
          body: widget.viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : widget.viewModel.errorMessage != null
              ? Center(child: Text('Error: ${widget.viewModel.errorMessage}'))
              : widget.viewModel.notification.isEmpty
              ? const Center(child: Text('No requests found.'))
              : ListView.builder(
            itemCount: widget.viewModel.notification.length,
            itemBuilder: (context, index) {
              final notification = widget.viewModel.notification[index];
              final userProfile = widget.viewModel.userProfiles[notification.sourceUserId];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestScreen(
                        viewModel: RequestViewModel(
                          notificationData: notification,
                          userprofile: userProfile,
                        ),
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
      },
    );
  }
}
