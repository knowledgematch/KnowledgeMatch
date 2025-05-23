import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/user.dart';
import 'package:knowledgematch/ui/request/view_model/request_view_model.dart';
import 'package:provider/provider.dart';

class OnRequestBottom extends StatelessWidget {
  const OnRequestBottom({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestViewModel>();
    bool isSentByMe =
        viewModel.notificationData.sourceUserId == User.instance.id;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed:
              (viewModel.notificationData.isOpen == true) &&
                      !isSentByMe //Check if the notificaion is still Open -> null if 'false' or null, which disables button
                  ? () async {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Request accepted.")),
                      );
                      Navigator.pop(context);
                    }
                    viewModel.acceptRequest();
                  }
                  : null,
          child: Text('Accept'),
        ),
        ElevatedButton(
          onPressed:
              (viewModel.notificationData.isOpen == true) && !isSentByMe
                  ? () async {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Request declined.")),
                      );
                      Navigator.pop(context);
                    }
                    viewModel.declineRequest();
                  }
                  : null,
          child: Text('Decline'),
        ),
      ],
    );
  }
}
