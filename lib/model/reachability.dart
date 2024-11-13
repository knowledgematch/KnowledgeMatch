enum Reachability {
  Offline,
  InPerson,
  Both
}

extension ReachabilityValue on Reachability {
  static const Map<Reachability, int> _valueMap = {
    Reachability.Offline: 0,
    Reachability.InPerson: 1,
    Reachability.Both: 2,
  };

  static const Map<Reachability, String> _descriptionMap = {
    Reachability.Offline: "Offline",
    Reachability.InPerson: "In Person",
    Reachability.Both: "Offline, In Person",
  };

  int get value => _valueMap[this]!;

  String get description => _descriptionMap[this]!;

  static Reachability fromValue(int value) {
    return _valueMap.entries
        .firstWhere((entry) => entry.value == value,
        orElse: () => throw ArgumentError("Invalid reachability value"))
        .key;
  }
}