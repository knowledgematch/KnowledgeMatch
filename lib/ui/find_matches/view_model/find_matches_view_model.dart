import 'package:flutter/cupertino.dart';
import 'package:knowledgematch/ui/find_matches/find_matches_state.dart';

import '../../../data/services/matching_algorithm.dart';
import '../../../domain/models/reachability.dart';

class FindMatchesViewModel extends ChangeNotifier {
  FindMatchesState _state = FindMatchesState(keywords: [], reachabilities: []);

  static const List<Map<String, dynamic>> choices = [
    {
      "text": "In Person",
      "value": Reachability.inPerson,
    },
    {
      "text": "Online",
      "value": Reachability.online,
    },
    {
      "text": "In Person / Online",
      "value": Reachability.onlineOrInPerson,
    },
  ];

  FindMatchesViewModel() {
    loadData();
  }

  FindMatchesState get state => _state;

  void updateKeyword(String? newKeyword) {
    _state = _state.copyWith(keyword: newKeyword);
    notifyListeners();
  }

  void updateDescription(String? newDescription) {
    _state = _state.copyWith(description: newDescription);
    notifyListeners();
  }

  void updateReachability(Reachability? newReachability) {
    _state = _state.copyWith(reachability: newReachability);
    notifyListeners();
  }

  Future<void> loadData() async {
    _state = _state.copyWith(
        keywords: await MatchingAlgorithm().getKeywords(),
        reachabilities: await MatchingAlgorithm().getReachabilities());
    notifyListeners();
  }
}
