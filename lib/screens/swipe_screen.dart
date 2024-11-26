import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../model/search_criteria.dart';
import '../model/userprofile.dart';
import '../services/notification_service.dart';
import '../widgets/profile_card.dart';

class SwipeScreen extends StatefulWidget {
  final SearchCriteria searchCriteria;
  final Future<List<Userprofile>> profiles;

  const SwipeScreen(
      {super.key, required this.searchCriteria, required this.profiles});

  @override
  ProfileSwipeScreenState createState() => ProfileSwipeScreenState();
}

class ProfileSwipeScreenState extends State<SwipeScreen> {
  final SwipableStackController _controller = SwipableStackController();
  bool shouldShowGlow = false;

  // Map zur Speicherung des Zustands (Vorder- oder Rückseite) jeder Karte
  final Map<int, bool> cardStates = {};
  bool isAnimating = false; // Kontrollvariable


  void checkSwipeDirection(double swipeDistance) {
    if (swipeDistance > 0.8) {
      shouldShowGlow = true;
    } else {
      shouldShowGlow = false;
    }
  }

  void toggleCardSide(int index) {
    if (isAnimating) return;
    setState(() {
      isAnimating = true;
      cardStates[index] = !(cardStates[index] ?? false);
    });

    // Freigeben nach der Animationsdauer
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isAnimating = false;
      });
    });
  }

  void resetCardStates() {
    setState(() {
      cardStates.clear(); // Lösche alle gespeicherten Zustände
    });
    _controller.currentIndex = -1;
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
                      profiles.removeAt(_controller.currentIndex);
                      _controller.currentIndex--;
                    } else if (direction == SwipeDirection.left) {}
                    if (_controller.currentIndex == profiles.length - 1) {
                      resetCardStates();
                    }
                  });
                },
                builder: (context, properties) {
                  checkSwipeDirection(properties.swipeProgress);

                  // Zustand der Karte (Vorderseite oder Rückseite)
                  final isBackSide = cardStates[properties.index] ?? false;

                  return GestureDetector(
                    onTap: () => toggleCardSide(properties.index),
                    // Klick-Event
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      // Animationsdauer
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        final rotate =
                            Tween(begin: 0.0, end: 1.0).animate(animation);

                        return AnimatedBuilder(
                          animation: rotate,
                          child: child,
                          builder: (BuildContext context, Widget? child) {
                            // Prüfen, ob die Rückseite angezeigt wird
                            final isUnder =
                                (ValueKey(isBackSide) != child?.key);
                            final rotationAngle =
                                rotate.value * 3.14159; // Pi für 180°

                            return Transform(
                              alignment: Alignment.center,
                              transform: isUnder
                                  ? (Matrix4.rotationY(rotationAngle)
                                    ..setEntry(3, 2, 0.001))
                                  : (Matrix4.rotationY(rotationAngle + 3.14159)
                                    ..setEntry(3, 2, 0.001)),
                              // Rückseite korrigiert
                              child: isUnder
                                  ? Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationY(3.14159),
                                      // Rückseite wieder ausrichten
                                      child: child,
                                    )
                                  : child,
                            );
                          },
                        );
                      },
                      child: isBackSide
                          ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            if (shouldShowGlow)
                              BoxShadow(
                                color: properties.direction == SwipeDirection.right
                                    ? Colors.green.withOpacity(0.5)
                                    : properties.direction == SwipeDirection.left
                                    ? Colors.red.withOpacity(0.5)
                                    : Colors.transparent,
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BackSideCard(
                            profile: profiles[properties.index % profiles.length],
                          ),
                        ),
                      )

                          : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            if (shouldShowGlow)
                              BoxShadow(
                                color: properties.direction == SwipeDirection.right
                                    ? Colors.green.withOpacity(0.5)
                                    : properties.direction == SwipeDirection.left
                                    ? Colors.red.withOpacity(0.5)
                                    : Colors.transparent,
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ProfileCard(
                            profile: profiles[properties.index % profiles.length],
                          ),
                        ),
                      )

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

// Widget für die Rückseite der Karte
class BackSideCard extends StatelessWidget {
  final Userprofile profile;

  const BackSideCard({required this.profile, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Horizontaler Rand leicht reduziert für breitere Rückseite
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Innenabstand bleibt gleich
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                profile.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Location: ${profile.location}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Expertise: ${profile.expertise.join(", ")}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Languages: ${profile.languages.join(", ")}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}