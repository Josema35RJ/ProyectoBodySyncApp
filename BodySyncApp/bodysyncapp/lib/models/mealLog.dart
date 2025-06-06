class MealLog {
  int id;
  int gymUserId;
  DateTime mealDate;
  String mealDescription;
  int caloriesConsumed;

  MealLog({
    required this.id,
    required this.gymUserId,
    required this.mealDate,
    required this.mealDescription,
    required this.caloriesConsumed,
  });

  factory MealLog.fromJson(Map<String, dynamic> json) {
    return MealLog(
      id: json['id'] ?? 0,
      gymUserId: json['gymUserId'] ?? 0,
      mealDate: DateTime.tryParse(json['mealDate'] ?? '') ?? DateTime.now(),
      mealDescription: json['mealDescription'] ?? '',
      caloriesConsumed: json['caloriesConsumed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gymUserId': gymUserId,
      'mealDate': mealDate.toIso8601String(),
      'mealDescription': mealDescription,
      'caloriesConsumed': caloriesConsumed,
    };
  }
}
