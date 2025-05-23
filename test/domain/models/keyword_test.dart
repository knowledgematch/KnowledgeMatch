import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/domain/models/keyword.dart';

void main() {
  group('Keyword', () {
    test('copyWith returns identical object if no fields are provided', () {
      final keyword = Keyword(
        id: 1,
        levels: 2,
        name: 'Flutter',
        description: 'A UI toolkit',
      );

      final copied = keyword.copyWith();

      expect(copied.id, keyword.id);
      expect(copied.levels, keyword.levels);
      expect(copied.name, keyword.name);
      expect(copied.description, keyword.description);
    });

    test('copyWith overrides individual fields correctly', () {
      final keyword = Keyword(
        id: 1,
        levels: 2,
        name: 'Flutter',
        description: 'A UI toolkit',
      );

      final updated = keyword.copyWith(name: 'Dart', levels: 3);

      expect(updated.id, 1);
      expect(updated.levels, 3);
      expect(updated.name, 'Dart');
      expect(updated.description, 'A UI toolkit');
    });
  });
}
