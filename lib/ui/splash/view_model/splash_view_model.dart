import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/services/api_db_connection.dart';
import '../../../data/services/user_service.dart';
import '../../../domain/models/user.dart';
import '../splash_state.dart';

class SplashViewModel extends ChangeNotifier {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  SplashState _state;

  SplashState get state => _state;

  SplashViewModel() : _state = SplashState(isLoggedIn: null);

  /// Initialize anything needed for the Splash flow.
  Future<void> init() async {
    // Check if we have a valid session token.
    await _checkLoggedInStatus();
    // Request push notification permissions (especially relevant for iOS).
    await _requestPermissions();
    notifyListeners();
  }

  /// Checks whether the user is already logged in based on local storage.
  Future<void> _checkLoggedInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userDataString = prefs.getString('userData');

    if (token != null && userDataString != null) {
      // User is logged in
      final userData = jsonDecode(userDataString);
      int uId = int.tryParse(userData['U_ID'].toString()) ?? 0;

      // Instantiate User
      await initializeUser(uId);

      // Update FCM token
      ApiDbConnection().updateFcmToken(User.instance.id.toString());

      _state = _state.copyWith(isLoggedIn: true);
    } else {
      _state = _state.copyWith(isLoggedIn: false);
    }
  }

  /// Request permissions for push notifications.
  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted push notification permission.');
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('User denied push notification permission.');
    }
    // If needed, handle other status cases (e.g., provisional)
  }
}
