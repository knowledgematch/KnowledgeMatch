import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/organisation.dart';

class ApiDbConnection {
  String host = "";
  var port = 3000;

  Uri get baseUri => Uri.parse('https://$host:$port');

  ApiDbConnection() {
    if (kReleaseMode) {
      // Live server
      host = 'fl-13-105.zhdk.cloud.switch.ch';
      // host = 'fl-15-241.zhdk.cloud.switch.ch';
    } else {
      //TODO Create second notification Method on firebase
      // Test server
      host = 'fl-13-105.zhdk.cloud.switch.ch';
      // host = 'fl-15-241.zhdk.cloud.switch.ch';
    }
  }

  /// Fetches distinct data for a specific key from the user.
  ///
  /// This method constructs a URI based on the provided key, then calls the [_fetcher] method to
  /// retrieve the data from the server. It returns the data as a list of maps if successful.
  ///
  /// Parameters:
  /// - [toFetch]: The specific key or type of data to fetch from the user.
  ///
  /// Returns:
  /// - A [Future] that completes with a list of maps containing the fetched distinct data.
  Future<List<Map<String, dynamic>>> fetchDistinctDataFromUser(
      String toFetch) async {
    var finalUri = Uri.parse('$baseUri/toFetch/fetch=$toFetch');
    return await _fetcher(finalUri);
  }

  /// Fetches a list of keywords from the server.
  ///
  /// This method constructs a URI for the keywords endpoint and calls the [_fetcher] method to retrieve
  /// the keywords data from the server. It returns the data as a list of maps if successful.
  ///
  /// Parameters:
  /// - This method does not take any parameters.
  ///
  /// Returns:
  /// - A [Future] that completes with a list of maps containing the fetched keywords.
  Future<List<Map<String, dynamic>>> fetchKeywords() async {
    var finalUri = Uri.parse('$baseUri/keywords');
    return await _fetcher(finalUri);
  }

  Future<int> addKeywordEntry(
      {required int levels,
      required String keyword,
      required String description}) async {
    var finalUri = baseUri.replace(
      path: '/keywords',
    );
    final apiKey = await getApiKey();
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': apiKey,
    };
    final body = jsonEncode({
      'Levels': levels,
      'Keyword': keyword,
      'Description': description,
    });

