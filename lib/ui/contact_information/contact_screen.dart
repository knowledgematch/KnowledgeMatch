import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/themes/app_colors.dart';
import '../thank/widget/thank_screen.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
    String username =
        'sender.knowledge.app@gmail.com'; //TODO hide login data & pw
    String password = "plwl drkb ymfa smpn";
    String name = "KnowledgeMatch Contact Form";
    String email = username;

    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final userData = jsonDecode(userDataString);

      // Accessing using bracket notation
      name = userData['Name'];
      email = userData['Email'];
    }

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'KnowledgeMatch Contact Form')
      ..recipients.add('fhnw.knowledge.match@gmail.com')
      ..subject = 'New Contact Form Submission from $name'
      ..text = '''
              Name: $name
              Email: $email

              Message:
              ${_messageController.text}
              ''';

    try {
      setState(() {
        _isSending = true;
      });

      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');

      _messageController.clear();

      // Navigate to thank you screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ThankYouScreen(),
          ),
        );
      }
    } on MailerException catch (e) {
      print('Message not sent. Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send message. Please try again later.'),
            backgroundColor: AppColors.redLight,
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again later.'),
            backgroundColor: AppColors.redLight,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _sendEmail();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Message',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _messageController,
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
                      onPressed: _isSending ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: _isSending
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.whiteLight),
                              ),
                            )
                          : const Text(
                              'Send',
                              style: TextStyle(color: AppColors.whiteLight),
                            ),
                    ),
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
