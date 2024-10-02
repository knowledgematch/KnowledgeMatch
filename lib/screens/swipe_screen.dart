import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import '../model/user.dart';
import '../widgets/profile_card.dart';

class SwipeScreen extends StatefulWidget {
  @override
  _ProfileSwipeScreenState createState() => _ProfileSwipeScreenState();
}

class _ProfileSwipeScreenState extends State<SwipeScreen> {
  List<SwipeItem> _swipeItems = [];
  MatchEngine? _matchEngine;
  final PageController _pageController = PageController();
  final List<User> profiles = [
    User(name: 'Alice', age: 25, description: 'Loves hiking and photography.'),
    User(name: 'Bob', age: 30, description: 'Enjoys cooking and traveling.'),
    User(
        name: 'Charlie',
        age: 28,
        description: 'Passionate about technology and music.'),
    User(
        name: 'Diana',
        age: 22,
        description: 'Avid reader and coffee enthusiast.'),
  ];

  @override
  void initState() {
    super.initState();
    _initializeSwipeItems();
  }

  void _initializeSwipeItems() {
    for (int i = 0; i < profiles.length; i++) {
      _swipeItems.add(SwipeItem(
        content: profiles[i],
        likeAction: () {
          print("Liked " + profiles[i].name);
        },
        nopeAction: () {
          print("Disliked " + profiles[i].name);
        },
      ));
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  int _getRealIndex(int index) => index % profiles.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Swipeable Cards Example"),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SwipeCards(
            matchEngine: _matchEngine!,
            itemBuilder: (BuildContext context, int index) =>
                ProfileCard(profile: profiles[index]),
            onStackFinished: () {
              print("Stack Finished");
            },
            itemChanged: (SwipeItem item, int index) {
              print("Item changed: ${item.content}");
            },
            upSwipeAllowed: false,
            fillSpace: false,
          ),
        ),
      ),
    );
  }
}
