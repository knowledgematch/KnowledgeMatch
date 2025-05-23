import 'dart:convert';

import 'package:flutter/material.dart';
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
      final response = await ApiDbConnection().twoFA(state.email, code);

      if (response != null) {
        final String token = response['token'];
        final Map<String, dynamic> user = response['user'];
        print("2fa: user: $user");
        // Save the logged-in user persistently
        await storeLoggedInUser(token, user);
        //update fcmToken
        ApiDbConnection().updateFcmToken(User.instance.id.toString());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error during 2FA verification.');
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
