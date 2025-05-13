import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/domain/models/keyword.dart';
import 'package:knowledgematch/domain/models/keyword2topic.dart';
import 'package:knowledgematch/domain/models/topic.dart';


void main() {
  group('Keyword2Topic', () {
    test('should correctly associate a keyword with a topic', () {
      final keyword = Keyword(
        id: 1,
        levels: 2,
        name: 'Flutter',
        description: 'A UI toolkit',
      );

      final topic = Topic(
        id: 10,
        levels: 2,
        name: 'Mobile Development',
        description: 'All about building mobile apps',
      );

      final association = Keyword2Topic(
        keyword: keyword,
        topic: topic,
      );

      expect(association.keyword.name, 'Flutter');
      expect(association.topic.name, 'Mobile Development');
    });
  });
}
