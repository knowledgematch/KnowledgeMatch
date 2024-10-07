import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import '../model/userprofile.dart';
import '../widgets/profile_card.dart';

class SwipeScreen extends StatefulWidget {
  @override
  _ProfileSwipeScreenState createState() => _ProfileSwipeScreenState();
}

class _ProfileSwipeScreenState extends State<SwipeScreen> {
  List<SwipeItem> _swipeItems = [];
  MatchEngine? _matchEngine;

  final List<Userprofile> profiles = [
    Userprofile(
        name:         'Alice',
        location:     'Brugg',
        expertString: 'Oop1 Dnet1 Sysad',
        availability: '18:30 - 19:30, every Friday',
        langString:   'German English',
        description:  'Loves hiking and photography.',
    ),
    Userprofile(
        name:         'Bob',
        location:     'Brugg',
        expertString: 'algd1 eana Oop1',
        availability: '08:15 - 11:00, Every Sunday',
        langString:   'German English French',
        description:  'Enjoys cooking and traveling.',
    ),
    Userprofile(
        name:         'Charlie',
        location:     'Brugg',
        expertString: 'vana Oop2 infsec',
        availability: '17:30 - 19:00, Every Sunday',
        langString:   'German English',
        description:  'Passionate about technology and music.',
    ),
    Userprofile(
        name:         'Diana',
        location:     'Brugg',
        expertString: 'swagl uuidc pmc Oop1',
        availability: '11:00 - 12:00, Every Day',
        langString:   'English French',
        description:  'Avid reader and coffee enthusiast.',
    ),
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
              //with only one profile swipe_cards will crash when repeatedly swiping left
              if(profiles.length > 1){
                setState(() {
                  _initializeSwipeItems();
                });
              }else{
                profiles.clear();
                setState(() {});
              }
            },
            itemChanged: (SwipeItem item, int index) {
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