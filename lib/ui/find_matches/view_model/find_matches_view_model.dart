import 'package:flutter/cupertino.dart';

import '../../../data/services/matching_algorithm.dart';
import '../../../domain/models/reachability.dart';

class FindMatchesViewModel extends ChangeNotifier {
  String? keyword;
  String? description;
  Reachability? reachability;
  late List<String> keywords = [];
  late List<Reachability> reachabilities = [];

  Future<void> loadData() async {
    keywords = await MatchingAlgorithm().getKeywords();
    reachabilities = (await MatchingAlgorithm().getReachabilities())!;
    notifyListeners();
  }
}