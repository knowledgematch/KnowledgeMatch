class AdminState {
  List<String> keywords = [];
  List<String> topics = [];
  String selectedKeyword = '';
  String selectedTopic = '';
  String? editingKeyword;
  String? editingTopic;

  AdminState({
    required this.keywords,
    required this.topics,
    required this.selectedKeyword,
    required this.selectedTopic,
    this.editingKeyword,
    this.editingTopic
  });

  AdminState copyWith({
    List<String>? keywords,
    List<String>? topics,
    String? selectedKeyword,
    String? selectedTopic,
    String? editingKeyword,
    String? editingTopic,
  }) {
    return AdminState(
      keywords: keywords ?? this.keywords,
      topics: topics ?? this.topics,
      selectedKeyword: selectedKeyword ?? this.selectedKeyword,
      selectedTopic: selectedTopic ?? this.selectedTopic,
      editingKeyword: editingKeyword,
      editingTopic: editingTopic,
    );
  }
}