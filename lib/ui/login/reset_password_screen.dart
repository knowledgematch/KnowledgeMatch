import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/core/ui/custom_page.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isSending = false;

  Future<void> _sendResetEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email.")),
      );
      return;
    }

    setState(() => _isSending = true);



    // TODO   ....... HIER MUSS GEäNDERT WERDEN--------------------------




  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: CustomPage(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Your email"),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSending ? null : _sendResetEmail,
                child: _isSending
                    ? const CircularProgressIndicator()
                    : const Text("Send Reset Link"),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
