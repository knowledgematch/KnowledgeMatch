import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

class Userprofile {
  final int id;
  final String name;
  final String location;
  final List<String> expertise;
  final String availability;
  final List<String> languages;
  final int? reachability;
  final String description;
  final int seniority;
  String? picture;
  List<String>? tokens = [];

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
  }) :  expertise = expertString.split(" "),
        languages = langString.split(" ");

  List<String>? getTokensList(){
    return tokens;
  }

  void setPicture(String? picture){
    this.picture = picture;
  }

  Uint8List? getDecodedPicture() {
    if (picture != null) {
      print(picture);
      return base64Decode(picture!);
    }
    return null;
  }
}