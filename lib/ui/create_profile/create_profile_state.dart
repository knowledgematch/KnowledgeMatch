import 'dart:io';

class CreateProfileState {
  final bool isValid;
  final bool success;
  final File? selectedImage;

  CreateProfileState({
    this.isValid = false,
    this.success = false,
    this.selectedImage,
  });

  CreateProfileState copyWith({
    bool? isValid,
    bool? success,
    String? reachability,
    File? selectedImage,
  }) {
    return CreateProfileState(
      isValid: isValid ?? this.isValid,
      success: success ?? this.success,
      selectedImage: selectedImage ?? this.selectedImage,
    );
  }
}
