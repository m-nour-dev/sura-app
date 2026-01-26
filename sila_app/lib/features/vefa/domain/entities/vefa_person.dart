class VefaPerson {
  final int? id;
  final String name;
  final String? relation; // e.g., Father, Friend
  final DateTime? deathDate;
  final int giftCount; // How many times user donated thawab to this person

  VefaPerson({
    this.id,
    required this.name,
    this.relation,
    this.deathDate,
    this.giftCount = 0,
  });

  VefaPerson copyWith({
    int? id,
    String? name,
    String? relation,
    DateTime? deathDate,
    int? giftCount,
  }) {
    return VefaPerson(
      id: id ?? this.id,
      name: name ?? this.name,
      relation: relation ?? this.relation,
      deathDate: deathDate ?? this.deathDate,
      giftCount: giftCount ?? this.giftCount,
    );
  }
}
