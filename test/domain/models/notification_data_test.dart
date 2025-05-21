import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/domain/models/notification_data.dart';

void main() {
  group('NotificationData', () {
    test('fromFirestoreData parses correctly', () {
      final data = {
        'notification_type': 'requestAccepted',
        'title': 'Accepted',
        'body': 'Your request was accepted',
        'payload': {'foo': 'bar'},
        'target_user_id': '123',
        'source_user_id': '456',
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'request_id': 'req123',
        'is_open': 'true'
      };

      final notification = NotificationData.fromFirestoreData(jsonMap: data);
      expect(notification.type, NotificationType.requestAccepted);
      expect(notification.title, 'Accepted');
      expect(notification.payload, {'foo': 'bar'});
    });

    test('toJson returns valid map', () {
      final notification = NotificationData(
        type: NotificationType.knowledgeRequest,
        title: 'Test',
        body: 'Body',
        payload: {'key': 'value'},
        targetUserId: 1,
        sourceUserId: 2,
        timestamp: DateTime.utc(2024),
        requestID: 'req',
        isOpen: true,
        documentID: 'doc1',
      );

      final json = notification.toJson();
      expect(json['title'], 'Test');
      expect(json['notification_type'], 'knowledgeRequest');
    });

    test('equality based on documentID', () {
      final a = NotificationData(
        type: NotificationType.meetupRequest,
        title: '',
        body: '',
        payload: {},
        targetUserId: 1,
        sourceUserId: 2,
        documentID: 'abc',
      );
      final b = NotificationData(
        type: NotificationType.meetupConfirmation,
        title: '',
        body: '',
        payload: {},
        targetUserId: 1,
        sourceUserId: 2,
        documentID: 'abc',
      );
      expect(a == b, true);
      expect(a.hashCode, b.hashCode);
    });
  });
}
