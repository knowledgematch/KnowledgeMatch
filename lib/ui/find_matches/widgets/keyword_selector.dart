import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => ChangeNotifierProvider.value(
                value: viewModel,
                child: const KeywordSelectionDialog(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: Text(
            viewModel.state.keyword?.name ?? "Select Keyword",
          ),
        ),
      ],
    );
  }
}

class KeywordSelectionDialog extends StatelessWidget {
  const KeywordSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FindMatchesViewModel>();
    final keyword2Topics = viewModel.state.keyword2Topics;
    final searchQuery = viewModel.searchController.text.trim().toLowerCase();
    final allTopics = viewModel.state.topics;
    final selectedTopic = viewModel.state.selectedTopic;
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
    final isSearchMatchingTopic = selectedTopic != null &&
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
      title: Text("Select a keyword"),
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
          Text("Topics:"),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: filteredTopics.map((topic) {
              return ChoiceChip(
                showCheckmark: false,
                label: Text(topic.name),
                selected: topic == selectedTopic,
                onSelected: (_) {
                  viewModel.updateSelectedTopic(topic);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text("Keywords:"),
          Wrap(
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
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => {
            Navigator.pop(context),
            viewModel.cancelKeyword(),
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
