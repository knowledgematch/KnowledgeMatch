import 'package:knowledgematch/data/services/api_db_connection.dart';

import '../../core/log.dart';
import '../../domain/models/keyword.dart';
import '../../domain/models/keyword2topic.dart';
import '../../domain/models/topic.dart';

class KeywordTopicService {
  final _api = ApiDbConnection();

  Future<List<Keyword>> fetchKeywords() async {
    final res = await _api.fetchKeywords();
    return res.map<Keyword>((json) => Keyword(
      id: json['K_ID'] as int,
      levels: json['Levels'] ?? 0,
      name: json['Keyword'],
      description: json['Description'],
    )).toList();
  }

  Future<List<Keyword>> fetchUsedKeywords() async {
    final res = await _api.fetchUsedKeywords();
    logger.d(res);
    return res.map<Keyword>((json) => Keyword(
      id: json['K_ID'] as int,
      levels: json['Levels'] ?? 0,
      name: json['Keyword'],
      description: json['Description'],
    )).toList();
  }

  Future<List<Topic>> fetchTopics() async {
    final res = await _api.fetchTopics();
    return res.map<Topic>((json) => Topic(
      id: json['T_ID'] as int,
      levels: json['Levels'] ?? 0,
      name: json['Topic'],
      description: json['Description'],
    )).toList();
  }

  Future<List<Keyword2Topic>> fetchKeyword2Topic({
    required List<Keyword> keywords,
    required List<Topic> topics,
  }) async {
    final res = await _api.fetchKeyword2Topic();
    return res
        .where((json) => keywords.any((k) => k.id == json['K_ID']))
        .map<Keyword2Topic>((json) => Keyword2Topic(
              keyword: keywords.firstWhere((k) => k.id == json['K_ID']),
              topic: topics.firstWhere((t) => t.id == json['T_ID']),
            ))
        .toList();
  }
}
