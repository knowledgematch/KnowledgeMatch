import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:knowledgematch/models/user.dart';

Future<void> initializeUser(int userId) async {
  try {
    final response =
        await http.get(Uri.parse('http://86.119.45.62/users/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        User.instance.populateFromJson(jsonData.first);
        print('User initialized: ${User.instance}');
      } else {
        print('No user data found.');
      }
    } else {
      print('Failed to fetch user data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
}
