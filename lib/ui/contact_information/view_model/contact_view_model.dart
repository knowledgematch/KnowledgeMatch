import 'package:flutter/cupertino.dart';
import 'package:knowledgematch/data/services/api_db_connection.dart';
import '../../../core/log.dart';
import '../../../domain/models/user.dart';
import '../contact_state.dart';

class ContactViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final messageController = TextEditingController();
  final api = ApiDbConnection();

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
  }) async {
    if (formKey.currentState!.validate()) {
      _state = _state.copyWith(isSending: true);
      notifyListeners();
      final message ='''
        Name: ${User.instance.name}
        Email: ${User.instance.email}

        Message:
        ${messageController.text}
        ''';

      bool response = await api.sendFeedback(message: message);
      if(response){
        logger.d('Message sent: $message');
        messageController.clear();
        onSuccess();
      } else{
        logger.e('Message not sent. Error');
        onFailure();
      }
      _state = _state.copyWith(isSending: false);
      notifyListeners();

    }
  }
}
