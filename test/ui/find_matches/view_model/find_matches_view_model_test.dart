import 'package:flutter_test/flutter_test.dart';
import 'package:knowledgematch/ui/find_matches/view_model/find_matches_view_model.dart';
import 'package:knowledgematch/domain/models/keyword.dart';
import 'package:knowledgematch/domain/models/topic.dart';
import 'package:knowledgematch/domain/models/reachability.dart';

void main() {
  late FindMatchesViewModel viewModel;

  setUp(() {
    viewModel = FindMatchesViewModel();
  });

  test('initial state is correct', () {
    expect(viewModel.state.keywords, isEmpty);
    expect(viewModel.state.topics, isEmpty);
    expect(viewModel.state.keyword2Topics, isEmpty);
    expect(viewModel.state.reachabilities, isEmpty);
  });

  test('updateKeyword updates state', () {
    final keyword = Keyword(id: 1, levels: 0 ,name: 'AI', description: 'Artificial Intelligence');
    viewModel.updateKeyword(keyword);
    expect(viewModel.state.keyword, equals(keyword));
  });

  test('updateSelectedTopic updates state', () {
    final topic = Topic(id: 1, levels: 0 , name: 'Science', description: 'Science');
    viewModel.updateSelectedTopic(topic);
    expect(viewModel.state.selectedTopic, equals(topic));
  });

  test('updateDescription updates state', () {
    const description = 'Interested in quantum computing.';
    viewModel.updateDescription(description);
    expect(viewModel.state.description, equals(description));
  });

  test('updateReachability updates state', () {
    viewModel.updateReachability(Reachability.online);
    expect(viewModel.state.reachability, equals(Reachability.online));
  });

  test('cancelKeyword clears selected keyword', () {
    final keyword = Keyword(id: 1, levels: 0 , name: 'Science', description: 'Science');
    viewModel.updateKeyword(keyword);
    viewModel.cancelKeyword();
    expect(viewModel.state.keyword, isNull);
  });
}
