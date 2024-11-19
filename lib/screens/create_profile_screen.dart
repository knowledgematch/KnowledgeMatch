import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _surname = '';
  int _reachability = 1; // Default value
  String _email = '';
  String _credentials = '';

  // Method to send profile data to the API
  Future<void> _createProfile() async {
    final url = Uri.parse('http://86.119.45.62/users');
    final body = jsonEncode({
      "Name": _name,
      "Surname": _surname,
      "Reachability": _reachability,
      "Email": _email,
      "Credentials": _credentials,
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile created successfully!')),
        );
        Navigator.pushReplacementNamed(context, '/main'); // Replace with your main screen route
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create profile: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Surname',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _surname = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Surname is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _reachability,
                decoration: const InputDecoration(
                  labelText: 'Reachability',
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: 0, child: Text('Unavailable')),
                  DropdownMenuItem(value: 1, child: Text('Available')),
                  DropdownMenuItem(value: 2, child: Text('Busy')),
                ],
                onChanged: (value) => setState(() {
                  _reachability = value!;
                }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _email = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Credentials',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _credentials = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Credentials are required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createProfile(); // Call the method to create a profile
                  }
                },
                child: const Text('Create Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
