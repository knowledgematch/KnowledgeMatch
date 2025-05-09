import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/notification_data.dart';
import 'package:provider/provider.dart';

import '../view_model/request_view_model.dart';
import 'body/notification_body.dart';
import 'bottom/notification_bottom.dart';
import 'widget/user_profile_card.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  RequestScreenState createState() => RequestScreenState();
}

class RequestScreenState extends State<RequestScreen> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestViewModel>();
    print('UserProfile ID: ${viewModel.userprofile.name}');
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: _buildTitle(viewModel),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserProfileCard(viewModel: viewModel),
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true, // always show the thumb
                  thickness: 6, // makes the thumb a bit more obvious
                  radius: Radius.circular(3),
                  child: ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    children: [NotificationBody()],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(child: NotificationBottom()),
      ),
    );
  }

  Widget _buildTitle(RequestViewModel viewModel) {
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
