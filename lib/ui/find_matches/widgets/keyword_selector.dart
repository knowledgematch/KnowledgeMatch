import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/topic.dart';
import '../../find_matches/view_model/find_matches_view_model.dart';

class KeywordSelector extends StatefulWidget {
  const KeywordSelector({super.key});

  @override
  State<KeywordSelector> createState() => _KeywordSelectorState();
}

class _KeywordSelectorState extends State<KeywordSelector> {

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FindMatchesViewModel>();
    final keyword2Topics = viewModel.state.keyword2Topics;

    final searchQuery = viewModel.searchController.text.trim().toLowerCase();

    final allTopics = viewModel.state.topics;

    final keywordMatches = keyword2Topics
        .where((e) =>
            e.keyword.name.toLowerCase().contains(searchQuery) ||
            e.keyword.description.toLowerCase().contains(searchQuery))
        .toList();

    final keywordMatchTopics = keywordMatches.map((e) => e.topic).toSet();

    final filteredTopics = allTopics.where((topic) {
      final topicMatch = topic.name.toLowerCase().contains(searchQuery);
      final keywordMatch = keywordMatchTopics.contains(topic);
      return topicMatch || keywordMatch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select a Topic:"),
        const SizedBox(height: 8),
        TextField(
          controller: viewModel.searchController,
          decoration: const InputDecoration(
            labelText: 'Search topics or keywords...',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => viewModel.notify(),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: filteredTopics.map((topic) {
            return ChoiceChip(
              showCheckmark: false,
              label: Text(topic.name),
              selected: false,
              onSelected: (_) {
                showDialog(
                  context: context,
                  builder: (_) => ChangeNotifierProvider.value(
                    value: viewModel,
                    child: KeywordSelectionDialog(selectedTopic: topic),
                  ),
                );
              },
            );
          }).toList(),
        ),
        if (viewModel.state.keyword != null) ...[
          Text("Selected Keyword:"),
          ChoiceChip(
              showCheckmark: false,
              label: Text(viewModel.state.keyword!.name),
              selected: true
          )
        ]
      ],
    );
  }
}

class KeywordSelectionDialog extends StatelessWidget {
  final Topic selectedTopic;

  const KeywordSelectionDialog(
      {super.key, required this.selectedTopic});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FindMatchesViewModel>();
    final keyword2Topics = viewModel.state.keyword2Topics;
    final searchQuery = viewModel.searchController.text.trim().toLowerCase();

    final isSearchMatchingTopic =
        selectedTopic.name.toLowerCase().contains(searchQuery);

    final showAllKeywords = searchQuery.isEmpty || isSearchMatchingTopic;

    final keywordsInTopic = keyword2Topics
        .where((e) => e.topic == selectedTopic)
        .map((e) => e.keyword)
        .toSet()
        .toList();

    final filteredKeywords = showAllKeywords
        ? keywordsInTopic
        : keywordsInTopic
            .where((kw) =>
                kw.name.toLowerCase().contains(searchQuery) ||
                kw.description.toLowerCase().contains(searchQuery))
            .toList();

    return AlertDialog(
      title: Text("Select a keyword for '${selectedTopic.name}'"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: viewModel.searchController,
            decoration: const InputDecoration(
              labelText: 'Search keywords...',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => viewModel.notify(),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: filteredKeywords.map((keyword) {
                return ChoiceChip(
                  showCheckmark: false,
                  label: Text(keyword.name),
                  selected: viewModel.state.keyword == keyword,
                  onSelected: (_) {
                    viewModel.updateKeyword(keyword);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
