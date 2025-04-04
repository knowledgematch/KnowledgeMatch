import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knowledgematch/data/services/api_db_connection.dart';
import 'package:knowledgematch/domain/models/reachability.dart';

import '../../theme/colors.dart';
import '../login/login_screen.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  CreateProfileScreenState createState() => CreateProfileScreenState();
}

class CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _surname = '';
  String _email = '';
  String _password = '';
  String _reachability = Reachability.inPerson.value.toString();
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  /// Opens the gallery to pick an image and updates the selected image.
  ///
  /// This method uses the image picker to open the device's gallery and allow the user
  /// to select an image. If an image is selected, the selected image is stored in the
  /// `_selectedImage` variable as a [File]. If no image is selected, a message is logged.
  ///
  /// Returns:
  /// - A [Future] that completes when the image selection process is finished.
  Future<void> _pickImage() async {
    //TODO move methods to a service/model class
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  /// Handles the account creation process.
  ///
  /// Validates the form and attempts to create a new account by calling
  /// [ApiDbConnection().createAccount]. If the account creation is successful,
  /// a success dialog is shown. If there is an error, an error dialog is shown.
  //TODO move methods to a service/model class
  void _createAccount() async {
    if (_formKey.currentState!.validate()) {
      final response = await ApiDbConnection().createAccount(
        _name,
        _surname,
        _email,
        _password,
        _reachability,
        _selectedImage,
      );

      if (!mounted) return;

      if (response == 200) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Success'),
            content: Text('Account created successfully!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  /// Function to go back to the login screen
  void _goToLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.grey2Light,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : AssetImage('assets/images/profile.png')
                            as ImageProvider,
                    child: _selectedImage == null
                        ? Icon(Icons.camera_alt,
                            size: 50, color: AppColors.greyLight)
                        : null,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    _name = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Surname'),
                  onChanged: (value) {
                    _surname = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your surname';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (value) {
                    _email = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onChanged: (value) {
                    _password = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<Reachability>(
                  value: ReachabilityValue.fromValue(int.parse(_reachability)),
                  onChanged: (Reachability? newValue) {
                    setState(() {
                      _reachability = newValue!.value.toString();
                    });
                  },
                  items: Reachability.values.map((Reachability reachability) {
                    return DropdownMenuItem<Reachability>(
                      value: reachability,
                      child: Text(reachability.description),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Reachability'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createAccount,
                  child: Text('Create Account',
                      style: TextStyle(color: AppColors.whiteLight)),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: _goToLoginScreen,
                  child: Text('Already have an account? Log in',
                      style: TextStyle(color: AppColors.blackLight)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
