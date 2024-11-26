import '../model/userprofile.dart';
import '../model/search_criteria.dart';
import 'db_connection.dart';

class MatchingAlgorithm{
  Future<List<String>> getTopics() async {
    var result = await DBConnection().getSQLResponse(
        'SELECT DISTINCT Keyword from Keyword');
    return result?.rows.map((row) => row.assoc()['Keyword'].toString()).toList() ?? [];
  }

  Future<List<int>?> getReachabilities() async {
    var result = await DBConnection().getSQLResponse(
        'SELECT DISTINCT Reachability from Users');
    return result?.rows.map((row) => int.parse(row.assoc()['Reachability']!)).toList() ?? [];
  }

  Future<List<Userprofile>> matchingAlgorithm(SearchCriteria searchCriteria) async {
    String query =  'SELECT CONCAT(u.Name, \' \', u.Surname) AS FullName, '
                    'u.Reachability, GROUP_CONCAT(DISTINCT k.Keyword ORDER BY '
                    'k.Keyword SEPARATOR \', \') AS Keywords FROM Users u '
                    'JOIN User2Keyword uk ON u.U_ID = uk.U_ID '
                    'JOIN Keyword k ON uk.K_ID = k.K_ID '
                    'JOIN Keyword2Topic kt ON k.K_ID = kt.K_ID '
                    'JOIN Topic t ON kt.T_ID = t.T_ID';
    List<String> queryBuilder = [];

    if (searchCriteria.topic.isNotEmpty) {
      queryBuilder.add("Keyword = '${searchCriteria.topic}'");
    }

    if (searchCriteria.reachability != null) {
      if(searchCriteria.reachability != 2) {
        queryBuilder.add("Reachability IN (${searchCriteria.reachability}, 2)");
      }
    }

    if(queryBuilder.isNotEmpty) {
      query += ' WHERE ${queryBuilder.join(' AND ')}';
    }
    query += ' GROUP BY u.U_ID, u.Name, u.Surname, u.Reachability';

    var result = await DBConnection().getSQLResponse(query);

    List<Userprofile> profiles = [];
    if(result != null) {
      for (var row in result.rows) {
        var data = row.assoc();

        profiles.add(
            Userprofile(
              name: data['FullName'].toString(),
              location: 'Placeholder here',
              expertString: data['Keywords'].toString(),
              availability: 'Placeholder here',
              langString: 'Placeholder here',
              reachability: int.parse(data['Reachability'].toString()),
              description: 'Placeholder here',
              seniority: 1,
            )
        );
      }
    }
    return profiles;
  }
}
