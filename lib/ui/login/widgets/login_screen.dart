import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/create_profile/view_model/create_profile_view_model.dart';
import 'package:knowledgematch/ui/login/view_model/login_view_model.dart';
import 'package:provider/provider.dart';

import '../../core/themes/app_colors.dart';
import '../../core/ui/custom_page.dart';
import '../../create_profile/widgets/create_profile_screen.dart';
import '../../two_fa/view_model/two_fa_view_model.dart';
import '../../two_fa/widgets/two_fa_screen.dart';
import '../reset_password_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<LoginViewModel>();
    return Scaffold(
      body: CustomPage(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: Image.asset(
                  "assets/images/Loginpicture_1.png",
                  fit: BoxFit.contain,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 24, color: AppColors.primary),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: viewModel.emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: viewModel.passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResetPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: AppColors.blackLight),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) => CreateProfileViewModel(),
                                  child: CreateProfileScreen(),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Create a new account',
                            style: TextStyle(color: AppColors.blackLight),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
