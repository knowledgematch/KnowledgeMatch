import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/services/api_db_connection.dart';
import '../../../domain/models/reachability.dart';
import '../../../domain/models/user.dart';
import '../profile_state.dart';

class ProfileViewModel extends ChangeNotifier{

  final user = User.instance;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  ProfileState _state;

  ProfileState get state => _state;


  ProfileViewModel()
      :_state = ProfileState(uId: "", reachability: Reachability.inPerson, semester: 1);


  void changeSemester(int semester){
    _state = _state.copyWith(semester: semester);
    notifyListeners();
  }

  /// Opens the gallery to pick an image, compresses it, and updates the selected image data.
  ///
  /// This method allows the user to pick an image from the gallery, reads the image as bytes,
  /// compresses it to a target size (in kilobytes), and updates the state with the compressed
  /// image data.
  ///
  /// Parameters:
  /// - This method does not take any parameters. It uses the image picker to allow the user
  ///   to select and compress an image.
  ///
  /// Returns:
  /// - This method does not return anything.
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final fileBytes = await pickedFile.readAsBytes();
      const targetSizeInKB = 100;
      final compressedBytes =
      await compressImageToTargetSize(fileBytes, targetSizeInKB * 1024);
      _state = _state.copyWith(pictureData: compressedBytes);
      notifyListeners();
    }
  }

  /// Compresses an image to a target size in bytes.
  ///
  /// This method takes an image's byte data and compresses it iteratively to reduce its size
  /// until it meets the target size, adjusting the quality in each iteration. The compression
  /// stops once the target size is achieved or the quality reaches a minimum threshold.
  ///
  /// Parameters:
  /// - [fileBytes]: The byte data of the image to compress.
  /// - [targetSizeInBytes]: The target size in bytes for the compressed image.
  ///
  /// Returns:
  /// - A [Future] that completes with the compressed image byte data ([Uint8List]).
  Future<Uint8List> compressImageToTargetSize(
      Uint8List fileBytes, int targetSizeInBytes) async {
    int quality = 100;
    Uint8List compressedBytes = fileBytes;
    while (compressedBytes.length > targetSizeInBytes && quality > 10) {
      compressedBytes = await FlutterImageCompress.compressWithList(
        fileBytes,
        quality: quality,
        minWidth: 300,
        minHeight: 300,
      );
      quality -= 10;
    }
    return compressedBytes;
  }

  /// Loads the user data from shared preferences and updates the UI.
  ///
  /// This method retrieves the stored user data from shared preferences, decodes it, and updates
  /// the relevant fields in the UI, such as user name, email, semester, description, and picture.
  ///
  /// Parameters:
  /// - This method does not take any parameters. It uses the stored user data in shared preferences.
  ///
  /// Returns:
  /// - This method does not return anything.
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      _state =_state.copyWith(uId: userData['U_ID'].toString());

        nameController.text = user.name!;
        surnameController.text = user.surname!;
        _state = _state.copyWith(reachability: ReachabilityValue.fromValue(user.reachability ?? 0));
        emailController.text = user.email!;
        _state.copyWith(semester: user.seniority);
        descriptionController.text = user.description ?? '';
        _state = _state.copyWith(pictureData: user.getDecodedPicture());
        notifyListeners();
    }
  }

  /// Saves the user's profile data to the database and shared preferences.
  ///
  /// This method sends the updated user profile data to the server via the API. If the save operation is successful,
  /// it updates the local user object and shared preferences with the new profile data. If the operation fails,
  /// it displays an error message to the user.
  ///
  /// Parameters:
  /// - This method does not take any parameters. It uses the current values from the controllers and state variables.
  ///
  /// Returns:
  /// - This method does not return anything.
  Future<void> saveProfile(BuildContext context) async {
    try {
      final response = await ApiDbConnection().saveProfile(
          _state.uId,
          nameController.text,
          surnameController.text,
          _state.reachability.value.toString(),
          emailController.text,
          _state.semester.toString(),
          descriptionController.text,
          _state.pictureData);
      if (response == 204) {
       if (context.mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
         );
       }

        user.name = nameController.text;
        user.surname = surnameController.text;
        user.reachability = _state.reachability.value;
        user.email = emailController.text;
        user.seniority = _state.semester;
        user.description = descriptionController.text;
        user.setPicture(_state.pictureData);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'userData',
            jsonEncode({
              'U_ID': _state.uId,
              'Name': user.name,
              'Surname': user.surname,
              'Reachability': user.reachability,
              'Email': user.email,
              'Description': user.description,
            }));
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save profile')),
          );
        }
      }
    } catch (error) {
      if (context.mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Error:')),
         );
       }
    }
  }
}