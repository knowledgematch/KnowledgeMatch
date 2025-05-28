import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/log.dart';
import '../contact_state.dart';

class ContactViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final messageController = TextEditingController();

  ContactState _state = ContactState();

  ContactState get state => _state;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> sendEmail({
    required Future<void> Function() onSuccess,
    required Future<void> Function() onFailure,
    required Future<void> Function() onError,
  }) async {
    if (formKey.currentState!.validate()) {
      String username = 'sender.knowledge.app@gmail.com';
      String password = "plwl drkb ymfa smpn";
      String name = "KnowledgeMatch Contact Form";
      String email = username;

      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('userData');

      if (userDataString != null) {
        final userData = jsonDecode(userDataString);
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
        ${messageController.text}
        ''';

      try {
        _state = _state.copyWith(isSending: true);
        notifyListeners();

        final sendReport = await send(message, smtpServer);
        logger.d('Message sent: $sendReport');

        messageController.clear();
        onSuccess();
      } on MailerException catch (e) {
        logger.e('Message not sent. Error: $e');
        onFailure();
      } catch (e) {
        logger.e('Error: $e');
        onError();
      } finally {
        _state = _state.copyWith(isSending: false);
        notifyListeners();
      }
    }
  }
}
