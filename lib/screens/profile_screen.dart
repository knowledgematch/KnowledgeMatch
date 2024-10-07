import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {

          },
        ),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated!')),
                    );
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
