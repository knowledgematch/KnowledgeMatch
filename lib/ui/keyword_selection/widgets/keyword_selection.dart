import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/keyword_selection/view_model/keyword_selection_view_model.dart';
import 'package:provider/provider.dart';

class KeywordSelection extends StatelessWidget{
  const KeywordSelection({super.key});

  @override
  Widget build(BuildContext context) {
    KeywordSelectionViewModel viewModel = Provider.of<KeywordSelectionViewModel>(context);
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
              return _buildKeywordList(allKeywordsSnapshot.data!,viewModel);
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
  /// - [allKeywords]: A list of maps representing all available keywords.
  ///
  /// Returns a [Widget] displaying the keyword list.
  Widget _buildKeywordList(List<Map<String, dynamic>> allKeywords, KeywordSelectionViewModel viewModel) {
    return ListView.builder(
      itemCount: allKeywords.length,
      itemBuilder: (context, index) {
        final keyword = allKeywords[index];
        final keywordId = keyword['K_ID'] as int;
        final keywordName = keyword['Keyword'] as String;
        final isSelected = viewModel.state.selectedKeywordIds.contains(keywordId);

        return ListTile(
          title: Text(keywordName),
          trailing: Checkbox(
            value: isSelected,
            onChanged: (value) {
              if (value != null) {
                viewModel.toggleKeywordSelection(keywordId);
              }
            },
          ),
        );
      },
    );
  }

}