class Achievement {
  int id;
  int gymUserId;
  String name;
  String description;
  DateTime achievedAt;

  Achievement({
    required this.id,
    required this.gymUserId,
    required this.name,
    required this.description,
    required this.achievedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? 0,
      gymUserId: json['gymUserId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      achievedAt: DateTime.tryParse(json['achievedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gymUserId': gymUserId,
      'name': name,
      'description': description,
      'achievedAt': achievedAt.toIso8601String(),
    };
  }
}
