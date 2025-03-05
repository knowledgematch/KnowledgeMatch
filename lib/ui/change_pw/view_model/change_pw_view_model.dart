
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/services/api_db_connection.dart';

class ChangePwViewModel {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
  TextEditingController();
  String _email = '';

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
  Future<void> loadUserId()  async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      _email = userData['Email'].toString();
    }
  }

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
  Future<bool> changePassword() async {
    if (_formKey.currentState!.validate()) {
      final email = _email;
      final oldPassword = _oldPasswordController.text;
      final newPassword = _newPasswordController.text;

      final response = await ApiDbConnection()
          .changePassword(email, oldPassword, newPassword);
      if(response == 200) {
        return true;
      }
    }
    return false;
  }

  TextEditingController get confirmNewPasswordController =>
      _confirmNewPasswordController;

  TextEditingController get newPasswordController => _newPasswordController;

  TextEditingController get oldPasswordController => _oldPasswordController;

  get formKey => _formKey;
}