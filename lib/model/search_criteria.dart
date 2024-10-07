class SearchCriteria {
  final String topic;
  final String timeFrame;
  final String description;
  final String? country;

  SearchCriteria({
    required this.topic,
    required this.timeFrame,
    required this.description,
    this.country,
  });
}
