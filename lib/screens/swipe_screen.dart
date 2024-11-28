import 'package:flutter/material.dart';
import 'package:knowledgematch/model/notification_data.dart';
import 'package:swipable_stack/swipable_stack.dart';
import '../model/search_criteria.dart';
import '../model/userprofile.dart';
import '../services/notification_service.dart';
import '../widgets/profile_card.dart';

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

  // Use the NotificationService to send a notification
  Future<void> _sendSwipeRightNotification(Userprofile profile) async {
    var notificationData = NotificationData(
        type: NotificationType.knowledgeRequest,
        title: "Your knowledge has been requested!",
        body: widget.searchCriteria.issue,
        userId: profile.id );
    await NotificationService().sendMessageToDevice(notificationData);
    //TODO add actual target token of selected userprofile
    //TODO get actual User ID for the tokens
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Helpers"),
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
                      _sendSwipeRightNotification(profiles[_controller.currentIndex]);
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

class FrontCard extends StatelessWidget {
  final Userprofile profile;

  const FrontCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return ProfileCard(profile: profile); // Originaldesign der Vorderseite
  }
}

class FlipCard extends StatefulWidget {
  final Userprofile profile;

  const FlipCard({super.key, required this.profile});

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isBackVisible = true; // Rückseite wird zuerst angezeigt.

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isBackVisible) {
      _controller.reverse();
      _isBackVisible = false;
    }
  }

  void _toggleCard() {
    if (_controller.isAnimating) return;
    if (_isBackVisible) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _isBackVisible = !_isBackVisible;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Ermitteln der Breite und Höhe aus den Layout-Constraints
          final cardWidth = constraints.maxWidth;
          final cardHeight = constraints.maxHeight;

          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final isBack = _animation.value <= 0.5; // Rückseite zuerst
              final rotationAngle = _animation.value * 3.1416;
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(rotationAngle),
                alignment: Alignment.center,
                child: isBack
                    ? BackCard(
                  key: const ValueKey(true),
                  profile: widget.profile,
                  width: cardWidth,
                  height: cardHeight,
                )
                    : Transform(
                  transform: Matrix4.rotationY(3.1416),
                  alignment: Alignment.center,
                  child: FrontCard(
                    key: const ValueKey(false),
                    profile: widget.profile,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BackCard extends StatelessWidget {
  final Userprofile profile;
  final double width;
  final double height;

  const BackCard({
    super.key,
    required this.profile,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 75),
          const CircleAvatar(
            radius: 85,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 120, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            profile.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Placeholder for Credentials",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            profile.description == null || profile.description == "null"
                ? "Hier kommt in Zukunft mehr Information"
                : profile.description!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

class RotationYTransition extends AnimatedWidget {
  final Widget child;

  const RotationYTransition({Key? key, required Animation<double> turns, required this.child})
      : super(key: key, listenable: turns);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform(
      transform: Matrix4.rotationY(animation.value * 3.1416),
      alignment: Alignment.center,
      child: animation.value < 0.5
          ? child
          : Transform(
        transform: Matrix4.rotationY(3.1416),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}