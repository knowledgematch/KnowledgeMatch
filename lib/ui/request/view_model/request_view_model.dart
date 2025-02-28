import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:knowledgematch/domain/models/search_criteria.dart';

import '../../../data/services/firestore_service.dart';
import '../../../data/services/forward_to_external.dart';
import '../../../data/services/notification_service.dart';
import '../../../domain/models/notification_data.dart';
import '../../../domain/models/request_date_data.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/userprofile.dart';

class RequestViewModel extends ChangeNotifier {
  final NotificationData notificationData;
  final Userprofile userprofile;

  RequestViewModel({required this.notificationData, required this.userprofile})
      : searchCriteria = notificationData.payload['search_criteria'] == Null || //for both formats being used
                notificationData.payload['search_criteria'] is Map
            ? SearchCriteria.fromJSON(
                notificationData.payload['search_criteria'])
            : SearchCriteria.fromJSON(notificationData.payload);

  List<RequestDateData> selectedDates = [];
  List<RequestDateData> incomingDates = [];
  List<RequestDateData> newDates = [];
  SearchCriteria searchCriteria;
  RequestDateData? selectedDate;

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

  void parseIncomingDates() {
    try {
      var jsonData = notificationData.payload;

      print("JsonData: $jsonData}");
      //Extract the list of requested meetups
      if (jsonData['dates'] is Map) {
        var datesData = jsonData['dates'];
        if (datesData['meetupsRequested'] is List) {
          List<dynamic> meetups = datesData['meetupsRequested'];

          //Parse each meetup entry
          incomingDates = meetups.map((item) {
            return RequestDateData.fromJson(item);
          }).toList();
        }
      }
    } catch (e) {
      print('Error parsing JSON: $e');
    }
  }

  void confirmDate() async {
    Map<String, dynamic> combineJson = {
    "dates": selectedDate?.toJson(),
    "search_criteria": searchCriteria.toJSON(),
  };
    //Confirm the selected date
    var notification = NotificationData(
      type: NotificationType.meetupConfirmation,
      title: "Meetup Confirmation",
      body:
          "${selectedDate!.reachability} ${selectedDate!.getFormattedDate()} ${selectedDate!.getFormattedTime()}",
      payload: combineJson,
      requestID: notificationData.requestID,
      targetUserId: userprofile.id,
      sourceUserId: User.instance.id!,
    );

    await NotificationService()
        .sendMessageToDevice(notification, userprofile.tokens ?? []);

    FirestoreService().addConfirmationToFirestore(notification);

    //Close all notifications associated with the request
    FirestoreService().closeRequest(notificationData.requestID);
  }

  void proposeNewDates() async {
    final dates = RequestDateData.buildDatesMap(newDates);
    Map<String, dynamic> combineJson = {
      "dates": dates,
      "search_criteria": searchCriteria.toJSON(),
    };

    var notification = NotificationData(
      type: NotificationType.meetupRequest,
      title: "Request for New Dates",
      body: "${User.instance.name} requested new dates!",
      payload: combineJson,
      targetUserId: userprofile.id,
      sourceUserId: User.instance.id!,
    );

    //close previous request and send new notification
    FirestoreService()
        .notificationStatusUpdate(false, notificationData.documentID);
    await NotificationService()
        .sendMessageToDevice(notification, userprofile.tokens ?? []);
  }

  void closeRequestDelegate() async {
    FirestoreService().closeRequest(notificationData.requestID);
  }

  void forwardToTeamsDelegate() async {
    ForwardToExternal.openTeamsChat(userprofile.email);
  }
}
