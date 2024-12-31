import 'dart:convert';

import 'reachability.dart';

class SearchCriteria {
  final String keyword;
  final String issue;
  final Reachability? reachability;

  SearchCriteria({
    required this.keyword,
    required this.issue,
    this.reachability,
  });

  Map<String, dynamic> toJSON() {
    return {
      'keyword': keyword,
      'issue': issue,
      'reachability': reachability?.toString()
    };
  }

  @override
  String toString() {
    return jsonEncode(toJSON());
  }

  factory SearchCriteria.fromJSON(Map<String, dynamic> json) {
    return SearchCriteria(
        keyword: json['keyword'] as String,
        issue: json['issue'] as String,
        reachability: Reachability.fromString(json['reachability'] as String));
  }
  factory SearchCriteria.fromJSONString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return SearchCriteria.fromJSON(json);
  }
}
