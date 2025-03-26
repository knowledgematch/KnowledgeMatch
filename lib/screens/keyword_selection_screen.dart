import 'package:flutter/material.dart';
import 'package:knowledgematch/services/api_db_connection.dart';
import 'package:knowledgematch/models/user.dart';
import 'package:knowledgematch/theme/colors.dart';

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
  final ApiDbConnection _apiDbConnection = ApiDbConnection();
  late Future<List<Map<String, dynamic>>> _allKeywordsFuture;
  late Future<List<Map<String, dynamic>>> _userKeywordsFuture;
  Set<int> _selectedKeywordIds = {};
  Set<int> _initialKeywordIds = {};
  bool _isSaving = false; // Indicates if a save operation is in progress.

  @override
  void initState() {
    super.initState();
    _loadKeywords();
  }

  /// Loads all keywords and the keywords selected by the current user.
  ///
  /// This method fetches the list of all available keywords and the list of keywords associated
  /// with the current user (based on [User.instance.id]). The user's selected keyword IDs are
  /// then updated in the local state. The initial selection is stored in [_initialKeywordIds].
  void _loadKeywords() {
    final userId = User.instance.id!;
    _allKeywordsFuture = _apiDbConnection.fetchKeywords();
    _userKeywordsFuture = _apiDbConnection.fetchKeywordsByUser(userId);

    _userKeywordsFuture.then((userKeywords) {
      setState(() {
        _selectedKeywordIds =
            userKeywords.map<int>((keyword) => keyword['K_ID'] as int).toSet();
        // Save initial selection for later comparison.
        _initialKeywordIds = Set<int>.from(_selectedKeywordIds);
      });
    }).catchError((error) {
      print('Error fetching user keywords: $error');
    });
  }

  /// Toggles the selection state of a keyword locally.
  ///
  /// This method updates the local state to add or remove a keyword ID from [_selectedKeywordIds]
  /// when the user taps the corresponding checkbox. The API is not called immediately;
  /// instead, all changes will be sent when the user taps "Save".
  ///
  /// Parameter:
  /// - [keywordId]: The ID of the keyword to toggle.
  void _toggleKeywordSelection(int keywordId) {
    setState(() {
      if (_selectedKeywordIds.contains(keywordId)) {
        _selectedKeywordIds.remove(keywordId);
      } else {
        _selectedKeywordIds.add(keywordId);
      }
    });
  }

  /// Saves keyword changes by comparing the current selections to the initial selections.
  ///
  /// This method determines which keywords have been added or removed since the keywords were loaded,
  /// and then calls [addUser2KeywordEntry] for added keywords and [removeUser2KeywordEntry] for removed keywords.
  /// All API calls are only made when the user presses the save button.
  ///
  /// Returns a [Future] that completes once all API calls have finished.
  Future<void> _saveKeywordChanges() async {
    setState(() {
      _isSaving = true;
    });

    final userId = User.instance.id!;
    // Determine which keywords were added or removed.
    final addedKeywords = _selectedKeywordIds.difference(_initialKeywordIds);
    final removedKeywords = _initialKeywordIds.difference(_selectedKeywordIds);

    bool allSuccess = true;

    // Process added keywords.
    for (final kid in addedKeywords) {
      if (!await _apiDbConnection.addUser2KeywordEntry(userId, kid)) {
        allSuccess = false;
        print('Failed to add keyword with ID: $kid');
      }
    }

    // Process removed keywords.
    for (final kid in removedKeywords) {
      if (!await _apiDbConnection.removeUser2KeywordEntry(userId, kid)) {
        allSuccess = false;
        print('Failed to remove keyword with ID: $kid');
      }
    }

    setState(() {
      _isSaving = false;
    });

    //TODO Fix User Feedback
    // Provide user feedback.
    if (!allSuccess) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update keyword selection'),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Keyword selection updated successfully'),
          ),
        );
      }
      // Update the initial state to reflect the new saved selection.
      _initialKeywordIds = Set<int>.from(_selectedKeywordIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Keywords'),
        actions: [
          IconButton(
            icon: _isSaving
                ? const CircularProgressIndicator(
                    color: AppColors.whiteLight,
                  )
                : const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveKeywordChanges,
            tooltip: 'Save changes',
          )
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _allKeywordsFuture,
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
            future: _userKeywordsFuture,
            builder: (context, userKeywordsSnapshot) {
              if (userKeywordsSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (userKeywordsSnapshot.hasError) {
                return Center(
                    child: Text('Error: ${userKeywordsSnapshot.error}'));
              }
              // The initial selection has been set in _loadKeywords().

              return _buildKeywordList(allKeywordsSnapshot.data!);
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
  Widget _buildKeywordList(List<Map<String, dynamic>> allKeywords) {
    return ListView.builder(
      itemCount: allKeywords.length,
      itemBuilder: (context, index) {
        final keyword = allKeywords[index];
        final keywordId = keyword['K_ID'] as int;
        final keywordName = keyword['Keyword'] as String;
        final isSelected = _selectedKeywordIds.contains(keywordId);

        return ListTile(
          title: Text(keywordName),
          trailing: Checkbox(
            value: isSelected,
            onChanged: (value) {
              if (value != null) {
                _toggleKeywordSelection(keywordId);
              }
            },
          ),
        );
      },
    );
  }
}
