import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/services/api_db_connection.dart';
import '../change_pw_state.dart';

class ChangePwViewModel extends ChangeNotifier {
  ChangePWState _state = ChangePWState();

  get state => _state;

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
  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      String userEmail = userData['Email'].toString();
      //_state.email = userEmail;
      _state = ChangePWState().copyWith(email: userEmail);
      notifyListeners();
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
    if (state.formKey.currentState!.validate()) {
      final email = state.email;
      final oldPassword = state.oldPasswordController.text;
      final newPassword = state.newPasswordController.text;

      final response = await ApiDbConnection()
          .changePassword(email, oldPassword, newPassword);
      if (response == 200) {
        return true;
      }
    }
    return false;
  }
}
