import 'package:bodysyncapp/models/exercise.dart';

class Routine {
  int id;
  int gymUserId;
  List<Exercise> exerciseList;
  int daysPerWeek;

  Routine({
    required this.id,
    required this.gymUserId,
    required this.exerciseList,
    required this.daysPerWeek,
  });

  factory Routine.fromJson(Map<String, dynamic> json) {
    List<Exercise> parsedExerciseList = [];
    if (json['exerciseList'] != null && json['exerciseList'] is List) {
      // Map each JSON object in the exercise list to an Exercise object
      parsedExerciseList = (json['exerciseList'] as List)
          .map((e) => Exercise.fromJson(e))
          .toList();
    }

    return Routine(
      id: json['id'] ?? 0,
      gymUserId: json['gymUserId'] ?? 0,
      exerciseList: parsedExerciseList,
      daysPerWeek: json['daysPerWeek'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gymUserId': gymUserId,
      'exerciseList': exerciseList.map((exercise) => exercise.toJson()).toList(),
      'daysPerWeek': daysPerWeek,
    };
  }
}
