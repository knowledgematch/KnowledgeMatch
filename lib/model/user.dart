import 'dart:convert';
import 'dart:typed_data'; // Import for Uint8List

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
  String? picture; // This will hold the base64 string of the image
  int? seniority;
  String? description;

  // Populate the instance from JSON
  void populateFromJson(Map<String, dynamic> json) {
    id = json['U_ID'] as int?;
    name = json['Name'] as String?;
    surname = json['Surname'] as String?;
    reachability = json['Reachability'] as int?;
    email = json['Email'] as String?;

    // Store picture as a base64 string
    picture = json['Picture'] != null
        ? base64Encode((json['Picture']['data'] as List<dynamic>).cast<int>())
        : null;

    seniority = json['Seniority'] as int?;
    description = json['Description'] as String?;
  }

  // Method to decode the base64 string to Uint8List
  Uint8List? getDecodedPicture() {
    if (picture != null) {
      return base64Decode(picture!);
    }
    return null;
  }

  void setPicture(Uint8List? imageData) {
    if (imageData != null) {
      picture = base64Encode(imageData); // Encode Uint8List to Base64 string
    } else {
      picture = null; // Handle null case
    }
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
