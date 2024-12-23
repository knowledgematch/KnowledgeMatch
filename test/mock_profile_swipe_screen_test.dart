import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knowledgematch/model/reachability.dart';
import 'package:knowledgematch/model/search_criteria.dart';
import 'package:knowledgematch/model/userprofile.dart';
import 'package:knowledgematch/screens/swipe_screen.dart';

void main() {
  runApp(SwipeScreenTestApp());
}

class SwipeScreenTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SwipeScreen(
        searchCriteria: SearchCriteria(keyword: '', issue: "Test Criteria", reachability: Reachability.inPerson),
        profiles: _getMatchingUserProfiles(_mockProfiles()),
      ),
    );
  }

  Future<List<Userprofile>> _mockProfiles() async {
    // Erstelle Dummy-Daten für das Testing
    return [
      Userprofile(
        id: 1,
        name: 'A-person',
        location: 'Placeholder here',
        expertString: 'Placeholder here',
        availability: 'Placeholder here',
        langString: 'Placeholder here',
        reachability: Reachability.inPerson,
        description: 'Number1Profile',
        seniority: 0,
      ),
      Userprofile(
        id: 2,
        name: 'B-person',
        location: 'Placeholder here',
        expertString: 'Placeholder here',
        availability: 'Placeholder here',
        langString: 'Placeholder here',
        reachability: Reachability.inPerson,
        description: 'Number2Profile',
        seniority: 4,
      ),
      Userprofile(
        id: 3,
        name: 'C-person',
        location: 'Placeholder here',
        expertString: 'Placeholder here',
        availability: 'Placeholder here',
        langString: 'Placeholder here',
        reachability: Reachability.inPerson,
        description: 'Number3Profile',
        seniority: 1,
      ),
      Userprofile(
        id: 4,
        name: 'D-person',
        location: 'Placeholder here',
        expertString: 'Placeholder here',
        availability: 'Placeholder here',
        langString: 'Placeholder here',
        reachability: Reachability.inPerson,
        description: 'Number4Profile',
        seniority: 0,
      ),
      Userprofile(
        id: 5,
        name: 'E-person',
        location: 'Placeholder here',
        expertString: 'Placeholder here',
        availability: 'Placeholder here',
        langString: 'Placeholder here',
        reachability: Reachability.inPerson,
        description: 'Number5Profile',
        seniority: 1,
      ),
      Userprofile(
        id: 6,
        name: 'F-person',
        location: 'Placeholder here',
        expertString: 'Placeholder here',
        availability: 'Placeholder here',
        langString: 'Placeholder here',
        reachability: Reachability.inPerson,
        description: 'Number6Profile',
        seniority: 2,
      )
    ];
  }

  Future<List<Userprofile>> _getMatchingUserProfiles(
      Future<List<Userprofile>> arg) async {
    List<Userprofile> profiles = await arg;
    profiles.sort((a, b) {
      if (a.seniority == 0) return 1;
      if (b.seniority == 0)
        return -1;
      else
        return a.seniority.compareTo(b.seniority);
    }); // Sort matching profiles by seniority  (0-seniority is prioritized the least)
    return profiles;
  }
}