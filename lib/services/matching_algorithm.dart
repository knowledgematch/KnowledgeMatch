import '../model/search_criteria.dart';

class MatchingAlgorithm{
  String matchingAlgorithm(SearchCriteria searchCriteria) {
    String query = 'SELECT * FROM Users';
    List<String> queryBuilder = [];

    if (searchCriteria.topic.isNotEmpty) {
      queryBuilder.add("topic = '${searchCriteria.topic}'");
    }

    if (searchCriteria.reachability != null) {
      queryBuilder.add("reachability = ${searchCriteria.reachability}");
    }

    if(queryBuilder.isNotEmpty) {
      query += ' WHERE ${queryBuilder.join(' AND ')}';
    }

    return query;
  }
}