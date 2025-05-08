import 'dart:io';

class CreateProfileState {
  final bool isValid;
  final bool success;
  final String reachability;
  final File? selectedImage;

  CreateProfileState({
    this.isValid = false,
    this.success = false,
    this.reachability = '',
    this.selectedImage,
  });

  CreateProfileState copyWith({
    bool? isValid,
    bool? success,
    String? name,
    String? surname,
    String? email,
    String? password,
    String? reachability,
    File? selectedImage,
  }) {
    return CreateProfileState(
      isValid: isValid ?? this.isValid,
      success: success ?? this.success,
      reachability: reachability ?? this.reachability,
      selectedImage: selectedImage ?? this.selectedImage,
    );
  }
}
