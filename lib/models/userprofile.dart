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
  //TODO add email address

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
  })  : expertise = expertString.split(" "),
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
}
