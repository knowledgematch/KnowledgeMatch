import 'package:flutter/material.dart';
import 'package:knowledgematch/services/api_db_connection.dart';
import 'package:knowledgematch/models/user.dart';

//TODO Keywords Entries are inserted correctly into the database but the UI isn't properly updating
class KeywordSelectionScreen extends StatefulWidget {
  const KeywordSelectionScreen({super.key});

  @override
  KeywordSelectionScreenState createState() => KeywordSelectionScreenState();
}

class KeywordSelectionScreenState extends State<KeywordSelectionScreen> {
  final ApiDbConnection _apiDbConnection = ApiDbConnection();
  late Future<List<Map<String, dynamic>>> _allKeywordsFuture;
  late Future<List<Map<String, dynamic>>> _userKeywordsFuture;
  Set<int> _selectedKeywordIds = {};

  @override
  void initState() {
    super.initState();
    _loadKeywords();
  }

  /// Loads keywords for the user and all available keywords.
  ///
  /// This method fetches all available keywords and the keywords associated with the current user.
  /// It updates the state with the user's selected keyword IDs once the user-specific keywords
  /// are successfully fetched. If an error occurs while fetching user keywords, an error is printed.
  ///
  /// Parameters:
  /// - This method does not take any parameters. It uses the current user's ID to fetch their keywords.
  ///
  /// Returns:
  /// - This method does not return a value. It updates the state with the user's selected keyword IDs.
  void _loadKeywords() {
    final userId = User.instance.id!;
    _allKeywordsFuture = _apiDbConnection.fetchKeywords();
    _userKeywordsFuture = _apiDbConnection.fetchKeywordsByUser(userId);

    _userKeywordsFuture.then((userKeywords) {
      setState(() {
        _selectedKeywordIds =
            userKeywords.map<int>((keyword) => keyword['K_ID'] as int).toSet();
      });
    }).catchError((error) {
      print('Error fetching user keywords: $error');
    });
  }

  /// Toggles the selection state of a keyword and updates the API accordingly.
  ///
  /// This method checks if the given keyword ID is already selected, updates the local selection
  /// state optimistically, and then calls the API to either add or remove the keyword for the user.
  /// If the API call fails, the local selection state is reverted, and an error message is shown.
  ///
  /// Parameters:
  /// - [keywordId]: The ID of the keyword to toggle the selection for.
  ///
  /// Returns:
  /// - This method does not return a value. It updates the selection state and shows a snack bar if
  ///   the API call fails.
  void _toggleKeywordSelection(int keywordId) async {
    final userId = User.instance.id!;
    bool isSelected = _selectedKeywordIds.contains(keywordId);

    // Optimistically update selection state
    setState(() {
      if (isSelected) {
        _selectedKeywordIds.remove(keywordId);
      } else {
        _selectedKeywordIds.add(keywordId);
      }
    });

    // Call the API based on selection
    bool success;
    if (isSelected) {
      success =
          await _apiDbConnection.removeUser2KeywordEntry(userId, keywordId);
    } else {
      success = await _apiDbConnection.addUser2KeywordEntry(userId, keywordId);
    }

    if (!success) {
      // Revert selection if API call fails
      setState(() {
        if (isSelected) {
          _selectedKeywordIds
              .add(keywordId); // Re-add if it was previously selected
        } else {
          _selectedKeywordIds
              .remove(keywordId); // Re-remove if it was previously unselected
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to update keyword selection for keyword ID: $keywordId'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Keywords'),
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
              } else if (userKeywordsSnapshot.hasData) {
                // Populate selected keywords once
                _selectedKeywordIds = userKeywordsSnapshot.data!
                    .map<int>((keyword) => keyword['K_ID'] as int)
                    .toSet();
              }

              return _buildKeywordList(allKeywordsSnapshot.data!);
            },
          );
        },
      ),
    );
  }

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
              // Ensures that the value is not null
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
