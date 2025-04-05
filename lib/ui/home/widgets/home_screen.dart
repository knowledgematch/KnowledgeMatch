import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/core/ui/app_drawer.dart';

import '../../core/themes/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Home Screen!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {}, //TODO add navigation to find matches
              child: Text(
                'Get Started',
                style: TextStyle(color: AppColors.whiteLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
