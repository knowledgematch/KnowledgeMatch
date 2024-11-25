import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:knowledgematch/model/search_criteria.dart';
import 'dart:convert';

import 'package:knowledgematch/model/userprofile.dart';

class ApiDbConnection {
  var host = '86.119.45.62';
  var port = 3000;
  Uri get baseUri => Uri.parse('http://$host:$port');

  Future<void> getUsers(SearchCriteria searchCriteria) async {
    var finalUri = baseUri.replace(
      path: '/searchUser',
      queryParameters: {
        'keyword': searchCriteria.keyword,
        'reachability': searchCriteria.reachability.toString(),
      },
    );
    List<Userprofile> profiles = [];
    print(finalUri);
    try {
      final response = await http.get(finalUri);

      if(response.statusCode == 200) {
        final users = jsonDecode(response.body);
        print(users);
      } else {
        print("wow");
      }
    } catch (e) {
      print("Wrong");
    }
  }

  Future<void> pingPort() async {
    try {

      final response = await http.get(baseUri);

      if(response.statusCode == 200) {
        final users = jsonDecode(response.body);
        print(users);
      } else {
        print('Failed to fetch');
      }
    } catch (e) {
      print('Port $port on $host is not accessible: $e');
    }
  }
}