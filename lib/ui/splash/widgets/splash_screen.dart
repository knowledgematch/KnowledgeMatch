import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../login/view_model/login_view_model.dart';
import '../../login/widgets/login_screen.dart';
import '../../main/widgets/main_screen.dart';
import '../view_model/splash_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SplashViewModel>();
    final loginState = viewModel.state.isLoggedIn;

    /// Use a post frame callback to navigate only once when the state is updated.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (loginState == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      } else if (loginState == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => LoginViewModel(),
              child: const LoginScreen(),
            ),
          ),
        );
      }
    });

    //TODO import flutter_native_splash to create the standard android splash loading screen with logo
    // Display a loading indicator while waiting.
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
