class KeywordSelectionState {
  late Future<List<Map<String, dynamic>>>? allKeywordsFuture;
  late Future<List<Map<String, dynamic>>>? userKeywordsFuture;
  Set<int> selectedKeywordIds = {};
  Set<int> initialKeywordIds = {};
  bool isSaving = false;
  final Map<String, List<Map<String, dynamic>>> groupedKeywordsByTopic;


  KeywordSelectionState({
    required this.isSaving,
    this.allKeywordsFuture,
    this.userKeywordsFuture,
    required this.selectedKeywordIds,
    required this.initialKeywordIds,
    required this.groupedKeywordsByTopic,
  });

  KeywordSelectionState copyWith({
    bool? isSaving,
    Future<List<Map<String, dynamic>>>? allKeywordsFuture,
    Future<List<Map<String, dynamic>>>? userKeywordsFuture,
    Set<int>? selectedKeywordIds,
    Set<int>? initialKeywordIds,
    Map<String, List<Map<String, dynamic>>>? groupedKeywordsByTopic,
  }) {
    return KeywordSelectionState(
      isSaving: isSaving ?? this.isSaving,
      allKeywordsFuture: allKeywordsFuture ?? this.allKeywordsFuture,
      userKeywordsFuture: userKeywordsFuture ?? this.userKeywordsFuture,
      selectedKeywordIds: selectedKeywordIds ?? this.selectedKeywordIds,
      initialKeywordIds: initialKeywordIds ?? this.initialKeywordIds,
      groupedKeywordsByTopic: groupedKeywordsByTopic ?? this.groupedKeywordsByTopic,
    );
  }

}