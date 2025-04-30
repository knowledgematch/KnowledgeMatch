class Topic {
  final int id;
  final int levels;
  final String name;
  final String description;

  Topic({
    required this.id,
    required this.levels,
    required this.name,
    required this.description
  });

  Topic copyWith({
    int? id,
    int? levels,
    String? name,
    String? description,
  }) {
    return Topic(
        id: id ?? this.id,
        levels: levels ?? this.levels,
        name: name ?? this.name,
        description: description ?? this.description
    );
  }
}