import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/domain/models/user.dart';

void main() {
  group('User Singleton', () {
    test('initial values are null or false', () {
      final user = User.instance;
      user.reset();
      expect(user.id, isNull);
      expect(user.name, isNull);
      expect(user.isAdmin, isNull);
    });

    test('can set and get fields', () {
      final user = User.instance;
      user.name = 'Alice';
      user.surname = 'Smith';
      user.isAdmin = true;
      expect(user.name, 'Alice');
      expect(user.surname, 'Smith');
      expect(user.isAdmin, true);
    });

    test('populateFromJson assigns values correctly', () {
      final json = {
        'U_ID': 1,
        'Name': 'John',
        'Surname': 'Doe',
        'Reachability': 5,
        'Email': 'john.doe@example.com',
        'Picture': {
          'data': [137, 80, 78]
        },
        'Seniority': 2,
        'Description': 'Test user',
        'isAdmin': 1,
      };

      final user = User.instance;
      user.populateFromJson(json);
      expect(user.id, 1);
      expect(user.name, 'John');
      expect(user.picture, isNotNull);
      expect(user.isAdmin, true);
    });

    test('setPicture and getDecodedPicture work correctly', () {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final user = User.instance;
      user.setPicture(bytes);
      expect(user.getDecodedPicture(), bytes);
    });

    test('reset clears all values', () {
      final user = User.instance;
      user.reset();
      expect(user.name, isNull);
      expect(user.isAdmin, isNull);
    });
  });
}
