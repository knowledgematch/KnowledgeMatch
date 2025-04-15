import 'package:flutter/material.dart';

import '../admin_state.dart';

class AdminViewModel extends ChangeNotifier {
  final TextEditingController keywordController = TextEditingController();
  final TextEditingController topicController = TextEditingController();
  AdminState _state = AdminState(keywords: [], topics: [],
      selectedTopic: '', selectedKeyword: '');

  AdminState get state => _state;

  void addKeyword() {
      if (_state.editingKeyword == null) {
        _state.keywords.add(keywordController.text);
      } else {
        int index = _state.keywords.indexOf(_state.editingKeyword!);
        _state.keywords[index] = keywordController.text;
        _state = _state.copyWith(editingKeyword: null);
      }
      keywordController.clear();
      notifyListeners();
  }

  void deleteKeyword(String keyword) {
      _state.keywords.remove(keyword);

  }

  void addTopic() {
      if (_state.editingTopic == null) {
        _state.topics.add(topicController.text);
      } else {
        int index = _state.topics.indexOf(_state.editingTopic!);
        _state.topics[index] = topicController.text;
        _state =_state.copyWith(editingTopic: null);
      }
      topicController.clear();
      notifyListeners();
  }

  void deleteTopic(String topic) {
      _state.topics.remove(topic);
      notifyListeners();
  }

  void startEditingKeyword(String keyword) {
      _state = _state.copyWith(editingKeyword: keyword);
      keywordController.text = keyword;
      notifyListeners();
  }

  void startEditingTopic(String topic) {
      _state = _state.copyWith(editingTopic: topic);
      topicController.text = topic;
      notifyListeners();
  }

  void mapKeywordToTopic() {
    if (_state.selectedKeyword.isNotEmpty && _state.selectedTopic.isNotEmpty) {
     //todo
    }
  }
}