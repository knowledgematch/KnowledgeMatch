import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/keyword_selection/keyword_selection_state.dart';

import '../../../core/log.dart';
import '../../../data/services/api_db_connection.dart';
import '../../../domain/models/user.dart';

class KeywordSelectionViewModel extends ChangeNotifier {
  KeywordSelectionState _state = KeywordSelectionState(isSaving: false, selectedKeywordIds: {}, initialKeywordIds: {}, groupedKeywordsByTopic: {});
  final ApiDbConnection _apiDbConnection = ApiDbConnection();
  KeywordSelectionState get state => _state;

  KeywordSelectionViewModel() {
    loadKeywords();
  }

  /// Loads all keywords and the keywords selected by the current user.
  ///
  /// This method fetches the list of all available keywords and the list of keywords associated
  /// with the current user (based on [User.instance.id]). The user's selected keyword IDs are
  /// then updated in the local state. The initial selection is stored in [_initialKeywordIds].
  void loadKeywords() async {
    final userId = User.instance.id!;

    final allKeywords = await _apiDbConnection.fetchKeywords();
    final userKeywords = await _apiDbConnection.fetchKeywordsByUser(userId);
    final topics = await _apiDbConnection.fetchTopics();
    final keywordTopicLinks = await _apiDbConnection.fetchKeyword2Topic();

    final selectedIds = userKeywords.map<int>((k) => k['K_ID'] as int).toSet();

    final Map<int, String> topicIdToName = {
      for (final t in topics) t['T_ID'] as int: t['Topic'] as String
    };

    final Map<int, List<int>> topicToKeywordIds = {};

    for (final link in keywordTopicLinks) {
      final kid = link['K_ID'] as int;
      final tid = link['T_ID'] as int;
      topicToKeywordIds.putIfAbsent(tid, () => []).add(kid);
    }

    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final entry in topicToKeywordIds.entries) {
      final tid = entry.key;
      final topicName = topicIdToName[tid] ?? 'Other';
      final keywordIds = entry.value;
      final keywordsForTopic = allKeywords.where((k) => keywordIds.contains(k['K_ID'])).toList();

      grouped[topicName] = keywordsForTopic;
    }

    _state = _state.copyWith(
      allKeywordsFuture: Future.value(allKeywords),
      userKeywordsFuture: Future.value(userKeywords),
      selectedKeywordIds: selectedIds,
      initialKeywordIds: Set<int>.from(selectedIds),
      groupedKeywordsByTopic: grouped,
    );
    notifyListeners();
  }

  /// Toggles the selection state of a keyword locally.
  ///
  /// This method updates the local state to add or remove a keyword ID from [_selectedKeywordIds]
  /// when the user taps the corresponding checkbox. The API is not called immediately;
  /// instead, all changes will be sent when the user taps "Save".
  ///
  /// Parameter:
  /// - [keywordId]: The ID of the keyword to toggle.
  void toggleKeywordSelection(int keywordId) {
    if (state.selectedKeywordIds.contains(keywordId)) {
      state.selectedKeywordIds.remove(keywordId);
    } else {
      state.selectedKeywordIds.add(keywordId);
    }
    notifyListeners();
  }

  /// Saves keyword changes by comparing the current selections to the initial selections.
  ///
  /// This method determines which keywords have been added or removed since the keywords were loaded,
  /// and then calls [addUser2KeywordEntry] for added keywords and [removeUser2KeywordEntry] for removed keywords.
  /// All API calls are only made when the user presses the save button.
  ///
  /// Returns a [Future] that completes once all API calls have finished.
  Future<void> saveKeywordChanges(BuildContext context) async {
    _changeIsSaving(true);
    final userId = User.instance.id!;
    // Determine which keywords were added or removed.
    final addedKeywords = state.selectedKeywordIds
        .difference(state.initialKeywordIds.cast<Object?>());
    final removedKeywords = state.initialKeywordIds
        .difference(state.selectedKeywordIds.cast<Object?>());

    bool allSuccess = true;

    // Process added keywords.
    for (final kid in addedKeywords) {
      if (!await _apiDbConnection.addUser2KeywordEntry(userId, kid)) {
        allSuccess = false;
        logger.e('Failed to add keyword with ID: $kid');
      }
    }

    // Process removed keywords.
    for (final kid in removedKeywords) {
      if (!await _apiDbConnection.removeUser2KeywordEntry(userId, kid)) {
        allSuccess = false;
        logger.e('Failed to remove keyword with ID: $kid');
      }
    }
    _changeIsSaving(false);

    if (!allSuccess) {
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update keyword selection'),
          ),
        );
      }

    } else {
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Keyword selection updated successfully'),
          ),
        );
      }


      // Update the initial state to reflect the new saved selection.
      _state.copyWith(
          initialKeywordIds:
              Set<int>.from(state.selectedKeywordIds as Iterable));
    }
  }

  void _changeIsSaving(bool isSaving) {
    _state.copyWith(isSaving: isSaving);
    notifyListeners();
  }
}
