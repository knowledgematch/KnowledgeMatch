import '../../domain/models/reachability.dart';

class FindMatchesState {
  String? keyword;
  String? description;
  Reachability? reachability;
  late List<String> keywords = [];
  late List<Reachability> reachabilities = [];

  FindMatchesState({
    this.keyword,
    this.description,
    this.reachability,
    required this.keywords,
    required this.reachabilities,
  });

  FindMatchesState copyWith({
    String? keyword,
    String? description,
    Reachability? reachability,
    List<String>? keywords,
    List<Reachability>? reachabilities,
  }) {
    return FindMatchesState(
      keyword: keyword ?? this.keyword,
      description: description ?? this.description,
      reachability: reachability ?? this.reachability,
      keywords: keywords ?? this.keywords,
      reachabilities: reachabilities ?? this.reachabilities,
    );
  }


}