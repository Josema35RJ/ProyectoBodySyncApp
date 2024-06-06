class WorkoutLog {
  int id;
  int gymUserId;
  DateTime workoutDate;
  String workoutDescription;
  int caloriesBurned;

  WorkoutLog({
    required this.id,
    required this.gymUserId,
    required this.workoutDate,
    required this.workoutDescription,
    required this.caloriesBurned,
  });

  factory WorkoutLog.fromJson(Map<String, dynamic> json) {
    return WorkoutLog(
      id: json['id'],
      gymUserId: json['gymUserId'],
      workoutDate: DateTime.tryParse(json['workoutDate'] ?? '') ?? DateTime.now(),
      workoutDescription: json['workoutDescription'],
      caloriesBurned: json['caloriesBurned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gymUserId': gymUserId,
      'workoutDate': workoutDate.toIso8601String(),
      'workoutDescription': workoutDescription,
      'caloriesBurned': caloriesBurned,
    };
  }
}
