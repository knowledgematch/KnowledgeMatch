import 'package:flutter/foundation.dart';
import 'package:knowledgematch/domain/models/search_criteria.dart';

import '../../../data/services/firestore_service.dart';
import '../../../data/services/notification_service.dart';
import '../../../domain/models/notification_data.dart';
import '../../../domain/models/request_date_data.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/userprofile.dart';

class RequestViewModel extends ChangeNotifier {
  final NotificationData notificationData;
  final Userprofile userprofile;
  final SearchCriteria searchCriteria;

  RequestViewModel({required this.notificationData, required this.userprofile})
      : searchCriteria = SearchCriteria.fromJSON(notificationData.payload);

  List<RequestDateData> selectedDates = [];

  void acceptRequest() async {
    var notification = NotificationData(
        type: NotificationType.requestAccepted,
        title: "Accepted request",
        body:
            "Your request has been accepted by ${User.instance.name} ${User.instance.surname}",
        payload: searchCriteria.toJSON(),
        targetUserId: userprofile.id,
        sourceUserId: User.instance.id!,
        requestID: notificationData.requestID);
    FirestoreService()
        .notificationStatusUpdate(false, notificationData.documentID);
    await NotificationService()
        .sendMessageToDevice(notification, userprofile.tokens ?? []);
  }

  void declineRequest() async {
    var notification = NotificationData(
      type: NotificationType.requestDeclined,
      title: "Declined request",
      body:
          "Your request was declined by ${User.instance.name} ${User.instance.surname}",
      payload: searchCriteria.toJSON(),
      targetUserId: notificationData.sourceUserId,
      sourceUserId: userprofile.id,
      requestID: notificationData.requestID,
    );
    await NotificationService()
        .sendMessageToDevice(notification, userprofile.tokens ?? []);
    FirestoreService().closeRequest(notificationData.requestID);
  }

  void proposeSelectedDates() async {
    var dates = RequestDateData.buildDatesMap(selectedDates);
    Map<String, dynamic> combineJson = {
      "dates": dates,
      "search_criteria": searchCriteria.toJSON(),
    };

    var notification = NotificationData(
      type: NotificationType.meetupRequest,
      title: "Meetup has been requested",
      body: "${User.instance.name} suggests meetup dates!",
      payload: combineJson,
      requestID: notificationData.requestID,
      targetUserId: userprofile.id,
      sourceUserId: User.instance.id!,
    );

    //Update Status of the previous request
    FirestoreService()
        .notificationStatusUpdate(false, notificationData.documentID);

    await NotificationService()
        .sendMessageToDevice(notification, userprofile.tokens ?? []);
  }
}
