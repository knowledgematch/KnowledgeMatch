import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/forgot_pw/forgot_pw_state.dart';
import 'package:knowledgematch/data/services/api_db_connection.dart';

class ForgotPwViewModel extends ChangeNotifier {
  ForgotPwState state = ForgotPwState();
  final ApiDbConnection _api = ApiDbConnection();

  Future<bool> requestNewPassword() async {
    final email = state.emailController.text.trim();
    if (email.isEmpty) return false;

    return await _api.requestPasswordReset(email);
  }
}
