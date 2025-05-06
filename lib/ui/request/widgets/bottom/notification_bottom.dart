import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/notification_data.dart';
import 'package:knowledgematch/ui/request/view_model/request_view_model.dart';
import 'package:provider/provider.dart';

import 'on_accept_bottom.dart';
import 'on_declined_bottom.dart';
import 'on_meetup_confirmation_bottom.dart';
import 'on_meetup_request_bottom.dart';
import 'on_request_bottom.dart';

class NotificationBottom extends StatefulWidget {
  const NotificationBottom({super.key});

  @override
  NotificationBottomState createState() => NotificationBottomState();
}

class NotificationBottomState extends State<NotificationBottom> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestViewModel>();
    var type = viewModel.notificationData.type;
    return switch (type) {
      NotificationType.knowledgeRequest => OnRequestBottom(),
      NotificationType.requestDeclined => OnDeclinedBottom(),
      NotificationType.requestAccepted => OnAcceptBottom(),
      NotificationType.meetupRequest => OnMeetupRequestBottom(),
      NotificationType.meetupConfirmation => OnMeetupConfirmationBottom(),
    };
  }
}
