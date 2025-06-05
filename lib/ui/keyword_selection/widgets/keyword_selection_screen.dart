import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/keyword_selection/view_model/keyword_selection_view_model.dart';
import 'package:provider/provider.dart';

/// Screen for selecting keywords.
///
/// Displays all available keywords along with checkboxes and shows which keywords the user has selected.
/// Changes are saved only when the user taps the save button.
class KeywordSelectionScreen extends StatefulWidget {
  const KeywordSelectionScreen({super.key});

  @override
  KeywordSelectionScreenState createState() => KeywordSelectionScreenState();
}

/// State for [KeywordSelectionScreen].
class KeywordSelectionScreenState extends State<KeywordSelectionScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<KeywordSelectionViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Keywords'),
        actions: [
          IconButton(
            icon: viewModel.state.isSaving
                ? const CircularProgressIndicator(
              color: Colors.white,
            )
                : const Icon(Icons.save),
            onPressed: () => {
              if (!viewModel.state.isSaving){
                viewModel.saveKeywordChanges(context)
              }
            },
            tooltip: 'Save changes',
          )
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: viewModel.state.allKeywordsFuture,
        builder: (context, allKeywordsSnapshot) {
          if (allKeywordsSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (allKeywordsSnapshot.hasError) {
            return Center(child: Text('Error: ${allKeywordsSnapshot.error}'));
          } else if (!allKeywordsSnapshot.hasData ||
              allKeywordsSnapshot.data!.isEmpty) {
            return const Center(child: Text('No keywords found.'));
          }

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: viewModel.state.userKeywordsFuture,
            builder: (context, userKeywordsSnapshot) {
              if (userKeywordsSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (userKeywordsSnapshot.hasError) {
                return Center(
                    child: Text('Error: ${userKeywordsSnapshot.error}'));
              }
              return _buildGroupedKeywordList(viewModel.state.groupedKeywordsByTopic, viewModel);
            },
          );
        },
      ),
    );

  }
  /// Builds the list view for all keywords.
  ///
  /// This widget displays a [ListView] of keywords with a [Checkbox] next to each.
  ///
  /// Parameter:
  /// - [groupedKeywords]: A list of maps representing all available keywords mapped to their topic.
  ///
  /// Returns a [Widget] displaying the keyword list.
  Widget _buildGroupedKeywordList(Map<String, List<Map<String, dynamic>>> groupedKeywords, KeywordSelectionViewModel viewModel) {
    return ListView(
      children: groupedKeywords.entries.map((entry) {
        final topic = entry.key;
        final keywords = entry.value;

        return ExpansionTile(
          title: Text(topic),
          children: keywords.map((keyword) {
            final kid = keyword['K_ID'] as int;
            final name = keyword['Keyword'] as String;
            final isSelected = viewModel.state.selectedKeywordIds.contains(kid);

            return CheckboxListTile(
              title: Text(name),
              value: isSelected,
              onChanged: (value) {
                if (value != null) {
                  viewModel.toggleKeywordSelection(kid);
                }
              },
            );
          }).toList(),
        );
      }).toList(),
    );
  }

}