    try {
      final response = await http.post(finalUri, headers: headers, body: body);
      return response.statusCode;
    } catch (error) {
      return -1;
    }
  }

  Future<bool> updateKeywordEntry(
      {required int id,
      required int levels,
      required String keyword,
      required String description}) async {
    var finalUri = Uri.parse('$baseUri/keywords/$id');
    final apiKey = await getApiKey();
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': apiKey,
    };
    final body = jsonEncode({
      'Levels': levels,
      'Keyword': keyword,
      'Description': description,
    });
    try {
      final response = await http.put(finalUri, headers: headers, body: body);
      if (response.statusCode == 204) {
        return true;
      } else {
        print('Failed to delete Keyword entry: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating Keyword: $e');
      return false;
    }
  }

  Future<bool> removeKeywordEntry(int id) async {
    var finalUri = Uri.parse('$baseUri/keywords/$id');
    final apiKey = await getApiKey();

    try {
      final response = await http.delete(
        finalUri,
        headers: {
          'x-api-key': apiKey,
        },
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        print('Failed to delete Keyword entry: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during DELETE request: $e');
      return false;
    }
  }

  Future<bool> removeTopicEntry(int id) async {
    var finalUri = Uri.parse('$baseUri/topics/$id');
    final apiKey = await getApiKey();

    try {
      final response = await http.delete(
        finalUri,
        headers: {
          'x-api-key': apiKey,
        },
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        print('Failed to delete Topic entry: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during DELETE request: $e');
      return false;
    }
  }

  Future<bool> updateTopicEntry(
      {required int id,
      required int levels,
      required String topic,
      required String description}) async {
    var finalUri = Uri.parse('$baseUri/topics/$id');
    final apiKey = await getApiKey();
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': apiKey,
    };
    final body = jsonEncode({
      'Levels': levels,
      'Topic': topic,
      'Description': description,
    });
    try {
      final response = await http.put(finalUri, headers: headers, body: body);
      if (response.statusCode == 204) {
        return true;
      } else {
        print('Failed to delete Topic entry: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating Topic: $e');
      return false;
    }
  }

  Future<int> addTopicEntry(
      {required int levels,
      required String topic,
      required String description}) async {
    var finalUri = baseUri.replace(
      path: '/topics',
    );
    final apiKey = await getApiKey();
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': apiKey,
    };
    final body = jsonEncode({
      'Levels': levels,
      'Topic': topic,
      'Description': description,
    });

    try {
      final response = await http.post(finalUri, headers: headers, body: body);
      return response.statusCode;
    } catch (error) {
      return -1;
    }
  }

  Future<bool> addKeyword2TopicsEntry(int kid, int tid) async {
    var finalUri = Uri.parse('$baseUri/topics/$kid/$tid');
    final apiKey = await getApiKey();

    try {
      final response = await http.post(
        finalUri,
        headers: {'x-api-key': apiKey},
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print(
            'Failed to add Keyword2Topics entry. Status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during POST request: $e');
      return false;
    }
  }

  Future<bool> removeKeyword2TopicEntry(int kid, int tid) async {
    var finalUri = Uri.parse('$baseUri/topics/$kid/$tid');
    try {
      final response = await http.delete(finalUri);

      if (response.statusCode == 204) {
        return true;
      } else {
        print('Failed to delete Keyword2Topic entry: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during DELETE request: $e');
      return false;
    }
  }

  Future<List<dynamic>?> initUser(int userId) async {
    var finalUri = Uri.parse('$baseUri/users/$userId');
    final apiKey = await getApiKey();

    try {
      final response = await http.get(
        finalUri,
        headers: {
          'x-api-key': apiKey,
        },
      );

      print("response: $response");
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchKeyword2Topic() async {
    var finalUri = Uri.parse('$baseUri/keyword2topic');
    return await _fetcher(finalUri);
  }

  /// Fetches a list of topics from the server.
  ///
  /// This method constructs a URI for the topics endpoint and calls the [_fetcher] method to retrieve
  /// the topics data from the server. It returns the data as a list of maps if successful.
  ///
  /// Parameters:
  /// - This method does not take any parameters.
  ///
  /// Returns:
  /// - A [Future] that completes with a list of maps containing the fetched topics.
  Future<List<Map<String, dynamic>>> fetchTopics() async {
    var finalUri = Uri.parse('$baseUri/topics');
    return await _fetcher(finalUri);
  }

  /// Fetches the list of keywords associated with a specific user.
  ///
  /// This method constructs a URI using the provided user ID, then calls the [_fetcher] method to retrieve
  /// the keywords for that user from the server. It returns the data as a list of maps if successful.
  ///
  /// Parameters:
  /// - [uid]: The user ID for which to fetch the associated keywords.
  ///
  /// Returns:
  /// - A [Future] that completes with a list of maps containing the fetched keywords for the specified user.
  Future<List<Map<String, dynamic>>> fetchKeywordsByUser(int uid) async {
    var finalUri = Uri.parse('$baseUri/keywords/$uid');
    return await _fetcher(finalUri);
  }

  /// Adds a user-to-keyword association in the system.
  ///
  /// This method sends a POST request to the `/keywords/{uid}/{kid}` endpoint to associate
  /// a user with a specific keyword. It returns `true` if the operation was successful,
  /// or `false` if there was an error or the request failed.
  ///
  /// Parameters:
  /// - [uid]: The unique ID of the user to associate with the keyword.
  /// - [kid]: The ID of the keyword to associate with the user.
  ///
  /// Returns:
  /// - A [Future] that completes with a boolean indicating whether the association was successful.
  Future<bool> addUser2KeywordEntry(int uid, int kid) async {
    var finalUri = Uri.parse('$baseUri/keywords/$uid/$kid');
    final apiKey = await getApiKey();

    try {
      final response = await http.post(
        finalUri,
        headers: {'x-api-key': apiKey},
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print(
            'Failed to add User2Keyword entry. Status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during POST request: $e');
      return false;
    }
  }

  /// Removes a user-to-keyword association from the system.
  ///
  /// This method sends a DELETE request to the `/keywords/{uid}/{kid}` endpoint to disassociate
  /// a user from a specific keyword. It returns `true` if the operation was successful,
  /// or `false` if there was an error or the request failed.
  ///
  /// Parameters:
  /// - [uid]: The unique ID of the user to disassociate from the keyword.
  /// - [kid]: The ID of the keyword to disassociate from the user.
  ///
  /// Returns:
  /// - A [Future] that completes with a boolean indicating whether the removal was successful.
  Future<bool> removeUser2KeywordEntry(int uid, int kid) async {
    var finalUri = Uri.parse('$baseUri/keywords/$uid/$kid');
    final apiKey = await getApiKey();

    try {
      final response = await http.delete(
        finalUri,
        headers: {'x-api-key': apiKey},
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        print('Failed to delete User2Keyword entry: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during DELETE request: $e');
      return false;
    }
  }

  /// Fetches users based on provided search criteria.
  ///
  /// This method constructs a URI for the `/fetchUsers` endpoint using the provided optional
  /// query parameters (such as user ID, name, surname, keyword, etc.) and calls the [_fetcher]
  /// method to retrieve the matching users from the server. It returns the data as a list of maps
  /// if successful.
  ///
  /// Parameters:
  /// - [uId]: Optional user ID filter.
  /// - [name]: Optional name filter.
  /// - [surname]: Optional surname filter.
  /// - [keyword]: Optional keyword filter.
  /// - [reachability]: Optional reachability filter.
  /// - [email]: Optional email filter.
  ///
  /// Returns:
  /// - A [Future] that completes with a list of maps containing the fetched users based on the given filters.
  Future<List<Map<String, dynamic>>> fetchUserByInput({
    String? uId,
    String? name,
    String? surname,
    String? keyword,
    String? reachability,
    String? email,
  }) async {
    var finalUri = baseUri.replace(
      path: '/fetchUsers',
      queryParameters: {
        'uId': uId,
        'name': name,
        'surname': surname,
        'keyword': keyword,
        'reachability': reachability,
        'email': email,
      },
    );
    return await _fetcher(finalUri);
  }

  /// Changes the password for the user with the provided email.
  ///
  /// This method sends a request to change the user's password by providing the current email,
  /// old password, and new password. It returns the HTTP status code of the response, or -1 if
  /// there was an error during the request.
  ///
  /// Parameters:
  /// - [email]: The email address of the user whose password is being changed.
  /// - [oldPassword]: The user's current password.
  /// - [newPassword]: The new password to set for the user.
  ///
  /// Returns:
  /// - A [Future] that completes with the status code of the password change request or -1 if there was an error.
  Future<int> changePassword(
    String email,
    String oldPassword,
    String newPassword,
  ) async {
    var finalUri = baseUri.replace(
      path: '/change-password',
    );
    final apiKey = await getApiKey();
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': apiKey,
    };
    final body = jsonEncode({
      'email': email,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });

    try {
      final response = await http.post(finalUri, headers: headers, body: body);
      return response.statusCode;
    } catch (error) {
      return -1;
    }
  }

  /// Creates a new user account with the provided details.
  ///
  /// This method sends a POST request to the `/users` endpoint with the user's name, surname,
  /// email, password, reachability, and an optional image. It returns the HTTP status code
  /// of the response, or -1 if there was an error during the request.
  ///
  /// Parameters:
  /// - [name]: The name of the user to be created.
  /// - [surname]: The surname of the user to be created.
  /// - [email]: The email address of the user to be created.
  /// - [password]: The password for the new user.
  /// - [reachability]: The reachability status of the user.
  /// - [image]: An optional image file to associate with the user's profile.
  ///
  /// Returns:
  /// - A [Future] that completes with the status code of the account creation request or -1 if there was an error.
  Future<int> createAccount(String name, String surname, String email,
      String password, String reachability, File? image) async {
    var finalUri = baseUri.replace(
      path: '/users',
    );

    final request = http.MultipartRequest('POST', finalUri);
    request.fields['Name'] = name;
    request.fields['Surname'] = surname;
    request.fields['Email'] = email;
    request.fields['Password'] = password;
    request.fields['Reachability'] = reachability;
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'Picture',
        image.path,
      ));
    }
    late http.StreamedResponse response;
    try {
      response = await request.send();
      return response.statusCode;
    } catch (error) {
      return -1;
    }
  }

  /// Updates the user's profile with the provided information.
  ///
  /// This method sends a PUT request to the `/users/{uId}` endpoint with the user's ID, name,
  /// surname, reachability, email, seniority, description, and an optional profile image.
  /// It returns the HTTP status code of the response, or -1 if there was an error during the request.
  ///
  /// Parameters:
  /// - [uId]: The unique ID of the user whose profile is being updated.
  /// - [name]: The name of the user to update.
  /// - [surname]: The surname of the user to update.
  /// - [reachability]: The reachability status of the user.
  /// - [email]: The email address of the user.
  /// - [seniority]: The seniority level of the user.
  /// - [description]: The description of the user.
  /// - [image]: An optional image to update the user's profile picture.
  ///
  /// Returns:
  /// - A [Future] that completes with the status code of the profile update request or -1 if there was an error.
  Future<int> saveProfile(
      String uId,
      String name,
      String surname,
      String reachability,
      String email,
      String seniority,
      String description,
      Uint8List? image) async {
    var finalUri = baseUri.replace(
      path: '/users/$uId',
    );
    final apiKey = await getApiKey();
    final request = http.MultipartRequest('PUT', finalUri);

    print("========= key: $apiKey");
    request.headers['x-api-key'] = apiKey;

    request.fields['Name'] = name;
    request.fields['Surname'] = surname;
    request.fields['Reachability'] = reachability;
    request.fields['Email'] = email;
    request.fields['Seniority'] = seniority;
    request.fields['Description'] = description;
    if (image != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'Picture',
        image as List<int>,
        filename: 'profile_picture.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
    }
    try {
      final response = await request.send();
      print("response: ${response.statusCode}");
      return response.statusCode;
    } catch (error) {
      return -1;
    }
  }

  Future<String> login(String email, String password) async {
    var finalUri = Uri.parse('$baseUri/login');

    try {
      final response = await http.post(
        finalUri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = data['user'];

        return '$token;$user';
      } else {
        return "Error logging in.";
      }
    } catch (e) {
      return "Error logging in.";
    }
  }

  Future<Map<String, dynamic>?> twoFA(String email, String code) async {
    var finalUri = Uri.parse('$baseUri/verify-2fa');

    try {
      final response = await http.post(
        finalUri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email, 'code': code}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final Map<String, dynamic> user = data['user'];
        print(user);
        return {'token': token, 'user': user};
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  /// Updates the FCM token for the user with the provided user ID.
  ///
  /// This method retrieves the current Firebase Cloud Messaging (FCM) token for the device and
  /// sends it to the server to update the user's FCM token. It prints messages based on the success
  /// or failure of the update.
  ///
  /// Parameters:
  /// - [userId]: The ID of the user whose FCM token is being updated.
  ///
  /// Returns:
  /// - A [Future] that completes when the FCM token update process is finished, with no value returned.
  Future<void> updateFcmToken(String userId) async {
    final token = await FirebaseMessaging.instance.getToken();
    final apiKey = await getApiKey();

    if (token == null) {
      print('FCM token is null.');
      return;
    }
    var finalUri = Uri.parse('$baseUri/updateToken');
    final Map<String, String> payload = {'token': token, 'uId': userId};

    try {
      final response = await http.post(
        finalUri,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('FCM token updated successfully.');
      } else {
        print('Failed to update FCM token: ${response.body}');
      }
    } catch (e) {
      print('Error updating FCM token: $e');
    }
  }

  /// Deletes the FCM token for the user with the provided user ID.
  ///
  /// This method retrieves the current Firebase Cloud Messaging (FCM) token for the device and
  /// sends a request to the server to delete the user's FCM token. It prints messages based on the success
  /// or failure of the deletion.
  ///
  /// Parameters:
  /// - [id]: The ID of the user whose FCM token is being deleted.
  ///
  /// Returns:
  /// - A [Future] that completes when the FCM token deletion process is finished, with no value returned.
  Future<void> deleteFcmToken(int id) async {
    final apiKey = await getApiKey();
    final token = await FirebaseMessaging.instance.getToken();
    var finalUri = Uri.parse('$baseUri/deleteToken');

    if (token == null) {
      print('FCM token is null.');
      return;
    }
    final Map<String, String> payload = {'token': token, 'uId': id.toString()};
    print(payload);
    try {
      final response = await http.delete(
        finalUri,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 204) {
        print('FCM token deleted successfully.');
      } else {
        print('Failed to delete FCM token: ${response.body}');
      }
    } catch (e) {
      print('Error deleting FCM token: $e');
    }
  }

  /// Fetches data from the given URI and returns it as a list of maps.
  ///
  /// This method sends a GET request to the provided URI, processes the response if successful,
  /// and returns the decoded JSON data as a list of [Map<String, dynamic>]. In case of failure
  /// or an error, it prints an error message and returns an empty list.
  ///
  /// Parameters:
  /// - [uri]: The URI from which data will be fetched.
  ///
  /// Returns:
  /// - A [Future] that completes with a list of maps containing the fetched data or an empty list if the fetch fails.
  Future<List<Map<String, dynamic>>> _fetcher(Uri uri) async {
    try {
      final apiKey = await getApiKey();
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data is List) {
          return data.map((item) => Map<String, dynamic>.from(item)).toList();
        }
      }
      print('Failed to fetch from $uri. Status Code: ${response.statusCode}');
      return [];
    } catch (e) {
      print('Error with: $e');
      return [];
    }
  }

  /// Requests a password reset for the user with the provided email address.
  ///
  /// This method sends a POST request to the `/forgot-password` endpoint with the user's email.
  /// If the request is successful (HTTP 200), the method returns `true`.
  /// Otherwise, it returns `false`.
  ///
  /// Parameters:
  /// - [email]: The email address for which to request a password reset.
  ///
  /// Returns:
  /// - A [Future] that completes with `true` if the request was successful, or `false` otherwise.
  Future<bool> requestPasswordReset(String email) async {
    final finalUri = baseUri.replace(path: '/forgot-password');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email});

    try {
      final response = await http.post(finalUri, headers: headers, body: body);
      return response.statusCode == 200;
    } catch (e) {
      print('Error during password reset request: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> createOrganisation({
    required String organisation,
    required String domain,
  }) async {
    final finalUri = baseUri.replace(path: '/organisations');
    final apiKey = await getApiKey();
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': apiKey,
    };
    final body = jsonEncode({
      'organisation': organisation,
      'domain': domain,
    });

    try {
      final response = await http.post(finalUri, headers: headers, body: body);
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      print('Failed to create organisation: ${response.body}');
      return null;
    } catch (e) {
      print('Error creating organisation: $e');
      return null;
    }
  }

  Future<bool> updateOrganisation({
    required int id,
    required String organisation,
    required String domain,
  }) async {
    final finalUri = baseUri.replace(path: '/organisations/$id');
    final apiKey = await getApiKey();
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': apiKey,
    };
    final body = jsonEncode({
      'organisation': organisation,
      'domain': domain,
    });

    try {
      final response = await http.put(finalUri, headers: headers, body: body);
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating organisation: $e');
      return false;
    }
  }

  Future<bool> deleteOrganisation(int id) async {
    final finalUri = baseUri.replace(path: '/organisations/$id');
    final apiKey = await getApiKey();

    try {
      final response = await http.delete(
        finalUri,
        headers: {'x-api-key': apiKey},
      );
      return response.statusCode == 204;
    } catch (e) {
      print('Error deleting organisation: $e');
      return false;
    }
  }

  Future<List<Organisation>> getAllOrganisations() async {
    final finalUri = baseUri.replace(path: '/organisations');
    try {
      final response = await http.get(
        finalUri,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Organisation.fromJson(item)).toList();
      } else {
        print('Failed to fetch organisations: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching organisations: $e');
      return [];
    }
  }

  Future<bool> isEmailDomainValid(String email) async {
    try {
      final organisations = await getAllOrganisations();

      final emailDomain = email.split('@').last.trim().toLowerCase();
      final organisationDomains =
          organisations.map((org) => org.domain.trim().toLowerCase()).toList();

      print('Email domain: $emailDomain');
      print('Organisation domains: $organisationDomains');

      final isValid = organisationDomains.contains(emailDomain);
      print('Is email domain valid? $isValid');

      return isValid;
    } catch (e) {
      print('Error validating email domain: $e');
      return false;
    }
  }

  Future<String> getApiKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('userData');
      print("===userdata: $userDataString");
      if (userDataString != null) {
        final userData = jsonDecode(userDataString);
        return userData['ApiKey'].toString();
      }
      return "No Key";
    } catch (e) {
      print("Error fetching API key: $e");
      return "Error fetching Key";
    }
  }

  Future<void> deleteAccount(int id, String apiKey) async {
    final finalUri = baseUri.replace(path: '/users/$id');

    try {
      final response = await http.delete(
        finalUri,
        headers: {'x-api-key': apiKey},
      );
      print(response.statusCode);
    } catch (e) {
      print('Error deleting account: $e');
    }
  }
}
