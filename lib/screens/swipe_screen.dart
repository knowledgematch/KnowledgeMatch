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

  final List<User> profiles = [
    User(name: 'Alice', age: 25, description: 'Loves hiking and photography.'),
    User(name: 'Bob', age: 30, description: 'Enjoys cooking and traveling.'),
    User(name: 'Charlie',
        age: 28,
        description: 'Passionate about technology and music.'),
    User(name: 'Diana',
        age: 22,
        description: 'Avid reader and coffee enthusiast.'),
  ];

  @override
  void initState() {
    super.initState();
    _initializeSwipeItems();
  }

  void _initializeSwipeItems() {
    _swipeItems = profiles.map((profile) {
      return SwipeItem(
        content: profile,
        likeAction: () {
          profiles.remove(profile);
        },
        nopeAction: () {
        },
      );
    }).toList();

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Swipeable Cards Example"),
        centerTitle: true,
      ),
      body: Center(
        child: profiles.isNotEmpty
            ? SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SwipeCards(
            matchEngine: _matchEngine!,
            itemBuilder: (BuildContext context, int index) {
              return ProfileCard(
                profile: _swipeItems[index % _swipeItems.length].content,
              );
            },
            onStackFinished: () {
              print("Stack Finished");
              if(profiles.isNotEmpty){
                setState(() {
                  _initializeSwipeItems();
                });
              }else{
                setState(() {});
              }
            },
            itemChanged: (SwipeItem item, int index) {
              print("Currently swiping: ${item.content.name}");
            },
            upSwipeAllowed: false,
            fillSpace: false,
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