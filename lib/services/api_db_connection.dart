import 'package:http/http.dart' as http;
import 'package:knowledgematch/model/search_criteria.dart';
import 'dart:convert';

class ApiDbConnection {
  var host = '86.119.45.62';
  var port = 3000;
  Uri get baseUri => Uri.parse('http://$host:$port');

  Future<List<Map<String, dynamic>>> fetchUsers(SearchCriteria searchCriteria) async {
    var finalUri = baseUri.replace(
      path: '/fetchUsers',
      queryParameters: {
        'keyword': searchCriteria.keyword,
        'reachability': searchCriteria.reachability.toString(),
      },
    );

    try {
      final response = await http.get(finalUri);
      if(response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if(data is List) {
          return data.map((item) => Map<String, dynamic>.from(item)).toList();
        }
      }
      print('Failed to fetch users. Status code: ${response.statusCode}');
      return [];
    }
    catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }
}
