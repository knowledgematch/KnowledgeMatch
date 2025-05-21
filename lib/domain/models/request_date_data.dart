import 'dart:convert';

import 'package:intl/intl.dart';

import 'reachability.dart';

class RequestDateData {
  final DateTime dateTime;
  Reachability? reachability;

  RequestDateData({required this.dateTime, this.reachability});

  /// Returns a formatted date: "DD/MM/YYYY"
  String getFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  /// Returns a formatted time: "HH:MM"
  String getFormattedTime() {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Creates a JSON style map from a [RequestDateData] object
  ///
  /// returns a [Map]
  Map<String, dynamic> toJson() {
    return {
      'date':
          '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
      'time':
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
      'type': reachability.toString(), // Enum to string
    };
  }

  /// Parse JSON to Create [RequestDateData]
  /// Expects a json object with `date`, `time`, and `type` fields:
  /// ```json
  /// {
  ///     "date": "2025-04-17",
  ///     "time": "15:50",
  ///     "type": "In Person"
  ///   },
  ///   // other fields...
  /// }
  /// ```
  /// if "type" is empty [Reachability] falls back to [Reachability.onlineOrInPerson]
  factory RequestDateData.fromJson(Map<String, dynamic> json) {
    return RequestDateData(
      dateTime: DateTime.parse(
        '${json['date']}T${json['time']}',
      ), // Combine date and time
      reachability:
          json['type'] == null || json['type'] == 'null'
              ? Reachability.onlineOrInPerson
              : Reachability.fromString(json['type']),
    );
  }

  /// Parse JSON to Create [RequestDateData]
  /// Expects a nested `dates` object with `date`, `time`, and `type` fields:
  /// ```json
  /// {
  ///   "dates": {
  ///     "date": "2025-04-17",
  ///     "time": "15:50",
  ///     "type": "In Person"
  ///   },
  ///   // other fields...
  /// }
  /// ```
  /// if "type" is empty [Reachability] falls back to [Reachability.onlineOrInPerson]
  factory RequestDateData.fromConfirmationJson(Map<String, dynamic> json) {
    final Map<String, dynamic> dates = json['dates'] as Map<String, dynamic>;
    return RequestDateData(
      dateTime: DateTime.parse(
        '${dates['date']}T${dates['time']}',
      ), // Combine date and time
      reachability:
          dates['type'] == null || dates['type'] == 'null'
              ? Reachability.onlineOrInPerson
              : Reachability.fromString(dates['type']),
    );
  }

  /// Helper Method to create a String from [selectedDates]
  ///
  /// Takes a [List] of RequestDateData
  /// returns a json encoded [String]
  static String buildRequestString(List<RequestDateData> selectedDates) {
    // Create a JSON-compatible list of maps
    List<Map<String, dynamic>> meetups =
        selectedDates.map((item) => item.toJson()).toList();

    // Create the final JSON object
    Map<String, dynamic> jsonObject = {'meetupsRequested': meetups};

    // Convert to JSON string
    return jsonEncode(jsonObject);
  }

  ///Helper Method to create a JSON map from a [List] of dates
  ///
  static Map<String, dynamic> buildDatesMap(
    List<RequestDateData> selectedDates,
  ) {
    List<Map<String, dynamic>> meetups =
        selectedDates.map((item) => item.toJson()).toList();

    // Create the final JSON object
    Map<String, dynamic> jsonObject = {'meetupsRequested': meetups};

    // Convert to JSON string
    return jsonObject;
  }
}
