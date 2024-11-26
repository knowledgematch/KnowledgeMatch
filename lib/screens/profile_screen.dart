import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import the CreateProfileScreen file
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // To work with JSON
import 'package:shared_preferences/shared_preferences.dart'; // Import for shared preferences

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  String _reachability = '1'; // Default value, assuming reachable
  String _password = ''; // Password should be securely handled
  String? _picture = null; // Optional field for picture
  String _seniority = '0'; // Default to 0 if not specified
  String _uId = ''; // Will hold the U_ID of the logged-in user

  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers for fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _reachabilityController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from shared preferences or another source
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      print("__________");
      print(userData['U_ID']);
      print("__________");
      //set User ID
      _uId = userData['U_ID'].toString() ?? '';
      _password = userData['Password'].toString() ?? '';

      setState(() {
        _nameController.text = userData['Name']?.toString() ?? '';
        _surnameController.text = userData['Surname']?.toString() ?? '';
        _reachabilityController.text = userData['Reachability']?.toString() ?? '1';
        _emailController.text = userData['Email']?.toString() ?? '';
        _descriptionController.text = userData['Description']?.toString() ?? '';
      });
    } else {
      print('No user data found in SharedPreferences.');
    }
  }

  // Save profile information to the API and SharedPreferences
  Future<void> _saveProfile() async {
    final url = Uri.parse('http://86.119.45.62/users/$_uId');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'Name': _nameController.text,
      'Surname': _surnameController.text,
      'Reachability': _reachabilityController.text,
      'Email': _emailController.text,
      'Password': _password,
      'Picture': _picture, // This can be handled differently for images (base64 or URL)
      'Seniority': _seniority,
      'Description': _descriptionController.text,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 204) {
        // Successfully saved to the API
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );

        // Update the local shared preferences with the new data
        final prefs = await SharedPreferences.getInstance();
        final updatedUserData = {
          'U_ID': _uId,
          'Name': _nameController.text,
          'Surname': _surnameController.text,
          'Reachability': _reachabilityController.text,
          'Email': _emailController.text,
          'Password': _password,
          'Picture': _picture,
          'Seniority': _seniority,
          'Description': _descriptionController.text,
        };
        prefs.setString('userData', jsonEncode(updatedUserData));

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  // Handle user logout
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear saved user data

    // Navigate to login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Redirect to login screen
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
            onPressed: _logout, // Call logout when pressed
          ),
        ],
      ),
      body: SingleChildScrollView(  // Wrap the body in SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile.png'),
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
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

}
