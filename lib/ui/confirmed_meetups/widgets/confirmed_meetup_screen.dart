import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../request/widgets/notification_card.dart';
import '../view_model/confirmed_meetup_view_model.dart';

class ConfirmedMeetupsScreen extends StatefulWidget {

  const ConfirmedMeetupsScreen({super.key});

  @override
  ConfirmedMeetupsScreenState createState() => ConfirmedMeetupsScreenState();
}

class ConfirmedMeetupsScreenState extends State<ConfirmedMeetupsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ConfirmedMeetupViewModel>();
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Confirmed Requests'),
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.errorMessage != null
                  ? Center(
                      child: Text('Error: ${viewModel.errorMessage}'))
                  : viewModel.notification.isEmpty
                      ? const Center(child: Text('No requests found.'))
                      : ListView.builder(
                          itemCount: viewModel.notification.length,
                          itemBuilder: (context, index) {
                            final notification =
                                viewModel.notification[index];
                            final userProfile = viewModel
                                .userProfiles[notification.sourceUserId];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ChangeNotifierProvider<
                                              ConfirmedMeetupViewModel>.value(
                                              value: viewModel
                                            ),
                                ));
                              },
                              child: NotificationCard(
                                notification: notification,
                                userprofile: userProfile!,
                              ),
                            );
                          },
                        ),
        );
      },
    );
  }
}
