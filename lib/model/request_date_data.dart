import 'package:intl/intl.dart';

enum MeetingType {
  online,
  inPerson,
  onlineOrInPerson;

  factory MeetingType.fromString(String type) {
    switch (type) {
      case 'In Person':
        return inPerson;
      case 'Online':
        return online;
      default:
        throw ArgumentError('Invalid NotificationType: $type');
    }
  }
  @override
  String toString() {
    switch (this) {
      case MeetingType.online:
        return 'Online';
      case MeetingType.inPerson:
        return 'In Person';
      case MeetingType.onlineOrInPerson:
        return 'Online/In Person';
    }
  }
}

class RequestDateData {
  final DateTime dateTime;
  MeetingType? meetingType;

  RequestDateData({required this.dateTime});

  /// Returns a formatted date: "DD MM YYYY"
  String getFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  /// Returns a formatted time: "HH MM"
  String getFormattedTime() {
    return DateFormat('HH:mm').format(dateTime);
  }
}
