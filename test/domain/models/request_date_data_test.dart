import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/domain/models/reachability.dart';
import 'package:knowledgematch/domain/models/request_date_data.dart';

void main() {
  group('RequestDateData', () {
    test('toJson and fromJson should be consistent', () {
      final date = RequestDateData(
        dateTime: DateTime(2025, 5, 1, 14, 45),
        reachability: Reachability.inPerson,
      );

      final json = date.toJson();
      final parsed = RequestDateData.fromJson(json);

      expect(parsed.dateTime.year, 2025);
      expect(parsed.dateTime.month, 5);
      expect(parsed.dateTime.day, 1);
      expect(parsed.dateTime.hour, 14);
      expect(parsed.dateTime.minute, 45);
      expect(parsed.reachability, Reachability.inPerson);
    });

    test('buildRequestString should encode multiple dates correctly', () {
      final dates = [
        RequestDateData(
          dateTime: DateTime(2025, 5, 1, 10, 0),
          reachability: Reachability.online,
        ),
        RequestDateData(
          dateTime: DateTime(2025, 5, 2, 11, 30),
          reachability: Reachability.inPerson,
        ),
      ];

      final jsonString = RequestDateData.buildRequestString(dates);

      expect(jsonString.contains('2025-05-01'), isTrue);
      expect(jsonString.contains('2025-05-02'), isTrue);
      expect(jsonString.contains('Online'), isTrue);
      expect(jsonString.contains('In Person'), isTrue);
    });

    test('fromConfirmationJson parses correctly', () {
      final json = {
        'dates': {
          'date': '2025-04-17',
          'time': '15:50',
          'type': 'Online',
        }
      };

      final result = RequestDateData.fromConfirmationJson(json);
      expect(result.dateTime.hour, 15);
      expect(result.dateTime.minute, 50);
      expect(result.reachability, Reachability.online);
    });
  });
}
