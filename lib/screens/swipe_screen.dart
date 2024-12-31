import 'package:flutter/material.dart';
import 'package:knowledgematch/model/notification_data.dart';
import 'package:swipable_stack/swipable_stack.dart';
import '../model/search_criteria.dart';
import '../model/user.dart';
import '../model/userprofile.dart';
import '../services/notification_service.dart';
import '../widgets/flip_card.dart';

class SwipeScreen extends StatefulWidget {
  final SearchCriteria searchCriteria;
  final Future<List<Userprofile>> profiles;

  const SwipeScreen({
    super.key,
    required this.searchCriteria,
    required this.profiles,
  });

  @override
  ProfileSwipeScreenState createState() => ProfileSwipeScreenState();
}

class ProfileSwipeScreenState extends State<SwipeScreen> {
  final SwipableStackController _controller = SwipableStackController();
  bool shouldShowGlow = false;

  void checkSwipeDirection(double swipeDistance) {
    if (swipeDistance > 0.8) {
      shouldShowGlow = true;
    } else {
      shouldShowGlow = false;
    }
  }

  /// Use the NotificationService to send a [NotificationType.knowledgeRequest] notification.
  ///
  /// Creates [NotificationData] from [SearchCriteria] and [Userprofile].
  /// Uses the [NotificationService] to send the data to the users [Userprofile.tokens]
  ///
  /// @param profile to send the notification to.

  Future<void> _sendSwipeRightNotification(Userprofile profile) async {
    var topic = widget.searchCriteria.keyword;
    var notificationData = NotificationData(
      type: NotificationType.knowledgeRequest,
      title: "Your knowledge has been requested!",
      body:
          "From: ${User.instance.name} ${User.instance.surname}, Topic: $topic",
      payload: widget.searchCriteria.toJSON(),
      targetUserId: profile.id,
      sourceUserId: User.instance.id ?? 0,
    );
    await NotificationService()
        .sendMessageToDevice(notificationData, profile.tokens ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: FutureBuilder<List<Userprofile>>(
          future: widget.profiles, // The Future that holds the list
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Matches Loading...");
            } else if (snapshot.hasError) {
              return const Text("Error loading matches");
            } else if (snapshot.hasData) {
              // Access the list from snapshot.data and display its length
              final profiles = snapshot.data!;
              return Text("Matches (${profiles.length})");
            } else {
              return const Text("No Matches");
            }
          },
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Userprofile>>(
        future: widget.profiles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No more profiles to show!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            var profiles = snapshot.data!;
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SwipableStack(
                controller: _controller,
                itemCount: profiles.length,
                horizontalSwipeThreshold: 0.8,
                onSwipeCompleted: (index, direction) {
                  setState(() {
                    if (direction == SwipeDirection.right) {
                      //send notification
                      final snackBar = SnackBar(
                        content: const Text('Request sent'),
                        duration: Duration(milliseconds: 500),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      _sendSwipeRightNotification(
                          profiles[_controller.currentIndex]);
                      profiles.removeAt(_controller.currentIndex);
                      _controller.currentIndex--;
                    } else if (direction == SwipeDirection.left) {}
                    if (_controller.currentIndex == profiles.length - 1) {
                      _controller.currentIndex = -1;
                    }
                  });
                },
                builder: (context, properties) {
                  checkSwipeDirection(properties.swipeProgress);
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        if (shouldShowGlow)
                          BoxShadow(
                            color: properties.direction == SwipeDirection.right
                                ? Colors.green.withOpacity(0.9)
                                : properties.direction == SwipeDirection.left
                                    ? Colors.red.withOpacity(0.9)
                                    : Colors.transparent,
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FlipCard(
                        profile: profiles[properties.index % profiles.length],
                      ),
                    ),
                  );
                },
                overlayBuilder: (context, properties) {
                  if (properties.direction == SwipeDirection.right &&
                      shouldShowGlow) {
                    return const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'REQUEST',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  } else if (properties.direction == SwipeDirection.left &&
                      shouldShowGlow) {
                    return const Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'DECLINE',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                swipeAssistDuration: const Duration(milliseconds: 200),
                stackClipBehaviour: Clip.hardEdge,
                allowVerticalSwipe: false,
              ),
            );
          }
        },
      ),
    );
  }
}
