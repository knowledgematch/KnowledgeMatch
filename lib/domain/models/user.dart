import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

class User extends ChangeNotifier {
  // Singleton instance
  static final User _instance = User._privateConstructor();

  User._privateConstructor();

  static User get instance => _instance;

  int? _id;
  String? _name;
  String? _surname;
  int? _reachability;
  String? _email;
  String? _picture;
  int? _seniority;
  String? _description;
  bool? _isAdmin = false;

  int? get id => _id;

  String? get name => _name;

  String? get surname => _surname;

  int? get reachability => _reachability;

  String? get email => _email;

  String? get picture => _picture;

  int? get seniority => _seniority;

  String? get description => _description;

  bool? get isAdmin => _isAdmin;

  set id(int? value) {
    _id = value;
    notifyListeners();
  }

  set name(String? value) {
    _name = value;
    notifyListeners();
  }

  set surname(String? value) {
    _surname = value;
    notifyListeners();
  }

  set reachability(int? value) {
    _reachability = value;
    notifyListeners();
  }

  set email(String? value) {
    _email = value;
    notifyListeners();
  }

  set picture(String? value) {
    _picture = value;
    notifyListeners();
  }

  set seniority(int? value) {
    _seniority = value;
    notifyListeners();
  }

  set description(String? value) {
    _description = value;
    notifyListeners();
  }

  set isAdmin(bool? value) {
    _isAdmin = value;
    notifyListeners();
  }

  /// Populates the [User] instance's fields using data from a JSON map.
  ///
  /// Extracts values from the provided [json] map and assigns them to the
  /// corresponding fields in the [User] instance. If the JSON includes
  /// a `Picture`, it is encoded as a base64 string and stored in the [picture] field.
  ///
  /// Parameters:
  /// - [json]: A map containing key-value pairs that represent user data.
  ///
  /// Fields Populated:
  /// - `id`: Extracted from the `U_ID` key.
  /// - `name`: Extracted from the `Name` key.
  /// - `surname`: Extracted from the `Surname` key.
  /// - `reachability`: Extracted from the `Reachability` key.
  /// - `email`: Extracted from the `Email` key.
  /// - `picture`: Encoded as a base64 string if present under the `Picture` key.
  /// - `seniority`: Extracted from the `Seniority` key.
  /// - `description`: Extracted from the `Description` key.
  void populateFromJson(Map<String, dynamic> json) {
    id = json['U_ID'] as int?;
    name = json['Name'] as String?;
    surname = json['Surname'] as String?;
    reachability = json['Reachability'] as int?;
    email = json['Email'] as String?;

    picture = json['Picture'] != null
        ? base64Encode(
            (json['Picture']['data'] as List<dynamic>).cast<int>(),
          )
        : null;

    seniority = json['Seniority'] as int?;
    description = json['Description'] as String?;
    if (json['isAdmin'] > 0) {
      isAdmin = true;
    }
    notifyListeners();
  }

  /// Returns the decoded [Uint8List] of the [picture] if available
  Uint8List? getDecodedPicture() {
    if (picture != null) {
      return base64Decode(picture!);
    }
    return null;
  }

  /// Sets the [picture] field by encoding an image to a base64 string.
  void setPicture(Uint8List? imageData) {
    if (imageData != null) {
      picture = base64Encode(imageData);
    } else {
      picture = null;
    }
    notifyListeners();
  }

  /// Removes all data from the user
  void reset() {
    id = null;
    name = null;
    surname = null;
    reachability = null;
    email = null;
    picture = null;
    seniority = null;
    description = null;
    isAdmin = null;
    notifyListeners();
  }

  @override
  String toString() {
    return '''
User:
  ID: $id
  Name: $name
  Surname: $surname
  Reachability: $reachability
  Email: $email
  Picture: $picture
  Seniority: $seniority
  Description: $description
    ''';
  }
}
