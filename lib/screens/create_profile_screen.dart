import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for json encoding

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
  String _reachability = '1'; // Default to some reachability (you can change this)

  // Function to handle account creation
  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, try to create the account
      try {
        final response = await http.post(
          Uri.parse('http://86.119.45.62/users'), // Replace with your actual API URL
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'Name': _name,
            'Surname': _surname,
            'Email': _email,
            'Password': _password,
            'Reachability': _reachability,
          }),
        );

        if (response.statusCode == 200) {
          // Account created successfully
          final responseData = json.decode(response.body);
          // You can display a success message or navigate to another screen
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
          final errorResponse = json.decode(response.body);
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
          child: Column(
            children: <Widget>[
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
              DropdownButtonFormField<String>(
                value: _reachability,
                onChanged: (String? newValue) {
                  setState(() {
                    _reachability = newValue!;
                  });
                },
                items: [
                  DropdownMenuItem(value: '1', child: Text('Reachable')),
                  DropdownMenuItem(value: '0', child: Text('Not Reachable')),
                ],
                decoration: InputDecoration(labelText: 'Reachability'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createAccount,
                child: Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
