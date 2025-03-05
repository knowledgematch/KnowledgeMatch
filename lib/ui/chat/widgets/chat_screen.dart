import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/chat/view_model/chat_view_model.dart';

import '../../confirmed_meetups/confirmed_meetup_screen.dart';
import '../../request/view_model/request_view_model.dart';
import '../../request/widgets/notification_card.dart';
import '../../request/widgets/request_screen.dart';

class ChatScreen extends StatefulWidget {
  final ChatViewModel viewModel;

  const ChatScreen({super.key, required this.viewModel});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
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
          body: widget.viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : widget.viewModel.errorMessage != null
              ? Center(child: Text('Error: ${widget.viewModel.errorMessage}'))
              : widget.viewModel.notificationList.isEmpty
              ? const Center(child: Text('No requests found.'))
              : ListView.builder(
            itemCount: widget.viewModel.notificationList.length,
            itemBuilder: (context, index) {
              final notification =
              widget.viewModel.notificationList[index];
              final userProfile = widget
                  .viewModel.userProfiles[notification.sourceUserId];

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
