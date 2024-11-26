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
  String _name = '';
  String _surname = '';
  String _reachability = '1'; // Default value, assuming reachable
  String _email = '';
  String _password = ''; // Password should be securely handled
  String? _picture = null; // Optional field for picture
  String _seniority = '0'; // Default to 0 if not specified
  String _description = ''; // Optional description
  String _uId = ''; // Will hold the U_ID of the logged-in user

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from shared preferences or another source
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load user-specific data
    String? name = prefs.getString('Name');
    print('Name + $name');
    String? surname = prefs.getString('surname');
    String? reachability = prefs.getString('reachability');
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    String? picture = prefs.getString('picture');
    String? seniority = prefs.getString('seniority');
    String? description = prefs.getString('description');

    // Load the current user's ID (U_ID)
    String? userId = prefs.getString('u_id');

    if (userId != null) {
      setState(() {
        _uId = userId; // Set the user ID
      });
    }

    if (name != null && surname != null && reachability != null && email != null) {
      setState(() {
        _name = name;
        _surname = surname;
        _reachability = reachability;
        _email = email;
        _password = password ?? ''; // Default empty string if null
        _picture = picture;
        _seniority = seniority ?? '0';
        _description = description ?? '';
      });
    }
  }

  // Save profile information to the API
  Future<void> _saveProfile() async {
    final url = Uri.parse('http://your-api-url/users/$_uId'); // Use the correct URL for your API endpoint
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'Name': _name,
      'Surname': _surname,
      'Reachability': _reachability,
      'Email': _email,
      'Password': _password,
      'Picture': _picture, // This can be handled differently for images (base64 or URL)
      'Seniority': _seniority,
      'Description': _description,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );
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
      body: Padding(
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
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _surname,
                decoration: const InputDecoration(
                  labelText: 'Surname',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _surname = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _reachability,
                decoration: const InputDecoration(
                  labelText: 'Reachability',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _reachability = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _password,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true, // Password should be hidden
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
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
    );
  }
}
