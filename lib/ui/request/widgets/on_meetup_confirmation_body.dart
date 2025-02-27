import 'package:flutter/material.dart';

import '../view_model/request_view_model.dart';

class OnMeetupConfirmationBody extends StatelessWidget {
  const OnMeetupConfirmationBody({super.key, required this.viewModel});
  final RequestViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel.closeRequestDelegate();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(
          ' Meetup Confirmation:',
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
            child: ListTile(
                title: Text(
                  'Your confirmed meetup details:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(viewModel.notificationData.body),
                trailing:
                    Icon(Icons.date_range, color: Colors.green, size: 40)),
          ),
        ),
        SizedBox(height: 8),
        Text(
          ' Keep in touch:',
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
            child: ListTile(
                onTap: () async {
                  viewModel.forwardToTeamsDelegate();
                },
                title: Text(
                  'Link to ${viewModel.userprofile.name}\'s Teams Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(viewModel.userprofile.email),
                trailing: Icon(Icons.chat, color: Colors.blue, size: 40)),
          ),
        ),
        SizedBox(height: 16),
        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Return to the previous screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Exit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        Spacer(),
      ],
    );
  }
}
