import 'dart:typed_data';

import '../../domain/models/reachability.dart';

class ProfileState {
  Uint8List? pictureData;
  String uId = '';
  Reachability reachability = Reachability.inPerson;
  int semester = 1;
  String description = '';
  bool unsaved;

  ProfileState({
      this.pictureData,
      required this.uId,
      required this.reachability,
      required this.semester,
      required this.description,
      this.unsaved = false,
  });

  ProfileState copyWith({
    Uint8List? pictureData,
    String? uId,
    Reachability? reachability,
    int? semester,
    String? description,
    bool? unsaved
  }) {
    return ProfileState(
      pictureData: pictureData ?? this.pictureData,
      uId: uId ?? this.uId,
      reachability: reachability ?? this.reachability,
      semester: semester ?? this.semester,
      description: description ?? this.description,
      unsaved: unsaved ?? this.unsaved,
    );
  }
}
