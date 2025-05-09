class Organisation {
  final int id;
  final String organisation;
  final String domain;

  Organisation({
    required this.id,
    required this.organisation,
    required this.domain,
  });

  Organisation copyWith({
    int? id,
    String? organisation,
    String? domain,
  }) {
    return Organisation(
      id: id ?? this.id,
      organisation: organisation ?? this.organisation,
      domain: domain ?? this.domain,
    );
  }

  factory Organisation.fromJson(Map<String, dynamic> json) {
    return Organisation(
      id: json['id'],
      organisation: json['organisation'],
      domain: json['domain'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organisation': organisation,
      'domain': domain,
    };
  }
}
