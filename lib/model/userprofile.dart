class Userprofile {
  final String name;
  final String location;
  final List<String> expertise;
  final String availability;
  final List<String> languages;
  final int? reachability;
  final String description;

  Userprofile({
    required this.name,
    required this.location,
    required String expertString,
    required this.availability,
    required String langString,
    this.reachability,
    required this.description,
  }) :  expertise = expertString.split(" "),
        languages = langString.split(" ");
}