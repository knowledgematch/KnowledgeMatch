import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/notification_data.dart';
import 'package:knowledgematch/ui/request/view_model/request_view_model.dart';

import 'on_accept_body.dart';
import 'on_decline_body.dart';
import 'on_meetup_confirmation_body.dart';
import 'on_meetup_request_body.dart';
import 'on_request_body.dart';

class NotificationBody extends StatefulWidget {
  final RequestViewModel viewModel;

  const NotificationBody({super.key, required this.viewModel});

  @override
  NotificationBodyState createState() => NotificationBodyState();
}

class NotificationBodyState extends State<NotificationBody> {
  // List<RequestDateData> selectedDates = [];
  @override
  Widget build(BuildContext context) {
    var type = widget.viewModel.notificationData.type;
    return switch (type) {
      NotificationType.knowledgeRequest =>
        OnRequestBody(viewModel: widget.viewModel),
      NotificationType.requestDeclined =>
        OnDeclineBody(viewModel: widget.viewModel),
      NotificationType.requestAccepted =>
        OnAcceptBody(viewModel: widget.viewModel),
      NotificationType.meetupRequest =>
        OnMeetupRequestBody(viewModel: widget.viewModel),
      NotificationType.meetupConfirmation =>
        OnMeetupConfirmationBody(viewModel: widget.viewModel),
    };
  }
}
