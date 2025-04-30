import 'dart:convert';
import 'dart:typed_data';

import 'reachability.dart';

class Userprofile {
  final int id;
  final String name;
  final String location;
  final List<String> expertise;
  final String availability;
  final List<String> languages;
  final Reachability? reachability;
  final String description;
  final int seniority;
  Uint8List? picture;
  List<String>? tokens = [];
  final String email;

  Userprofile({
    required this.id,
    required this.name,
    required this.location,
    required String expertString,
    required this.availability,
    required String langString,
    this.reachability,
    required this.description,
    this.tokens,
    required this.seniority,
    required this.email,
    this.picture,
  }) : expertise = expertString.split(" "),
       languages = langString.split(" ");

  /// Returns a [List] of [String] tokens
  List<String>? getTokensList() {
    return tokens;
  }

  /// Saves a base64-encoded [String] as a [Uint8List] in [picture]
  void setPicture(String picture) {
    this.picture = base64Decode(picture);
  }

  /// Returns [Uint8List] in [picture]
  Uint8List? getPicture() {
    return picture;
  }

  /// Creates a [Userprofile] object from a JSON [Map].
  ///
  /// This method parses the provided [user] map and converts it into a [Userprofile] object.
  /// It also processes any associated tokens and picture data.
  ///
  /// Parameters:
  /// - [user]: A map containing user data to be converted.
  ///
  /// Returns:
  /// - A [Userprofile] object populated with the parsed data from the map.
  factory Userprofile.fromJson(Map<String, dynamic> user) {
    List<String> tokenList = [];
    if (user['Tokens'] != null && user['Tokens'].toString().trim().isNotEmpty) {
      tokenList =
          user['Tokens']
              .toString()
              .split(',')
              .map<String>((token) => token.trim())
              .toList();
    }

    Uint8List? pic;
    final picData = user['Picture']?['data'];
    if (picData is List) {
      pic = Uint8List.fromList(picData.cast<int>());
    }

    return Userprofile(
      id: int.parse(user['U_ID'].toString()),
      seniority: int.parse(user['Seniority'].toString()),
      name: user['FullName'].toString(),
      location: 'Placeholder',
      expertString: user['Keywords'].toString(),
      availability: 'Placeholder',
      langString: 'Placeholder',
      reachability: ReachabilityValue.fromValue(
        int.parse(user['Reachability'].toString()),
      ),
      description: user['Description'].toString(),
      tokens: tokenList,
      email: user['Email'].toString(),
      picture: pic,
    );
  }
}
