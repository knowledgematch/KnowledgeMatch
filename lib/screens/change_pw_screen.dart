import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:knowledgematch/services/api_db_connection.dart';
import 'dart:convert';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

//TODO Move logic to service class!
  /// Loads the user ID and email from shared preferences.
  ///
  /// This method retrieves the `userData` string from shared preferences, decodes
  /// it from JSON, and updates the local state with the user's ID (`_uId`) and email
  /// (`_email`) if the data is available. If the `userData` string is not found or is
  /// invalid, no changes are made to the state.
  ///
  /// This is an asynchronous method that uses [SharedPreferences] for persistent storage.
  ///
  /// Returns a [Future] that completes when the user data has been loaded and the
  /// state has been updated.
  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      setState(() {
        _email = userData['Email'].toString();
      });
    }
  }

//TODO Move logic to Service class!
  /// Changes the user's password after validating the form.
  ///
  /// This method validates the current form using the [formKey]. If the form is valid,
  /// it retrieves the user's email, old password, and new password from the form and
  /// attempts to change the password using the [ApiDbConnection]. Depending on the response
  /// from the API, it displays a success or error message using a [SnackBar]. If the password
  /// is successfully changed, the user is navigated back to the previous screen.
  ///
  /// Parameters:
  /// - This method does not take any parameters. It uses the form state and controller values
  ///   to retrieve the necessary data.
  ///
  /// Returns:
  /// - This method does not return a value. It updates the UI based on the response from the API.
  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      final email = _email;
      final oldPassword = _oldPasswordController.text;
      final newPassword = _newPasswordController.text;

      final response = await ApiDbConnection()
          .changePassword(email, oldPassword, newPassword);

      if (response == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password changed successfully!')),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $response')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Old Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your old password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new password';
                  }
                  if (value.length < 4) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmNewPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _changePassword,
                child: const Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
