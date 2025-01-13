enum Reachability {
  online,
  inPerson,
  onlineOrInPerson;

  /// A factory constructor for creating a [Reachability] instance from a [String].
  ///
  /// The input string is matched against known values to create an appropriate [Reachability] instance:
  /// - 'In Person' -> [Reachability.inPerson]
  /// - 'Online' -> [Reachability.online]
  /// - 'Online/In Person' -> [Reachability.onlineOrInPerson]
  ///
  /// If the input string does not match any of the above values, the default
  /// value [Reachability.onlineOrInPerson] is returned.
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
      default:
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

  /// Converts an integer value to a [Reachability] instance.
  ///
  /// Throws [ArgumentError] if the [value] does not correspond to a valid reachability.
  static Reachability fromValue(int value) {
    return _valueMap.entries
        .firstWhere((entry) => entry.value == value,
            orElse: () => throw ArgumentError("Invalid reachability value"))
        .key;
  }
}
