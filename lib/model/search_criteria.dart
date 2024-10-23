class SearchCriteria {
  final String topic;
  final String timeFrame;
  final String description;
  final int? reachability;
  final String? location;

  SearchCriteria({
    required this.topic,
    required this.timeFrame,
    required this.description,
    this.reachability,
    this.location,
  });
}
