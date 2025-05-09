import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/login/view_model/login_view_model.dart';
import 'package:provider/provider.dart';

import '../../core/themes/app_colors.dart';
import '../../create_profile/widgets/create_profile_screen.dart';
import '../../forgot_pw/view_model/forgot_pw_view_model.dart';
import '../../forgot_pw/widgets/forgot_pw_screen.dart';
import '../../two_fa/view_model/two_fa_view_model.dart';
import '../../two_fa/widgets/two_fa_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: viewModel.emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: viewModel.passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider(
                        create: (_) => ForgotPwViewModel(),
                        child: ForgotPwScreen(),
                      ),
                    ),
                  );
                },
                child: Text('Forgot Password?',
                    style: TextStyle(color: AppColors.blackLight)),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateProfileScreen()),
                );
              },
              child: Text('Create a new account',
                  style: TextStyle(color: AppColors.blackLight)),
            ),
            ElevatedButton(
              onPressed: viewModel.state.isLoading
                  ? null
                  : () async {
                      await viewModel.login();

                      if (!context.mounted) return;

                      if (viewModel.state.loginSuccess == true) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider(
                              create: (_) => TwoFAViewModel(),
                              child: TwoFAScreen(
                                  email: viewModel.emailController.text),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(viewModel.state.errorMessage!)),
                        );
                      }
                    },
              child: viewModel.state.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login',
                      style: TextStyle(color: AppColors.whiteLight)),
            ),
          ],
        ),
      ),
    );
  }
}
