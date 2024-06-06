

import 'package:bodysyncapp/models/gymUser.dart';

class Workout {
  int id;
  GymUser gymUser;
  DateTime dateTime;
  double duration;
  List<Exercise> exerciseList;
  String comments;

  Workout({
    required this.id,
    required this.gymUser,
    required this.dateTime,
    required this.duration,
    required this.exerciseList,
    required this.comments,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      gymUser: GymUser.fromJson(json['gymUser']),
      dateTime: DateTime.parse(json['dateTime']),
      duration: json['duration'].toDouble(),
      exerciseList: (json['exerciseList'] as List)
          .map((exerciseJson) => Exercise.fromJson(exerciseJson))
          .toList(),
      comments: json['comments'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gymUser': gymUser.toJson(),
      'dateTime': dateTime.toIso8601String(),
      'duration': duration,
      'exerciseList': exerciseList.map((exercise) => exercise.toJson()).toList(),
      'comments': comments,
    };
  }
}

class Exercise {
  int id;
  String name;

  Exercise({
    required this.id,
    required this.name,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
