import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/user.dart';
import 'package:knowledgematch/ui/request/view_model/request_view_model.dart';
import 'package:provider/provider.dart';

class OnAcceptBottom extends StatelessWidget {
  const OnAcceptBottom({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestViewModel>();
    final isOpen = viewModel.notificationData.isOpen == true;
    bool isSentByMe =
        viewModel.notificationData.sourceUserId == User.instance.id;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Tooltip(
          message: 'Send meetup request',
          child: Semantics(
            button: true,
            enabled: isOpen && !isSentByMe,
            label: 'Send meetup request',
            hint:
                isOpen
                    ? 'Double-tap to send'
                    : 'Disabled until you pick at least one date',
            child: ElevatedButton(
              onPressed:
                  isOpen && !isSentByMe
                      ? () async {
                        if (viewModel.state.selectedDates.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please select at least one date!"),
                            ),
                          );
                          return;
                        }
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Meetup request sent!")),
                          );
                          Navigator.pop(context);
                        }
                        viewModel.proposeSelectedDates();
                      }
                      : null,
              child: const Text('Send'),
            ),
          ),
        ),
      ],
    );
  }
}
