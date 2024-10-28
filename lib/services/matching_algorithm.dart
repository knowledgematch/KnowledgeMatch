import '../model/userprofile.dart';
import '../model/search_criteria.dart';
import 'db_connection.dart';

class MatchingAlgorithm{
  Future<List<Userprofile>> matchingAlgorithm(SearchCriteria searchCriteria) async {
    String query =  'SELECT CONCAT(u.Name, \' \', u.Surname) AS FullName, '
                    'u.Reachability, GROUP_CONCAT(DISTINCT k.Keyword ORDER BY '
                    'k.Keyword SEPARATOR \', \') AS Keywords FROM Users u '
                    'JOIN User2Keyword uk ON u.U_ID = uk.U_ID '
                    'JOIN Keyword k ON uk.K_ID = k.K_ID '
                    'JOIN Keyword2Topic kt ON k.K_ID = kt.K_ID '
                    'JOIN Topic t ON kt.T_ID = t.T_ID';
    List<String> queryBuilder = [];

    List<Userprofile> profiles = [];

    if (searchCriteria.topic.isNotEmpty) {
      queryBuilder.add("Keyword = '${searchCriteria.topic}'");
    }

    if (searchCriteria.reachability != null) {
      queryBuilder.add("Reachability = ${searchCriteria.reachability}");
    }

    if(queryBuilder.isNotEmpty) {
      query += ' WHERE ${queryBuilder.join(' AND ')}';
    }
    query += ' GROUP BY u.U_ID, u.Name, u.Surname, u.Reachability';

    var result = await DBConnection().getSQLResponse(query);
    if(result != null) {
      for (var row in result.rows) {
        var data = row.assoc();

        profiles.add(
            Userprofile(name: data['FullName'].toString(),
              location: 'Brugg',
              expertString: data['Keywords'].toString(),
              availability: 'Placeholder here',
              langString: 'Placeholder here',
              reachability: int.parse(data['Reachability'].toString()),
              description: 'Placeholder here',
            )
        );
      }
    }
    return profiles;
  }
}
