import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/contact_information/view_model/contact_view_model.dart';
import 'package:provider/provider.dart';
import '../../core/themes/app_colors.dart';
import '../../thank/widget/thank_screen.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ContactViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Let us know your questions, suggestions and concerns by filling out the contact form below.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Form(
                key: viewModel.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Message',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: viewModel.messageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 8,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your message';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: viewModel.state.isSending
                          ? null
                          : () async {
                        await viewModel.sendEmail(
                          onSuccess: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ThankYouScreen(),
                              ),
                            );
                          },
                          onFailure: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to send message. Please try again later.'),
                                backgroundColor: AppColors.redLight,
                              ),
                            );
                          },
                          onError: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('An error occurred. Please try again later.'),
                                backgroundColor: AppColors.redLight,
                              ),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: viewModel.state.isSending
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteLight),
                        ),
                      )
                          : const Text(
                        'Send',
                        style: TextStyle(color: AppColors.whiteLight),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
