import 'package:flutter/material.dart';
import 'package:knowledgematch/data/services/api_db_connection.dart';
import 'package:knowledgematch/domain/models/keyword2topic.dart';

import '../../../domain/models/keyword.dart';
import '../../../domain/models/topic.dart';
import '../admin_state.dart';

class AdminViewModel extends ChangeNotifier {
  final TextEditingController keywordController = TextEditingController();
  final TextEditingController topicController = TextEditingController();
  final TextEditingController keywordDescController = TextEditingController();
  final TextEditingController topicDescController = TextEditingController();
  final ApiDbConnection api = ApiDbConnection();
  AdminState _state = AdminState(
      keywords: [],
      topics: [],
      keyword2topic: [],
      selectedTopic: null,
      selectedKeyword: null);

  AdminState get state => _state;

  AdminViewModel() {
    loadKeywords();
    loadTopics();
    loadKeyword2Topic();
  }

  Future<void> loadKeywords() async {
    var resKeyw = await api.fetchKeywords();
    var keywords = resKeyw
        .map<Keyword>((json) => Keyword(
            id: json['K_ID'] as int,
            levels: json['Levels'] ?? 0,
            name: json['Keyword'],
            description: json['Description']))
        .toList();

    _state = _state.copyWith(keywords: keywords);
    notifyListeners();
  }

  Future<void> loadTopics() async {
    var resTop = await api.fetchTopics();
    var topics = resTop
        .map<Topic>((json) => Topic(
            id: json['T_ID'] as int,
            levels: json['Levels'] ?? 0,
            name: json['Topic'],
            description: json['Description']))
        .toList();
    _state = _state.copyWith(topics: topics);
    notifyListeners();
  }

  Future<void> loadKeyword2Topic() async {
    var res = await api.fetchKeyword2Topic();
    var keywords = res
        .map<Keyword2Topic>((json) => Keyword2Topic(
            keyword: _state.keywords.firstWhere((k) => k.id == json['K_ID']),
            topic: _state.topics.firstWhere((t) => t.id == json['T_ID'])))
        .toList();

    _state = _state.copyWith(keyword2topic: keywords);
    notifyListeners();
  }

  Future<void> addKeyword() async {
    if (_state.editingKeyword == null) {
      api.addKeywordEntry(
          levels: 0,
          keyword: keywordController.text,
          description: keywordDescController.text);
    } else {
      int index =
          _state.keywords.indexWhere((k) => k.id == _state.editingKeyword!.id);
      var keyword = _state.keywords[index];
      bool res = await api.updateKeywordEntry(
          id: keyword.id,
          levels: keyword.levels,
          keyword: keywordController.text,
          description: keywordDescController.text);

      if (res) {
        _state.keywords[index] =
            _state.keywords[index].copyWith(name: keywordController.text);
      }
      _state = _state.copyWith(editingKeyword: null);
    }
    keywordController.clear();
    keywordDescController.clear();
    notifyListeners();
  }

  Future<void> deleteKeyword(Keyword keyword) async {
    bool res = await api.removeKeywordEntry(keyword.id);
    if (res) {
      _state.keywords.remove(keyword);
      notifyListeners();
    }
  }

  Future<void> addTopic() async {
    if (_state.editingTopic == null) {
      api.addTopicEntry(
          levels: 0,
          topic: topicController.text,
          description: topicDescController.text);
    } else {
      int index =
          _state.topics.indexWhere((t) => t.id == _state.editingTopic!.id);
      var topic = _state.topics[index];
      bool res = await api.updateTopicEntry(
          id: topic.id,
          levels: topic.levels,
          topic: topicController.text,
          description: topicDescController.text);

      if (res) {
        _state.topics[index] =
            _state.topics[index].copyWith(name: topicController.text);
      }
      _state = _state.copyWith(editingTopic: null);
    }
    topicController.clear();
    topicDescController.clear();
    notifyListeners();
  }

  Future<void> deleteTopic(Topic topic) async {
    bool res = await api.removeTopicEntry(topic.id);
    if (res) {
      _state.topics.remove(topic);
      notifyListeners();
    }
  }

  Future<void> deleteKeywordToTopic(Keyword2Topic k2t) async {
    bool res = await api.removeKeyword2TopicEntry(k2t.keyword.id, k2t.topic.id);
    if (res) {
      _state.keyword2topic.remove(k2t);
      notifyListeners();
    }
  }

  void startEditingKeyword(Keyword keyword) {
    _state = _state.copyWith(editingKeyword: keyword);
    keywordController.text = keyword.name;
    keywordDescController.text = keyword.description;
    notifyListeners();
  }

  void startEditingTopic(Topic topic) {
    _state = _state.copyWith(editingTopic: topic);
    topicController.text = topic.name;
    topicDescController.text = topic.description;
    notifyListeners();
  }

  void updateSelectedKeyword(Keyword? keyword) {
    _state = _state.copyWith(selectedKeyword: keyword);
    notifyListeners();
  }

  void updateSelectedTopic(Topic? topic) {
    _state = _state.copyWith(selectedTopic: topic);
    notifyListeners();
  }

  void mapKeywordToTopic() {
    if (_state.selectedKeyword != null && _state.selectedTopic != null) {
      api.addKeyword2TopicsEntry(
          _state.selectedKeyword!.id, _state.selectedTopic!.id);
      _state.keyword2topic.add(Keyword2Topic(keyword: _state.selectedKeyword!, topic: _state.selectedTopic!));
    }
    notifyListeners();
  }
}
