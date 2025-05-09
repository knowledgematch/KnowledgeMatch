import 'package:flutter/material.dart';
import 'package:knowledgematch/data/services/api_db_connection.dart';
import 'package:knowledgematch/data/services/keyword_topic_service.dart';
import 'package:knowledgematch/domain/models/keyword2topic.dart';

import '../../../domain/models/keyword.dart';
import '../../../domain/models/organisation.dart';
import '../../../domain/models/topic.dart';
import '../admin_state.dart';

class AdminViewModel extends ChangeNotifier {
  final TextEditingController keywordController = TextEditingController();
  final TextEditingController topicController = TextEditingController();
  final TextEditingController keywordDescController = TextEditingController();
  final TextEditingController topicDescController = TextEditingController();
  final TextEditingController organisationController = TextEditingController();
  final TextEditingController domainController = TextEditingController();
  final api = ApiDbConnection();
  final keywordTopicService = KeywordTopicService();
  AdminState _state = AdminState(
      keywords: [],
      topics: [],
      keyword2topic: [],
      organisations: [],
      selectedTopic: null,
      selectedKeyword: null,
      selectedOrganisation: null);

  AdminState get state => _state;

  AdminViewModel() {
    loadKeywords();
    loadTopics();
    loadKeyword2Topic();
    loadOrganisations();
  }

  Future<void> loadKeywords() async {
    var keywords = await keywordTopicService.fetchKeywords();
    _state = _state.copyWith(keywords: keywords);
    notifyListeners();
  }

  Future<void> loadTopics() async {
    var topics = await keywordTopicService.fetchTopics();
    _state = _state.copyWith(topics: topics);
    notifyListeners();
  }

  Future<void> loadKeyword2Topic() async {
    var keyword2topics = await keywordTopicService.fetchKeyword2Topic(
        keywords: _state.keywords, topics: _state.topics);

    _state = _state.copyWith(keyword2topic: keyword2topics);
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

  Future<void> mapKeywordToTopic() async {
    if (_state.selectedKeyword != null && _state.selectedTopic != null) {
      bool res = await api.addKeyword2TopicsEntry(
          _state.selectedKeyword!.id, _state.selectedTopic!.id);
      if (res) {
        _state.keyword2topic.add(Keyword2Topic(
            keyword: _state.selectedKeyword!, topic: _state.selectedTopic!));
      }
    }
    notifyListeners();
  }

  Future<void> loadOrganisations() async {
    var resOrgs = await api.getAllOrganisations();
    _state = _state.copyWith(organisations: resOrgs);

    notifyListeners();
  }

  Future<void> addOrganisation() async {
    if (_state.editingOrganisation == null) {
      await api.createOrganisation(
        organisation: organisationController.text,
        domain: domainController.text,
      );
    } else {
      int index = _state.organisations
          .indexWhere((o) => o.id == _state.editingOrganisation!.id);
      var org = _state.organisations[index];
      bool res = await api.updateOrganisation(
        id: org.id,
        organisation: organisationController.text,
        domain: domainController.text,
      );

      if (res) {
        _state.organisations[index] = _state.organisations[index].copyWith(
          organisation: organisationController.text,
          domain: domainController.text,
        );
      }
      _state = _state.copyWith(editingOrganisation: null);
    }

    organisationController.clear();
    domainController.clear();
    notifyListeners();
  }

  Future<void> deleteOrganisation(Organisation org) async {
    bool res = await api.deleteOrganisation(org.id);
    if (res) {
      _state.organisations.remove(org);
      notifyListeners();
    }
  }

  void startEditingOrganisation(Organisation org) {
    _state = _state.copyWith(editingOrganisation: org);
    organisationController.text = org.organisation;
    domainController.text = org.domain;
    notifyListeners();
  }
}
