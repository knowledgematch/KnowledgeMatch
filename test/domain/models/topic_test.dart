import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/domain/models/topic.dart';

void main() {
  group('Topic', () {
    test('constructor assigns all values correctly', () {
      final topic = Topic(
        id: 1,
        levels: 3,
        name: 'infsec',
        description: 'information security',
      );

      expect(topic.id, 1);
      expect(topic.levels, 3);
      expect(topic.name, 'infsec');
      expect(topic.description, 'information security');
    });

    test('copyWith changes specified values only', () {
      final original = Topic(
        id: 1,
        levels: 3,
        name: 'infsec',
        description: 'information security',
      );

      final modified = original.copyWith(
        levels: 4,
        name: 'Cryptography',
      );

      expect(modified.id, 1);
      expect(modified.levels, 4);
      expect(modified.name, 'Cryptography');
      expect(modified.description, 'information security');
    });

    test('copyWith with no arguments returns identical values', () {
      final original = Topic(
        id: 1,
        levels: 2,
        name: 'AI',
        description: 'Artificial Intelligence',
      );

      final copy = original.copyWith();

      expect(copy.id, original.id);
      expect(copy.levels, original.levels);
      expect(copy.name, original.name);
      expect(copy.description, original.description);
    });
  });
}
