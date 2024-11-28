import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knowledgematch/services/api_db_connection.dart';
import '../model/user.dart';
import '../services/user_service.dart';
import 'login_screen.dart';
import 'change_pw_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final user = User.instance;
  Uint8List? _pictureData; // Store the picture as Uint8List
  String _seniority = '0';
  String _uId = '';

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _reachabilityController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Function to handle image picking
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final fileBytes = await pickedFile.readAsBytes();
      setState(() {
        _pictureData = fileBytes; // Update picture data for display
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      _uId = userData['U_ID'].toString();

      setState(() {
        _nameController.text = user.name!;
        _surnameController.text = user.surname!;
        _reachabilityController.text = user.reachability!.toString();
        _emailController.text = user.email!;
        _descriptionController.text = user.description ?? '';
        _pictureData = user.getDecodedPicture();
      });
    } else {
      print('No user data found.');
    }
  }

  Future<void> _saveProfile() async {
    print(_uId);
    final uri = Uri.parse('http://86.119.45.62/users/$_uId');
    final request = http.MultipartRequest('PUT', uri);

    // Ensure required fields are added to the request
    request.fields['Name'] = _nameController.text;
    request.fields['Surname'] = _surnameController.text;
    request.fields['Reachability'] = _reachabilityController.text;
    request.fields['Email'] = _emailController.text;
    request.fields['Seniority'] = _seniority;
    request.fields['Description'] = _descriptionController.text;

    // Add the image file to the request if it exists
    if (_pictureData != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'Picture', // This key should match your backend field
        _pictureData!,
        filename: 'profile_picture.jpg', // Providing a filename
        contentType: MediaType('image', 'jpeg'), // Specify the correct content type
      ));
    }

    // Debugging: Log the fields being sent
    print('Sending request with fields: ${request.fields}');

    try {
      final response = await request.send();

      if (response.statusCode == 204) {
        // Profile updated successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar( content: Text('Profile saved successfully!'),
                          duration: Duration(milliseconds: 500), ),
        );

        // Optionally update SharedPreferences or local user state here
        // Update the user instance with new values
        user.name = _nameController.text;
        user.surname = _surnameController.text;
        user.reachability = int.tryParse(_reachabilityController.text);
        user.email = _emailController.text;
        user.description = _descriptionController.text;
        user.setPicture(_pictureData);

        // Encode user data to JSON and save it in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', jsonEncode({
          'U_ID': _uId,
          'Name': user.name,
          'Surname': user.surname,
          'Reachability': user.reachability,
          'Email': user.email,
          'Description': user.description,
          // Assuming you might want to save the picture data as well
        }));
      } else {
        // Read and log the response body for debugging
        final responseBody = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(
          //SnackBar(content: Text('Failed to save profile: ${response.reasonPhrase}, Body: $responseBody')),
          SnackBar( content: Text('Failed to save profile: ${response.reasonPhrase}, Body: $responseBody'),
                    duration: Duration(milliseconds: 500), ),
        );
      }
    } catch (error) {
      // Handle network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar( content: Text('Error: $error'),
                  duration: Duration(milliseconds: 500), ),
      );
    }
  }


  Future<void> _logout() async {
    ApiDbConnection().deleteFcmToken(User.instance.id ?? 0);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    User.instance.reset();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _logout();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Logged out successfully'),
                  duration: Duration(milliseconds: 500),
                ),
              );
            }
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage, // Trigger image picker when tapped
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _pictureData != null
                        ? MemoryImage(_pictureData!) // Use MemoryImage to display Uint8List
                        : const AssetImage('assets/images/profile.png') as ImageProvider,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _surnameController,
                  decoration: const InputDecoration(
                    labelText: 'Surname',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _reachabilityController,
                  decoration: const InputDecoration(
                    labelText: 'Reachability',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 100, // Set height for description box
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: null, // Allow text to wrap within the box
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveProfile();
                    }
                  },
                  child: const Text('Save Changes'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                    );
                  },
                  child: const Text('Change Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
