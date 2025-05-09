import 'package:knowledgematch/domain/models/keyword2topic.dart';

import '../../domain/models/keyword.dart';
import '../../domain/models/reachability.dart';
import '../../domain/models/topic.dart';

class FindMatchesState {
  Keyword? keyword;
  Topic? selectedTopic;
  String? description;
  Reachability? reachability;
  late List<Keyword> keywords = [];
  late List<Topic> topics = [];
  late List<Keyword2Topic> keyword2Topics = [];
  late List<Reachability> reachabilities = [];

  FindMatchesState({
    this.keyword,
    this.selectedTopic,
    this.description,
    this.reachability,
    required this.keywords,
    required this.topics,
    required this.keyword2Topics,
    required this.reachabilities,
  });

  FindMatchesState copyWith({
    Keyword? keyword,
    Topic? selectedTopic,
    String? description,
    Reachability? reachability,
    List<Keyword>? keywords,
    List<Topic>? topics,
    List<Keyword2Topic>? keyword2Topics,
    List<Reachability>? reachabilities,
  }) {
    return FindMatchesState(
      keyword: keyword ?? this.keyword,
      selectedTopic: selectedTopic ?? this.selectedTopic,
      description: description ?? this.description,
      reachability: reachability ?? this.reachability,
      keywords: keywords ?? this.keywords,
      topics: topics ?? this.topics,
      keyword2Topics: keyword2Topics ?? this.keyword2Topics,
      reachabilities: reachabilities ?? this.reachabilities,
    );
  }
  FindMatchesState cancelKeyword(){
    return FindMatchesState(
        keyword: null,
        keywords: keywords,
        topics: topics,
        keyword2Topics: keyword2Topics,
        reachabilities: reachabilities);
  }


}