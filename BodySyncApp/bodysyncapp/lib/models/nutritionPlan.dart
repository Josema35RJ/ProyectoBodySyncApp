class NutritionPlan {
  int id;
  int gymUserId;
  String name;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  NutritionPlan({
    required this.id,
    required this.gymUserId,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NutritionPlan.fromJson(Map<String, dynamic> json) {
    return NutritionPlan(
      id: json['id'] ?? 0,
      gymUserId: json['gymUserId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gymUserId': gymUserId,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
