import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class User {
  // Singleton instance
  static final User _instance = User._privateConstructor();

  // Private constructor
  User._privateConstructor();

  // Getter for the singleton instance
  static User get instance => _instance;

  // Properties
  int? id;
  String? name;
  String? surname;
  int? reachability;
  String? email;
  String? picture;
  int? seniority;
  String? description;

  // Populate the instance from JSON
  void populateFromJson(Map<String, dynamic> json) {
    id = json['U_ID'] as int?;
    name = json['Name'] as String?;
    surname = json['Surname'] as String?;
    reachability = json['Reachability'] as int?;
    email = json['Email'] as String?;
    picture = json['Picture'] != null
        ? String.fromCharCodes((json['Picture']['data'] as List<dynamic>).cast<int>())
        : null;
    seniority = json['Seniority'] as int?;
    description = json['Description'] as String?;
  }

  void reset() {
    id = null;
    name = null;
    surname = null;
    reachability = null;
    email = null;
    picture = null;
    seniority = null;
    description = null;
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
