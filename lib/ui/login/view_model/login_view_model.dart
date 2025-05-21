import 'package:flutter/material.dart';
import 'package:knowledgematch/data/services/api_db_connection.dart';
import 'package:knowledgematch/ui/login/login_state.dart';

class LoginViewModel extends ChangeNotifier {
  LoginState _state = const LoginState();
  final ApiDbConnection api;

  LoginState get state => _state;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginViewModel({ApiDbConnection? api}) : api = api ?? ApiDbConnection();

  Future<void> login() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) return;

    _setLoading(true);

    final data = await api.login(email, password);

    if (data.toString().contains(';')) {
      _state = _state.clearError();
      _state = _state.copyWith(
        loginSuccess: true,
      );
      notifyListeners();
    } else {
      _state = _state.copyWith(
        errorMessage: data.toString(),
        loginSuccess: false,
      );
      notifyListeners();
    }
    _setLoading(false);
  }

  void _setLoading(bool isLoading) {
    _state = _state.copyWith(isLoading: isLoading);
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
