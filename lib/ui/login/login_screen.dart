import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:knowledgematch/data/services/api_db_connection.dart';
import 'package:knowledgematch/data/services/user_service.dart';
import 'package:knowledgematch/domain/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/themes/app_colors.dart';
import '../create_profile/create_profile_screen.dart';
import '../main/widgets/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse('https://fl-13-105.zhdk.cloud.switch.ch:3000/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = data['user'];

        // Save the logged-in user persistently
        await storeLoggedInUser(token, user);
        //update fcmToken
        ApiDbConnection().updateFcmToken(User.instance.id.toString());

        // Navigate to the main screen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        }
      } else {
        final data = jsonDecode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['message']),
          ));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
        ));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //TODO move to service class
  /// Stores the logged-in user's token and data in shared preferences.
  ///
  /// This method saves the user's authentication token and associated user data in the
  /// shared preferences. After storing the data, it retrieves and decodes the user data,
  /// initializing the user based on the stored user ID.
  ///
  /// Parameters:
  /// - [token]: The authentication token to store.
  /// - [user]: A map containing the user's data to store.
  ///
  /// Returns:
  /// - This method does not return anything.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateProfileScreen()),
                );
              },
              child: Text('Create a new account',
                  style: TextStyle(color: AppColors.blackLight)),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Login',
                      style: TextStyle(color: AppColors.whiteLight)),
            ),
          ],
        ),
      ),
    );
  }
}
