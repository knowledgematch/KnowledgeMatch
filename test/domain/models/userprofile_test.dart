import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/domain/models/reachability.dart';
import 'package:knowledgematch/domain/models/userprofile.dart';

void main() {
  group('Userprofile', () {
    test('constructor splits expertise and languages', () {
      final profile = Userprofile(
        id: 1,
        name: 'Alice',
        location: 'Zurich',
        expertString: 'Dart Flutter Firebase',
        availability: 'Evenings',
        langString: 'English German',
        reachability: null,
        description: 'A Flutter dev',
        seniority: 2,
        email: 'alice@example.com',
      );

      expect(profile.expertise, ['Dart', 'Flutter', 'Firebase']);
      expect(profile.languages, ['English', 'German']);
    });

    test('getTokensList returns tokens', () {
      final profile = Userprofile(
        id: 2,
        name: 'Bob',
        location: 'Basel',
        expertString: 'Kotlin Java',
        availability: 'Weekends',
        langString: 'German',
        reachability: null,
        description: 'Android dev',
        tokens: ['abc', 'xyz'],
        seniority: 3,
        email: 'bob@example.com',
      );

      expect(profile.getTokensList(), ['abc', 'xyz']);
    });

    test('setPicture and getPicture store and retrieve image data', () {
      final profile = Userprofile(
        id: 3,
        name: 'Carol',
        location: 'Bern',
        expertString: 'Design',
        availability: 'Weekdays',
        langString: 'French',
        reachability: null,
        description: 'UI/UX expert',
        seniority: 1,
        email: 'carol@example.com',
      );

      final original = base64Encode([1, 2, 3, 4]);
      profile.setPicture(original);

      expect(profile.getPicture(), Uint8List.fromList([1, 2, 3, 4]));
    });

    test('fromJson creates a valid Userprofile', () {
      final json = {
        'U_ID': 10,
        'FullName': 'Dave',
        'Seniority': 5,
        'Keywords': 'Backend SQL',
        'Reachability': 1,
        'Description': 'Backend engineer',
        'Tokens': 'token1 token2',
        'Email': 'dave@example.com',
        'Picture': {'data': [10, 20, 30]}
      };

      final profile = Userprofile.fromJson(json);

      expect(profile.id, 10);
      expect(profile.name, 'Dave');
      expect(profile.seniority, 5);
      expect(profile.expertise, ['Backend', 'SQL']);
      expect(profile.reachability, Reachability.inPerson);
      expect(profile.description, 'Backend engineer');
      expect(profile.tokens, ['token1', 'token2']);
      expect(profile.email, 'dave@example.com');
      expect(profile.picture, Uint8List.fromList([10, 20, 30]));
    });
  });
}
