import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/core/ui/custom_page.dart';
import 'package:provider/provider.dart';
import 'package:knowledgematch/ui/two_fa/view_model/two_fa_view_model.dart';
import 'package:knowledgematch/ui/main/widgets/main_screen.dart';

class TwoFAScreen extends StatelessWidget {
  final String email;
  const TwoFAScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TwoFAViewModel>();
    viewModel.setEmail(email);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Enter Verification Code'),
        leading: IconButton(onPressed: () => Navigator.pop(context),icon: Icon(Icons.arrow_back)),
      ),
      body: CustomPage(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: viewModel.state.formKey,
            child: Column(
              children: [
                const Text('Check your (spam) email and enter the 2FA code below:'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: viewModel.state.codeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Verification Code',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter code' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (viewModel.state.formKey.currentState!.validate()) {
                        bool verified = await viewModel.verifyCode();
                        if (context.mounted) {
                          if (verified) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const MainScreen()),
                                  (Route<dynamic> route) => false,
                            );

                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid code')),
                            );
                          }
                        }
                      }
                    },
                    child: const Text('Verify'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
