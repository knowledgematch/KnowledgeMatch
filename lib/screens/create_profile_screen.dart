import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/reachability.dart';
import 'login_screen.dart';

class CreateProfileScreen extends StatefulWidget {
  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _surname = '';
  String _email = '';
  String _password = '';
  String _reachability = Reachability.inPerson
      .toString(); //TODO change to actual user preference?!
  File? _selectedImage; // To store the selected profile picture

  final ImagePicker _picker = ImagePicker();

  // Function to handle image picking
  Future<void> _pickImage() async {
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

  // Function to handle account creation
  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate()) {
      try {
        final uri = Uri.parse('http://86.119.45.62/users');
        final request = http.MultipartRequest('POST', uri);

        // Add text fields to the request
        request.fields['Name'] = _name;
        request.fields['Surname'] = _surname;
        request.fields['Email'] = _email;
        request.fields['Password'] = _password;
        request.fields['Reachability'] = _reachability;

        // Add the image file to the request if selected
        if (_selectedImage != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'Picture', // This key should match your backend field
            _selectedImage!.path,
          ));
        }

        final response = await request.send();

        if (response.statusCode == 200) {
          // Account created successfully
          final responseBody = await response.stream.bytesToString();
          final responseData = jsonDecode(responseBody);

          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Success'),
              content: Text('Account created successfully!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.pop(context); // Go back to login screen
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Error in account creation
          final responseBody = await response.stream.bytesToString();
          final errorResponse = jsonDecode(responseBody);
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Error'),
              content: Text(errorResponse['message'] ?? 'An error occurred'),
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
      } catch (e) {
        print('Error: $e');
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred, please try again later.'),
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

  // Function to go back to the login screen
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
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : AssetImage('assets/images/profile.png')
                            as ImageProvider,
                    child: _selectedImage == null
                        ? Icon(Icons.camera_alt, size: 50, color: Colors.grey)
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
                  child: Text('Create Account'),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: _goToLoginScreen,
                  child: Text('Already have an account? Log in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
