class Keyword {
  final int id;
  final int levels;
  final String name;
  final String description;

  Keyword({
    required this.id,
    required this.levels,
    required this.name,
    required this.description
  });

  Keyword copyWith({
    int? id,
    int? levels,
    String? name,
    String? description,
  }) {
    return Keyword(
      id: id ?? this.id,
      levels: levels ?? this.levels,
      name: name ?? this.name,
      description: description ?? this.description
    );
  }
}