import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';
import '../model/userprofile.dart';
import '../model/search_criteria.dart';
import '../widgets/profile_card.dart';

class SwipeScreen extends StatefulWidget {
  @override
  ProfileSwipeScreenState createState() => ProfileSwipeScreenState();
  final SearchCriteria searchCriteria;

  const SwipeScreen({super.key, required this.searchCriteria});
}

class ProfileSwipeScreenState extends State<SwipeScreen> {
  final SwipableStackController _controller = SwipableStackController();

  List<Userprofile> profiles = [
    Userprofile(
      name: 'Alice',
      location: 'Brugg',
      expertString: 'Oop1 Dnet1 Sysad',
      availability: '18:30 - 19:30, every Friday',
      langString: 'German English',
      reachability: 3,
      description: 'Loves hiking and photography.',
    ),
    Userprofile(
      name: 'Bob',
      location: 'Brugg',
      expertString: 'algd1 eana Oop1',
      availability: '08:15 - 11:00, Every Sunday',
      langString: 'German English French',
      reachability: 2,
      description: 'Enjoys cooking and traveling.',
    ),
    Userprofile(
      name: 'Charlie',
      location: 'Brugg',
      expertString: 'vana Oop2 infsec',
      availability: '17:30 - 19:00, Every Sunday',
      langString: 'German English',
      reachability: 1,
      description: 'Passionate about technology and music.',
    ),
    Userprofile(
      name: 'Diana',
      location: 'Brugg',
      expertString: 'swagl uuidc pmc Oop1',
      availability: '11:00 - 12:00, Every Day',
      langString: 'English French',
      description: 'Avid reader and coffee enthusiast.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Helpers"),
        centerTitle: true,
      ),
      body: Center(
        child: profiles.isNotEmpty
            ? SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SwipableStack(
            controller: _controller,
            itemCount: profiles.length,
            onSwipeCompleted: (index, direction) {
              setState(() {
                if (direction == SwipeDirection.right) {
                  profiles.removeAt(_controller.currentIndex);
                  //ensures that the index stays the same
                  _controller.currentIndex--;
                } else if (direction == SwipeDirection.left) {

                }
                if(_controller.currentIndex == profiles.length-1){
                  //ensures that the index is set to 0
                  _controller.currentIndex = -1;
                }
              });
            },
            builder: (context, properties) {
              return ProfileCard(
                profile: profiles[properties.index % profiles.length],
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
