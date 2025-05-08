import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/core/ui/decorations.dart';
import 'package:knowledgematch/ui/request/view_model/request_view_model.dart';
import 'package:provider/provider.dart';

class OnMeetupConfirmationBody extends StatelessWidget {
  const OnMeetupConfirmationBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestViewModel>();
    viewModel.closeRequestDelegate();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Text(
            ' Meetup Confirmation:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: Decorations.container,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                title: Text(
                  'Your confirmed meetup details:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(viewModel.notificationData.body),
                trailing: Icon(Icons.date_range, color: Colors.green, size: 40),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            ' Keep in touch:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: Decorations.container,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                onTap: () async {
                  viewModel.forwardToTeamsDelegate();
                },
                title: Text(
                  'Link to ${viewModel.userprofile.name}\'s Teams Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(viewModel.userprofile.email),
                trailing: Icon(Icons.chat, color: Colors.blue, size: 40),
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
