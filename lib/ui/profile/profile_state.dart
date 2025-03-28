import 'dart:typed_data';

import '../../domain/models/reachability.dart';

class ProfileState {
  Uint8List? pictureData;
  String uId = '';
  Reachability reachability = Reachability.inPerson;
  int semester = 1;

  ProfileState({
      this.pictureData,
      required this.uId,
      required this.reachability,
      required this.semester});

  ProfileState copyWith({
    Uint8List? pictureData,
    String? uId,
    Reachability? reachability,
    int? semester,
  }) {
    return ProfileState(
      pictureData: pictureData ?? this.pictureData,
      uId: uId ?? this.uId,
      reachability: reachability ?? this.reachability,
      semester: semester ?? this.semester,
    );
  }
}
