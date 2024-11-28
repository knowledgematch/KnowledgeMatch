import 'package:flutter/material.dart';
import 'package:knowledgematch/services/api_db_connection.dart';
import '../model/user.dart';
import '../services/user_service.dart';
import 'login_screen.dart';
import 'change_pw_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final user = User.instance;
  String? _picture = null;
  String _seniority = '0';
  String _uId = '';

  final _formKey = GlobalKey<FormState>();

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
        _descriptionController.text = user.description!;
      });
    } else {
      print('No user data found in SharedPreferences.');
    }
  }

  Future<void> _saveProfile() async {
    final url = Uri.parse('http://86.119.45.62/users/$_uId');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'Name': _nameController.text,
      'Surname': _surnameController.text,
      'Reachability': _reachabilityController.text,
      'Email': _emailController.text,
      'Picture': _picture,
      'Seniority': _seniority,
      'Description': _descriptionController.text,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 204) {
        // After the successful update, store the updated user data in SharedPreferences
        final updatedUser = {
          'U_ID': _uId,
          'Name': _nameController.text,
          'Surname': _surnameController.text,
          'Reachability': _reachabilityController.text,
          'Email': _emailController.text,
          'Picture': _picture,
          'Seniority': _seniority,
          'Description': _descriptionController.text,
        };

        // Save the updated data in SharedPreferences and User Singleton
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', jsonEncode(updatedUser));
        await initializeUser(int.parse(_uId));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar( content: Text('Profile saved successfully!'),
                          duration: Duration(milliseconds: 500), ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar( content: Text('Failed to save profile: ${response.body}'),
                    duration: Duration(milliseconds: 500), ),
        );
      }
    } catch (error) {
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
