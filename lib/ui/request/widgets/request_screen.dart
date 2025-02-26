import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/notification_data.dart';

import '../view_model/request_view_model.dart';
import 'notification_body.dart';
import 'user_profile_card.dart';

class RequestScreen extends StatelessWidget {
  final RequestViewModel viewModel;

  const RequestScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    print('UserProfile ID: ${viewModel.userprofile.name}');
    return Scaffold(
        appBar: AppBar(
          title: _buildTitle(),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UserProfileCard(
            viewModel: viewModel,
          ),
          Expanded(child: NotificationBody(viewModel: viewModel))
        ]));
  }

  Widget _buildTitle() {
    var type = viewModel.notificationData.type;
    switch (type) {
      case NotificationType.knowledgeRequest:
        return Text("New request:");
      case NotificationType.requestDeclined:
        return Text("Declined request:");
      case NotificationType.requestAccepted:
        return Text("Accepted request");
      case NotificationType.meetupRequest:
        return Text("Meetup request");
      case NotificationType.meetupConfirmation:
        return Text("Meetup confirmation");
    }
  }
}
