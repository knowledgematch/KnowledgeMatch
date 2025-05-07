import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:knowledgematch/data/services/user_service.dart';
import 'package:knowledgematch/ui/login/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  LoginState _state = const LoginState();

  LoginState get state => _state;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) return;

    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('https://fl-13-105.zhdk.cloud.switch.ch:3000/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _state = _state.copyWith(
          errorMessage: null,
          loginSuccess: true,
        );
        notifyListeners();
      } else {
        _state = _state.copyWith(
          errorMessage: data['message'],
          loginSuccess: false,
        );
        notifyListeners();
      }
    } catch (e) {
      _state = _state.copyWith(errorMessage: 'Error: $e');
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool isLoading) {
    _state = _state.copyWith(isLoading: isLoading);
    notifyListeners();
  }

  Future<void> storeLoggedInUser(
      String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userData', jsonEncode(user));

    final userDataString = prefs.getString('userData');
    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      int uId = int.tryParse(userData['U_ID'].toString()) ?? 0;
      await initializeUser(uId);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
