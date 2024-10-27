import 'package:flutter/material.dart';
import 'package:knowledgematch/services/matching_algorithm.dart';
import 'package:swipable_stack/swipable_stack.dart';
import '../model/userprofile.dart';
import '../model/search_criteria.dart';
import '../widgets/profile_card.dart';

class SwipeScreen extends StatefulWidget {
  final SearchCriteria searchCriteria;
  final List<Userprofile> profiles;

  const SwipeScreen({super.key, required this.searchCriteria, required this.profiles});

  @override
  ProfileSwipeScreenState createState() => ProfileSwipeScreenState();
}

class ProfileSwipeScreenState extends State<SwipeScreen> {
  final SwipableStackController _controller = SwipableStackController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Helpers"),
        centerTitle: true,
      ),
      body: Center(
        child: widget.profiles.isNotEmpty
            ? SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SwipableStack(
            controller: _controller,
            itemCount: widget.profiles.length,
            onSwipeCompleted: (index, direction) {
              setState(() {
                if (direction == SwipeDirection.right) {
                  widget.profiles.removeAt(_controller.currentIndex);
                  _controller.currentIndex--;
                } else if (direction == SwipeDirection.left) {

                }
                if (_controller.currentIndex == widget.profiles.length - 1) {
                  _controller.currentIndex = -1;
                }
              });
            },
            builder: (context, properties) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
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
                    profile: widget.profiles[properties.index % widget.profiles.length],
                  ),
                ),
              );
            },
            overlayBuilder: (context, properties) {
              if (properties.direction == SwipeDirection.right) {
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
              } else if (properties.direction == SwipeDirection.left) {
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
            stackClipBehaviour: Clip.none,
            allowVerticalSwipe: false,
          ),
        )
            : const Text(
          "No more profiles to show!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
