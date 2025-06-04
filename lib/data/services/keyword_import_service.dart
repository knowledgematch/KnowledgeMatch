import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:knowledgematch/data/services/api_db_connection.dart';
import 'package:knowledgematch/data/services/keyword_topic_service.dart';

import '../../core/log.dart';

class KeywordImportService {
  var api = ApiDbConnection();
  Future<void> importFromExcel() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    if (result == null || result.files.isEmpty) return;
    final filePath = result.files.first.path;
    if (filePath == null) return;

    final bytes = await File(filePath).readAsBytes();
    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.tables.values.first;

    for (final row in sheet.rows.skip(1)) {
      final keywordRaw = row[0]?.value?.toString().trim();
      final keywordDescription = row[1]?.value?.toString().trim();

      if (keywordRaw == null ||
          keywordRaw.isEmpty ||
          keywordDescription == null ||
          keywordDescription.isEmpty) {
        continue;
      }

      final keyword = _parseKeyword(keywordRaw);
      if (keyword.isEmpty) continue;
      await api.addKeywordEntry(levels: 0, keyword: keyword, description: keywordDescription);
      logger.d("added Keyword: $keyword  |  $keywordDescription");
    }
    var keywords = await KeywordTopicService().fetchKeywords();
    var topics = await KeywordTopicService().fetchTopics();
    for (final row in sheet.rows.skip(1)){
      final keywordRaw = row[0]?.value?.toString().trim();
      final topicRaw = row[2]?.value?.toString().trim();
      logger.d("Topic: $topicRaw");
      if (topicRaw == null ||
          topicRaw.isEmpty ||
          keywordRaw == null ||
          keywordRaw.isEmpty) {
        continue;
      }
      final keywordString = _parseKeyword(keywordRaw);

      final keyword = keywords
          .where((k) => k.name.trim().toLowerCase() == keywordString.toLowerCase())
          .firstOrNull;

      final topic = topics
          .where((t) => t.name.trim().toLowerCase() == topicRaw.toLowerCase())
          .firstOrNull;
      if (keyword == null || topic == null) {
        logger.d("Empty keyword or topic");
        continue;
      }
      logger.d("Keyword: ${keyword.name} Topic: ${topic.name}");
      final keywordId = keyword.id;
      final topicId = topic.id;
      await api.addKeyword2TopicsEntry(keywordId, topicId);
      logger.d("mapped keyword $keywordId to topic $topicId");


    }
  }

  String _parseKeyword(String input) {
    final pattern = RegExp(r'0-[A-Z]-[A-Z]-[A-Z]-0([a-zA-Z0-9]+)\.');
    final match = pattern.firstMatch(input);
    return match != null ? match.group(1)?.toLowerCase() ?? '' : '';
  }
}
