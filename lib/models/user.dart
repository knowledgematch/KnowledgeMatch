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
  String? picture;
  int? seniority;
  String? description;

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
        ? base64Encode((json['Picture']['data'] as List<dynamic>).cast<int>())
        : null;

    seniority = json['Seniority'] as int?;
    description = json['Description'] as String?;
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
