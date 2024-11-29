class SearchCriteria {
  final String keyword;
  final String timeFrame;
  final String issue;
  final int? reachability;
  final String? location;

  SearchCriteria({
    required this.keyword,
    required this.timeFrame,
    required this.issue,
    this.reachability,
    this.location,
  });
}
