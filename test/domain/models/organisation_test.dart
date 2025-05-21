import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/domain/models/organisation.dart';

void main() {
  group('Organisation', () {
    test('should create Organisation with correct properties', () {
      final org = Organisation(
        id: 1,
        organisation: 'FHNW',
        domain: 'fhnw.ch',
      );

      expect(org.id, 1);
      expect(org.organisation, 'FHNW');
      expect(org.domain, 'fhnw.ch');
    });

    test('copyWith should override specified fields', () {
      final org = Organisation(
        id: 1,
        organisation: 'FHNW Student',
        domain: 'fhnw.ch',
      );

      final updated = org.copyWith(domain: 'student.fhnw.ch');

      expect(updated.id, 1);
      expect(updated.organisation, 'FHNW Student');
      expect(updated.domain, 'student.fhnw.ch');
    });

    test('fromJson should parse a JSON map correctly', () {
      final json = {
        'id': 2,
        'organisation': 'FHNW',
        'domain': 'fhnw.ch',
      };

      final org = Organisation.fromJson(json);

      expect(org.id, 2);
      expect(org.organisation, 'FHNW');
      expect(org.domain, 'fhnw.ch');
    });

    test('toJson should convert Organisation to correct map', () {
      final org = Organisation(
        id: 3,
        organisation: 'ETH Zurich',
        domain: 'ethz.ch',
      );

      final json = org.toJson();

      expect(json, {
        'id': 3,
        'organisation': 'ETH Zurich',
        'domain': 'ethz.ch',
      });
    });
  });
}
