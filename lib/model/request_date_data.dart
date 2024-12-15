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
      case 'Online/In Person':
        return onlineOrInPerson;
      default:
        return onlineOrInPerson;
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

  RequestDateData({required this.dateTime, this.meetingType});

  /// Returns a formatted date: "DD MM YYYY"
  String getFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  /// Returns a formatted time: "HH MM"
  String getFormattedTime() {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Creates a JSON style Map to send as part of the notificaiton body
  Map<String, dynamic> toJson() {
    return {
      'date':
          '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
      'time':
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
      'type': meetingType.toString() // Enum to string
    };
  }

  /// Parse JSON to Create RequestDateData
  factory RequestDateData.fromJson(Map<String, dynamic> json) {
    return RequestDateData(
        dateTime: DateTime.parse(
            '${json['date']}T${json['time']}'), // Combine date and time
        meetingType: MeetingType.fromString(json['type']));
  }
}
