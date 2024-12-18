import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knowledgematch/model/reachability.dart';
import 'package:knowledgematch/model/search_criteria.dart';
import 'package:knowledgematch/model/userprofile.dart';
import 'package:knowledgematch/screens/swipe_screen.dart';
import 'package:knowledgematch/services/matching_algorithm.dart';

void main() {
  runApp(SwipeScreenTestApp());
}

class SwipeScreenTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SearchCriteria searchCriteria = SearchCriteria(keyword: 'OOP', issue: '', reachability: Reachability.online);
    return MaterialApp(
      home: SwipeScreen(
        searchCriteria: searchCriteria,
        profiles: _getMatchingUserProfiles(searchCriteria),
      ),
    );
  }


  Future<List<Userprofile>> _getMatchingUserProfiles(SearchCriteria searchCriteria) async {
    Future<List<Userprofile>> matchingProfiles = MatchingAlgorithm().matchingAlgorithm(searchCriteria);
    List<Userprofile> profiles = await matchingProfiles;
    profiles.sort((a, b) {
      if (a.seniority == 0) return 1;
      if (b.seniority == 0) return -1;
      else return a.seniority.compareTo(b.seniority);
    });  // Sort matching profiles by seniority  (0-seniority is prioritized the least)
    return profiles;
  }
}