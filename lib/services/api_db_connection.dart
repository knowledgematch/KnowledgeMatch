import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:knowledgematch/model/userprofile.dart';

class ApiDbConnection {
  var host = '86.119.45.62';
  var port = 3000;

  Uri get baseUri => Uri.parse('http://$host:$port');

  Future<List<Map<String, dynamic>>> fetchDistinctDataFromUser(
      String toFetch) async {
    var finalUri = Uri.parse('$baseUri/toFetch/fetch=$toFetch');
    return await _fetcher(finalUri);
  }

  Future<List<Map<String, dynamic>>> fetchKeywords() async {
    var finalUri = Uri.parse('$baseUri/keywords');
    return await _fetcher(finalUri);
  }

  Future<List<Map<String, dynamic>>> fetchKeywordsByUser(int uid) async {
    var finalUri = Uri.parse('$baseUri/keywords/$uid');
    return await _fetcher(finalUri);
  }

  Future<bool> addUser2KeywordEntry(int uid, int kid) async {
    var finalUri = Uri.parse('$baseUri/keywords/$uid/$kid');
    try {
      final response = await http.post(finalUri);

      if (response.statusCode == 201) {
        // Successfully created
        return true;
      } else {
        print('Failed to add User2Keyword entry. Status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during POST request: $e');
      return false;
    }
  }

  Future<bool> removeUser2KeywordEntry(int uid, int kid) async {
    var finalUri = Uri.parse('$baseUri/keywords/$uid/$kid');
    try {
      final response = await http.delete(finalUri);

      if (response.statusCode == 204) {
        return true;
      } else {
        print('Failed to delete User2Keyword entry: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during DELETE request: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserByInput({
    String? uId,
    String? name,
    String? surname,
    String? keyword,
    String? reachability,
    String? email,
  }) async {
    var finalUri = baseUri.replace(
      path: '/fetchUsers',
      queryParameters: {
        'uId': uId,
        'name': name,
        'surname': surname,
        'keyword': keyword,
        'reachability': reachability,
        'email': email,
      },
    );
    return await _fetcher(finalUri);
  }

  Future<List<Map<String, dynamic>>> _fetcher(Uri uri) async {
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data is List) {
          return data.map((item) => Map<String, dynamic>.from(item)).toList();
        }
      }
      print('Failed to fetch from $uri. Status Code: ${response.statusCode}');
      return [];
    } catch (e) {
      print('Error with: $e');
      return [];
    }
  }

  Future<void> updateFcmToken(String userId) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) {
      print('FCM token is null.');
      return;
    }
    var finalUri = Uri.parse('$baseUri/updateToken');
    final Map<String, String> payload = {'token': token, 'uId': userId};

    try {
      final response = await http.post(
        finalUri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('FCM token updated successfully.');
      } else {
        print('Failed to update FCM token: ${response.body}');
      }
    } catch (e) {
      print('Error updating FCM token: $e');
    }
  }

  Future<void> deleteFcmToken(int id) async {
    final token = await FirebaseMessaging.instance.getToken();
    var finalUri = Uri.parse('$baseUri/deleteToken');
    if (token == null) {
      print('FCM token is null.');
      return;
    }
    final Map<String, String> payload = {'token': token, 'uId': id.toString()};
    print(payload);
    try {
      final response = await http.delete(
        finalUri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 204) {
        print('FCM token deleted successfully.');
      } else {
        print('Failed to delete FCM token: ${response.body}');
      }
    } catch (e) {
      print('Error deleting FCM token: $e');
    }
  }
}
