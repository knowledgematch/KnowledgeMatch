import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../request/view_model/request_view_model.dart';
import '../../request/widgets/notification_card.dart';
import '../../request/widgets/request_screen.dart';
import '../view_model/chat_view_model.dart';

class FeedWidget extends StatefulWidget {
  const FeedWidget({super.key});

  @override
  State<StatefulWidget> createState() => FeedWidgetState();
}

class FeedWidgetState extends State<FeedWidget> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatViewModel>();
    final latest = viewModel.state.notification.first;
    final profile = viewModel.state.userProfiles[latest.sourceUserId]!;

    bool temp = false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        initiallyExpanded: temp, //viewModel.state.feedIsExpanded,
        onExpansionChanged: (open) => setState(() => temp = open),
        title: NotificationCard(
          notification: latest,
          userprofile: profile,
        ),
        children: viewModel.state.notification.skip(0).map((n) {
          final up = viewModel.state.userProfiles[n.sourceUserId]!;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChangeNotifierProvider<RequestViewModel>(
                          create: (_) => RequestViewModel(
                                notificationData: n,
                                userprofile: up,
                              ),
                          child: RequestScreen()),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: NotificationCard(
                notification: n,
                userprofile: up,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
