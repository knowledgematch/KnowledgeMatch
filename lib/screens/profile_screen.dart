import 'package:flutter/material.dart';
import 'create_profile_screen.dart'; // Import the CreateProfileScreen file
import 'package:knowledgematch/services/db_connection.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Manuel Meier';
  String _location = 'Brugg';
  String _expertIn = 'SwaGI, Uuidc, Epmc';
  String _availability = '12:00 - 12:30, Every Wednesday';
  String _language = 'German';

  final _formKey = GlobalKey<FormState>();
  final dbConnection = DBConnection();

  Future<void> _saveProfile() async {
    final query = """
      INSERT INTO profiles (name, location, expert_in, availability, language)
      VALUES ('$_name', '$_location', '$_expertIn', '$_availability', '$_language')
      ON DUPLICATE KEY UPDATE
        location = '$_location', 
        expert_in = '$_expertIn', 
        availability = '$_availability', 
        language = '$_language';
    """;

    final result = await dbConnection.getSQLResponse(query);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save profile.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
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
                initialValue: _location,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _location = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _expertIn,
                decoration: const InputDecoration(
                  labelText: 'Expert in',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _expertIn = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _availability,
                decoration: const InputDecoration(
                  labelText: 'Availability',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _availability = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _language,
                decoration: const InputDecoration(
                  labelText: 'Language',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _language = value;
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateProfileScreen()),
          );
        },
        tooltip: 'Add Account',
        child: const Icon(Icons.add),
      ),
    );
  }
}
