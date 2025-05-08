import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:knowledgematch/ui/two_fa/two_fa_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/services/api_db_connection.dart';
import '../../../data/services/user_service.dart';
import '../../../domain/models/user.dart';

class TwoFAViewModel extends ChangeNotifier {
  TwoFAState state = TwoFAState();

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  Future<bool> verifyCode() async {
    final code = state.codeController.text;
    if (code.isEmpty || state.email.isEmpty) return false;

    try {
      final response = await http.post(
        Uri.parse('https://fl-13-105.zhdk.cloud.switch.ch:3000/verify-2fa'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': state.email, 'code': code}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String token = data['token'];
        final Map<String, dynamic> user = data['user'];

        // Save the logged-in user persistently
        await storeLoggedInUser(token, user);
        //update fcmToken
        ApiDbConnection().updateFcmToken(User.instance.id.toString());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error during 2FA verification: $e');
      return false;
    }
  }

  Future<void> storeLoggedInUser(
      String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userData', jsonEncode(user));

    // Retrieve and decode the saved user data
    final userDataString = prefs.getString('userData');
    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      int uId = int.tryParse(userData['U_ID'].toString()) ?? 0;
      await initializeUser(uId);
    }
  }
}
