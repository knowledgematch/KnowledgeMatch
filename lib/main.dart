import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
	try {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
		print('Firebase is working');
	} catch (e) {
		print('Firebase initialization error: $e');
	}
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profiles Swipe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}
