import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:knowledgematch/ui/forgot_pw/view_model/forgot_pw_view_model.dart';

class ForgotPwScreen extends StatelessWidget {
  const ForgotPwScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ForgotPwViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: viewModel.state.formKey,
          child: Column(
            children: [
              const Text('Enter your email to receive a new password:'),
              const SizedBox(height: 16),
              TextFormField(
                controller: viewModel.state.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter an email' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (viewModel.state.formKey.currentState!.validate()) {
                    final success = await viewModel.requestNewPassword();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success
                              ? 'New password sent to your email.'
                              : 'Error sending password.'),
                        ),
                      );
                      if (success) Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Send New Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
