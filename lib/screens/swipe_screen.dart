import 'package:flutter/material.dart';
import 'package:knowledgematch/models/notification_data.dart';
import 'package:knowledgematch/models/search_criteria.dart';
import 'package:knowledgematch/models/user.dart';
import 'package:knowledgematch/models/userprofile.dart';
import 'package:knowledgematch/services/notification_service.dart';
import 'package:knowledgematch/widgets/flip_card.dart';
import 'package:swipable_stack/swipable_stack.dart';

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
    shouldShowGlow = swipeDistance > 0.8;
  }

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
      backgroundColor: const Color(0xFFbcb9b0),
      appBar: AppBar(
        title: FutureBuilder<List<Userprofile>>(
          future: widget.profiles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Matches Loading...");
            } else if (snapshot.hasError) {
              return const Text("Error loading matches");
            } else if (snapshot.hasData) {
              final profiles = snapshot.data!;
              return Text("Matches (${profiles.length})",
                  style: const TextStyle(color: Colors.black));
            } else {
              return const Text("No Matches",
                  style: TextStyle(color: Colors.black));
            }
          },
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFbcb9b0),
        iconTheme: const IconThemeData(color: Colors.black),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Request sent',
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.black,
                          duration: const Duration(milliseconds: 500),
                        ),
                      );
                      _sendSwipeRightNotification(
                          profiles[_controller.currentIndex]);
                      profiles.removeAt(_controller.currentIndex);
                      _controller.currentIndex--;
                    }
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
                                ? Colors.green.withOpacity(0.6)
                                : properties.direction == SwipeDirection.left
                                    ? Colors.red.withOpacity(0.6)
                                    : Colors.transparent,
                            blurRadius: 35,
                            spreadRadius: 4,
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
