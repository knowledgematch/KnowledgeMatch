enum Reachability {
  online,
  inPerson,
  onlineOrInPerson;

  factory Reachability.fromString(String type) {
    switch (type) {
      case 'In Person':
        return inPerson;
      case 'Online':
        return online;
      case 'Online/In Person':
        return onlineOrInPerson;
      default:
        return onlineOrInPerson;
    }
  }
  @override
  String toString() {
    switch (this) {
      case Reachability.online:
        return 'Online';
      case Reachability.inPerson:
        return 'In Person';
      case Reachability.onlineOrInPerson:
        return 'Online/In Person';
    }
  }
}

extension ReachabilityValue on Reachability {
  static const Map<Reachability, int> _valueMap = {
    Reachability.online: 0,
    Reachability.inPerson: 1,
    Reachability.onlineOrInPerson: 2,
  };

  static const Map<Reachability, String> _descriptionMap = {
    Reachability.online: "Online",
    Reachability.inPerson: "In Person",
    Reachability.onlineOrInPerson: "Online/In Person",
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
