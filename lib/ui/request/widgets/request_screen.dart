import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/notification_data.dart';
import 'package:provider/provider.dart';

import '../../swipe/widgets/profile_card.dart';
import '../view_model/request_view_model.dart';
import 'body/notification_body.dart';
import 'bottom/notification_bottom.dart';
import 'widget/user_profile_card.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  late final ScrollController _scrollController;
  bool _showProfileOverlay = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestViewModel>();

    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: _buildTitle(viewModel),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            // Main content + footer
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showProfileOverlay = true;
                            });
                          },
                          child: UserProfileCard(viewModel: viewModel),
                        ),
                        Expanded(
                          child: Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            thickness: 6,
                            radius: const Radius.circular(3),
                            child: ListView(
                              controller: _scrollController,
                              padding: EdgeInsets.zero,
                              children: const [NotificationBody()],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SafeArea(child: NotificationBottom()),
              ],
            ),

            // Dark overlay over entire screen
            if (_showProfileOverlay)
              Positioned.fill(
                child: Container(
                  color: Colors.black54,
                ),
              ),

            // ProfileCard elevated on top
            if (_showProfileOverlay)
              Center(
                child: Material(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ProfileCard(
                      profile: viewModel.userprofile,
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.82,
                    ),
                  ),
                ),
              ),

            // Close button on top
            if (_showProfileOverlay)
              Positioned(
                top: 32,
                right: 32,
                child: IconButton(
                  icon: Icon(Icons.close, size: 30),
                  onPressed: () {
                    setState(() {
                      _showProfileOverlay = false;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(RequestViewModel viewModel) {
    var type = viewModel.notificationData.type;
    switch (type) {
      case NotificationType.knowledgeRequest:
        return const Text("New request:");
      case NotificationType.requestDeclined:
        return const Text("Declined request:");
      case NotificationType.requestAccepted:
        return const Text("Accepted request");
      case NotificationType.meetupRequest:
        return const Text("Meetup request");
      case NotificationType.meetupConfirmation:
        return const Text("Meetup confirmation");
    }
  }
}
