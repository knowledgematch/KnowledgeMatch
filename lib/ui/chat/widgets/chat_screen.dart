import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/chat/view_model/chat_view_model.dart';
import 'package:provider/provider.dart';

import 'feed_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatViewModel>().loadNotificationsPerRequestID();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatViewModel>();

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Requests')),
          body: FeedWidget(),
          // viewModel.state.isLoading
          //     ? const Center(child: CircularProgressIndicator())
          //     : viewModel.state.errorMessage != null
          //     ? Center(
          //       child: Text('Error: ${viewModel.state.errorMessage}'),
          //     )
          //     : viewModel.state.notification.isEmpty
          //     ? const Center(child: Text('No requests found.'))
          //     : FeedWidget(),
        );
      },
    );
  }
}
