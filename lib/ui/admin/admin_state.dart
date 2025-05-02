import 'package:knowledgematch/domain/models/keyword2topic.dart';

import '../../domain/models/keyword.dart';
import '../../domain/models/topic.dart';

class AdminState {
  List<Keyword> keywords;
  List<Topic> topics;
  List<Keyword2Topic> keyword2topic;
  Keyword? editingKeyword;
  Topic? editingTopic;
  Keyword? selectedKeyword;
  Topic? selectedTopic;

  AdminState({
    required this.keywords,
    required this.topics,
    required this.keyword2topic,
    this.editingKeyword,
    this.editingTopic,
    this.selectedKeyword,
    this.selectedTopic,
  });

  AdminState copyWith({
    List<Keyword>? keywords,
    List<Topic>? topics,
    List<Keyword2Topic>? keyword2topic,
    Keyword? editingKeyword,
    Topic? editingTopic,
    Keyword? selectedKeyword,
    Topic? selectedTopic,
  }) {
    return AdminState(
      keywords: keywords ?? this.keywords,
      topics: topics ?? this.topics,
      keyword2topic: keyword2topic ?? this.keyword2topic,
      editingKeyword: editingKeyword,
      editingTopic: editingTopic,
      selectedKeyword: selectedKeyword ?? this.selectedKeyword,
      selectedTopic: selectedTopic ?? this.selectedTopic,
    );
  }
}