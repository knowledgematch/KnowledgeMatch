import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:knowledgematch/data/services/api_db_connection.dart';

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
      api.addKeywordEntry(levels: 0, keyword: keyword, description: keywordDescription);
    }
  }

  String _parseKeyword(String input) {
    final pattern = RegExp(r'0-[A-Z]-[A-Z]-[A-Z]-0([a-zA-Z0-9]+)\.');
    final match = pattern.firstMatch(input);
    return match != null ? match.group(1)?.toLowerCase() ?? '' : '';
  }
}
