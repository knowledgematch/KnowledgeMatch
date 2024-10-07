import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Manuel Meier',
                enabled: false,
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 16),

            // Location
            Text("Location"),
            TextField(
              decoration: InputDecoration(
                labelText: 'Brugg',
                enabled: false,
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 16),

            // Expertise
            Text("Expert in"),
            TextField(
              decoration: InputDecoration(
                labelText: 'SwaGl, Uuidc, Epmc',
                enabled: false,
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 16),

            // Availability
            Text("Availability"),
            TextField(
              decoration: InputDecoration(
                labelText: '12:00 - 12:30, Every Wednesday',
                enabled: false,
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 16),

            // Language
            Text("Language"),
            TextField(
              decoration: InputDecoration(
                labelText: 'German',
                enabled: false,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
