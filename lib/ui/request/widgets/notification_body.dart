import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/notification_data.dart';
import 'package:knowledgematch/ui/request/view_model/request_view_model.dart';
import 'package:provider/provider.dart';

import 'on_accept_body.dart';
import 'on_decline_body.dart';
import 'on_meetup_confirmation_body.dart';
import 'on_meetup_request_body.dart';
import 'on_request_body.dart';

class NotificationBody extends StatefulWidget {
  const NotificationBody({super.key});

  @override
  NotificationBodyState createState() => NotificationBodyState();
}

class NotificationBodyState extends State<NotificationBody> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestViewModel>();
    var type = viewModel.notificationData.type;
    return switch (type) {
      NotificationType.knowledgeRequest => OnRequestBody(),
      NotificationType.requestDeclined => OnDeclineBody(),
      NotificationType.requestAccepted => OnAcceptBody(),
      NotificationType.meetupRequest => OnMeetupRequestBody(),
      NotificationType.meetupConfirmation => OnMeetupConfirmationBody(),
    };
  }
}
