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

  /// Creates an instance of [SearchCriteria] from a JSON object.
  ///
  /// Parses the provided [json] map to initialize a [SearchCriteria] object.
  /// The JSON must include the following keys:
  /// - `keyword`: A string representing the search keyword.
  /// - `issue`: A string describing the issue being searched.
  /// - `reachability`: A string that is converted to a [Reachability] object.
  ///
  /// Parameters:
  /// - [json]: A map containing key-value pairs for initializing the [SearchCriteria].
  ///
  /// Returns a [SearchCriteria] instance populated with the data from [json].
  factory SearchCriteria.fromJSON(Map<String, dynamic> json) {
    return SearchCriteria(
        keyword: json['keyword'] as String,
        issue: json['issue'] as String,
        reachability: Reachability.fromString(json['reachability'] as String));
  }

  /// Creates an instance of [SearchCriteria] from a JSON string.
  ///
  /// Decodes the provided [jsonString] into a map and initializes a [SearchCriteria]
  /// object using the [SearchCriteria.fromJSON] factory.
  ///
  /// Parameters:
  /// - [jsonString]: A JSON-formatted string containing key-value pairs for
  ///   initializing the [SearchCriteria].
  ///
  /// Returns a [SearchCriteria] instance populated with the data from [jsonString].
  ///
  /// Throws a [FormatException] if the [jsonString] is not a valid JSON string.
  factory SearchCriteria.fromJSONString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return SearchCriteria.fromJSON(json);
  }
}
