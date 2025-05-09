import 'package:flutter/cupertino.dart';
import 'package:knowledgematch/data/services/keyword_topic_service.dart';
import 'package:knowledgematch/ui/find_matches/find_matches_state.dart';

import '../../../data/services/matching_algorithm.dart';
import '../../../domain/models/keyword.dart';
import '../../../domain/models/reachability.dart';
import '../../../domain/models/topic.dart';

class FindMatchesViewModel extends ChangeNotifier {
  FindMatchesState _state = FindMatchesState(keywords: [], reachabilities: [],
      topics: [], keyword2Topics: []);
  final keywordTopicService = KeywordTopicService();
  final TextEditingController searchController = TextEditingController();

  static const List<Map<String, dynamic>> choices = [
    {
      "text": "In Person",
      "value": Reachability.inPerson,
    },
    {
      "text": "Online",
      "value": Reachability.online,
    },
    {
      "text": "In Person / Online",
      "value": Reachability.onlineOrInPerson,
    },
  ];

  FindMatchesViewModel() {
    loadData();
  }

  FindMatchesState get state => _state;

  void notify(){
    notifyListeners();
  }
  void updateKeyword(Keyword? newKeyword) {
    _state = _state.copyWith(keyword: newKeyword);
    notifyListeners();
  }

  void updateSelectedTopic(Topic? selectedTopic) {
    _state = _state.copyWith(selectedTopic: selectedTopic);
    notifyListeners();
  }

  void updateDescription(String? newDescription) {
    _state = _state.copyWith(description: newDescription);
    notifyListeners();
  }

  void updateReachability(Reachability? newReachability) {
    _state = _state.copyWith(reachability: newReachability);
    notifyListeners();
  }

  Future<void> loadData() async {
    var keywords = await keywordTopicService.fetchKeywords();
    var topics = await keywordTopicService.fetchTopics();
    _state = _state.copyWith(
        keywords: keywords,
        topics: topics,
        keyword2Topics: await keywordTopicService.fetchKeyword2Topic(keywords: keywords, topics: topics),
        reachabilities: await MatchingAlgorithm().getReachabilities());
    notifyListeners();
  }

  void cancelKeyword() {
    _state = _state.cancelKeyword();
    notifyListeners();
  }
}
