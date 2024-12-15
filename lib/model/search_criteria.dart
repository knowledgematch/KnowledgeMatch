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

  //TODO to JSON!
}
