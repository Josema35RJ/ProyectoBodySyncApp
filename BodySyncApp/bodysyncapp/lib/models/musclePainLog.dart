class MusclePainLog {
  int id;
  int gymUserId;
  DateTime painDate;
  String painDescription;
  String muscleGroup;
  int painIntensity;

  MusclePainLog({
    required this.id,
    required this.gymUserId,
    required this.painDate,
    required this.painDescription,
    required this.muscleGroup,
    required this.painIntensity,
  });

  factory MusclePainLog.fromJson(Map<String, dynamic> json) {
    return MusclePainLog(
      id: json['id'],
      gymUserId: json['gymUserId'],
      painDate: DateTime.tryParse(json['painDate'] ?? '') ?? DateTime.now(),
      painDescription: json['painDescription'],
      muscleGroup: json['muscleGroup'],
      painIntensity: json['painIntensity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gymUserId': gymUserId,
      'painDate': painDate.toIso8601String(),
      'painDescription': painDescription,
      'muscleGroup': muscleGroup,
      'painIntensity': painIntensity,
    };
  }
}
