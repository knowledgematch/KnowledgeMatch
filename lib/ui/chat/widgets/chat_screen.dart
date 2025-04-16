import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/chat/view_model/chat_view_model.dart';
import 'package:provider/provider.dart';

import '../../request/view_model/request_view_model.dart';
import '../../request/widgets/notification_card.dart';
import '../../request/widgets/request_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatViewModel>().loadNotificationsAndProfiles();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatViewModel>();

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Requests'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ElevatedButton(
                  onPressed: () {
                    viewModel.loadConfirmedNotificationsAndProfiles();
                  },
                  child: const Text('Confirmed'),
                ),
              ),
            ],
          ),
          body: viewModel.state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.state.errorMessage != null
                  ? Center(
                      child: Text('Error: ${viewModel.state.errorMessage}'))
                  : viewModel.state.notification.isEmpty
                      ? const Center(child: Text('No requests found.'))
                      : ListView.builder(
                          itemCount: viewModel.state.notification.length,
                          itemBuilder: (context, index) {
                            final notification =
                                viewModel.state.notification[index];
                            final userProfile = viewModel
                                .state.userProfiles[notification.sourceUserId];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider<
                                                RequestViewModel>(
                                            create: (_) => RequestViewModel(
                                                  notificationData:
                                                      notification,
                                                  userprofile: userProfile,
                                                ),
                                            child: RequestScreen()),
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
