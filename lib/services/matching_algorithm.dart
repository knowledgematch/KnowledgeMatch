import '../model/userprofile.dart';
import '../model/search_criteria.dart';
import 'api_db_connection.dart';

class MatchingAlgorithm{
  Future<List<String>> getKeywords() async {
    var result = await ApiDbConnection().fetchKeywords();
    return result.map((item) => item['Keyword'].toString()).toList();
  }

  Future<List<int>?> getReachabilities() async {
    var result = await ApiDbConnection().fetchDistinctDataFromUser("Reachability");
    return result.map<int>((row) => int.parse(row['Reachability'].toString())).toList();
  }

  Future<List<Userprofile>> matchingAlgorithm(SearchCriteria searchCriteria) async {
    List<Userprofile> profiles = [];
    var data = await ApiDbConnection().fetchUserByInput(
        uId: null,
        name: null,
        surname: null,
        keyword: searchCriteria.keyword,
        reachability: searchCriteria.reachability.toString(),
        email: null,
    );
    if(data != []) {
      for (var user in data) {
        profiles.add(
            _createUserFromJson(user)
        );
      }
    }
    return profiles;
  }

  Future<Userprofile> getUserProfileById(int id) async {
    var data = await ApiDbConnection().fetchUserByInput(uId: id.toString());
    return _createUserFromJson(data.elementAt(0));
  }


  Userprofile _createUserFromJson(Map<String, dynamic> user) {
    List<String> tokenList = [];
    if (user['Tokens'] != null && user['Tokens'].toString().trim().isNotEmpty) {
      tokenList = user['Tokens'].toString().split(',')
          .map<String>((token) => token.trim())
          .toList();
    }
    return Userprofile(
      id: int.parse(user['U_ID'].toString()),
      name: user['FullName'].toString(),
      location: 'Placeholder',
      expertString: user['Keywords'].toString(),
      availability: 'Placeholder',
      langString: 'Placeholder',
      reachability: int.parse(user['Reachability'].toString()),
      description: user['Description'].toString(),
      tokens: tokenList,
    );
  }
}
