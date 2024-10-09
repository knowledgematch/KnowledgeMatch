import 'package:flutter/material.dart';

import '../model/userprofile.dart';


class ProfileCard extends StatelessWidget {
  final Userprofile profile;

  ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Name Field
                  _ProfileInfoField(
                      label: 'Name',
                      value: profile.name,
                  ),
                  SizedBox(height: 10),

                  // Location Field
                  _ProfileInfoField(
                      label: 'Location',
                      value: profile.location,
                  ),
                  SizedBox(height: 10),

                  // Expertise Field
                  _ProfileInfoField(
                      label: 'Expert in',
                      value: profile.expertise.join(', '),
                  ),
                  SizedBox(height: 10),

                  // Availability Field
                  _ProfileInfoField(
                      label: 'Availability',
                      value: '18:30 - 19:30, Every Friday',
                  ),
                  SizedBox(height: 10),

                  // Language Field
                  _ProfileInfoField(
                      label: 'Languages',
                      value: 'German, English',
                  ),
                  SizedBox(height: 10),

                  _ProfileInfoField(
                      label: 'Description',
                      value: profile.description,
                  ),

                  SizedBox(height: 20),

                  // List View Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Action when button is pressed
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        backgroundColor: Colors.black, // Button color
                      ),
                      child: Text('List view'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _ProfileInfoField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5), // Space between label and value
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[300], // Background color of the box
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
