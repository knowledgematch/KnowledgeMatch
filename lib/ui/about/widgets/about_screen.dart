import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/fhnw_logo.png',
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              const Text(
                'This app is a student project aimed at helping others with various topics. The founders are students from the University of Applied Sciences and Arts Northwestern Switzerland (FHNW).',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                'For inquiries: Please use the contact form.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Disclaimer:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "The content provided in the app is for informational purposes only. The app's creators are not responsible for any incorrect or incomplete information shared by users.",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                '© 2025, KnowledgeMatch. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'The content, design, and code of this app are protected by copyright laws. Unauthorized use, distribution, or reproduction of any part of the app is prohibited without explicit permission from the creators.',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ClipOval(
                  child: Image.asset('assets/images/logo.png', width: 90),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
