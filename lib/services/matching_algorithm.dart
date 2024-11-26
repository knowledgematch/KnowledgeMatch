import '../model/userprofile.dart';
import '../model/search_criteria.dart';
import 'db_connection.dart';
import 'api_db_connection.dart';

class MatchingAlgorithm{
  Future<List<String>> getTopics() async {
    var result = await DBConnection().getSQLResponse(
        'SELECT DISTINCT Keyword from Keyword');
    return result?.rows.map((row) => row.assoc()['Keyword'].toString()).toList() ?? [];
  }

  Future<List<int>?> getReachabilities() async {
    var result = await DBConnection().getSQLResponse(
        'SELECT DISTINCT Reachability from User');
    return result?.rows.map((row) => int.parse(row.assoc()['Reachability']!)).toList() ?? [];
  }

  Future<List<Userprofile>> matchingAlgorithm(SearchCriteria searchCriteria) async {
    List<Userprofile> profiles = [];
    var data = await ApiDbConnection().fetchUsers(searchCriteria);
    if(data != []) {
      for (var user in data) {
        profiles.add(
            Userprofile(
              name: user['FullName'].toString(),
              location: 'Placeholder',
              expertString: user['Keywords'].toString(),
              availability: 'Placeholder',
              langString: 'Placeholder',
              reachability: int.parse(user['Reachability'].toString()),
              description: user['Description'].toString(),
            )
        );
      }
    }
    return profiles;
  }
}
