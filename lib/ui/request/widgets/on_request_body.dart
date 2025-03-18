import 'package:flutter/material.dart';

import '../view_model/request_view_model.dart';

class OnRequestBody extends StatelessWidget {
  const OnRequestBody({super.key, required this.viewModel});

  final RequestViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
              title: Text(
                "New Knowledge request",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(Icons.question_mark_rounded,
                  color: Colors.orange, size: 40)),
        ),

        SizedBox(height: 24),
        Text(
          'Problem description:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              viewModel.state.searchCriteria.issue,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        Spacer(),

        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: viewModel.notificationData.isOpen ==
                      true //Check if the notificaion is still Open -> null if 'false' or null, which disables button
                  ? () async {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Request accepted.")));
                        Navigator.pop(context);
                      }
                      viewModel.acceptRequest();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Accept',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: viewModel.notificationData.isOpen == true
                  ? () async {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Request declined.")));
                        Navigator.pop(context);
                      }
                      viewModel.declineRequest();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Decline',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
