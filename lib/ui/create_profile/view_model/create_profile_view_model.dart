import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knowledgematch/data/services/api_db_connection.dart';
import 'package:knowledgematch/ui/create_profile/create_profile_state.dart';

import '../../../domain/models/reachability.dart';

class CreateProfileViewModel extends ChangeNotifier {
  CreateProfileState _state;

  CreateProfileState get state => _state;

  CreateProfileViewModel() : _state = CreateProfileState();

  final ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  /// Opens the gallery to pick an image and updates the selected image.
  ///
  /// This method uses the image picker to open the device's gallery and allow the user
  /// to select an image. If an image is selected, the selected image is stored in the
  /// `_selectedImage` variable as a [File]. If no image is selected, a message is logged.
  ///
  /// Returns:
  /// - A [Future] that completes when the image selection process is finished.
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _state = state.copyWith(selectedImage: File(pickedFile.path));
      notifyListeners();
    } else {
      print('No image selected.');
    }
  }

  /// Handles the account creation process.
  ///
  /// Validates the form and attempts to create a new account by calling
  /// [ApiDbConnection().createAccount]. If the account creation is successful,
  /// a success dialog is shown. If there is an error, an error dialog is shown.
  Future<void> createAccount() async {
    _state = state.copyWith(
      isValid: false,
      success: false,
    );
    final valid =
        await ApiDbConnection().isEmailDomainValid(emailController.text);
    _state = state.copyWith(isValid: valid);
    notifyListeners();

    if (valid) {
      final response = await ApiDbConnection().createAccount(
        nameController.text,
        surnameController.text,
        emailController.text,
        passwordController.text,
        Reachability.onlineOrInPerson.value.toString(),
        state.selectedImage,
      );

      if (response == 200) {
        _state = state.copyWith(success: true);
        notifyListeners();
      }
    }
  }
  void initReachability() {
    _state =
        state.copyWith(reachability: Reachability.inPerson.value.toString());
    notifyListeners();
  }
}
