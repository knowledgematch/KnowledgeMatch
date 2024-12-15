import 'package:intl/intl.dart';

import 'reachability.dart';

class RequestDateData {
  final DateTime dateTime;
  Reachability? reachability;

  RequestDateData({required this.dateTime, this.reachability});

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
      'type': reachability.toString() // Enum to string
    };
  }

  /// Parse JSON to Create RequestDateData
  factory RequestDateData.fromJson(Map<String, dynamic> json) {
    return RequestDateData(
        dateTime: DateTime.parse(
            '${json['date']}T${json['time']}'), // Combine date and time
        reachability: Reachability.fromString(json['type']));
  }
}
