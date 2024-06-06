import 'package:bodysyncapp/models/achievement.dart';
import 'package:bodysyncapp/models/classReservation.dart';
import 'package:bodysyncapp/models/exercise.dart';
import 'package:bodysyncapp/models/gymClass.dart';
import 'package:bodysyncapp/models/mealLog.dart';
import 'package:bodysyncapp/models/musclePainLog.dart';
import 'package:bodysyncapp/models/nutritionPlan.dart';
import 'package:bodysyncapp/models/routine.dart';
import 'package:bodysyncapp/models/speciality.dart';
import 'package:bodysyncapp/models/userInjury.dart';
import 'package:bodysyncapp/models/workoutLog.dart';

class GymUser {
  int? id;
  String firstName;
  String lastName;
  String dni;
  String postalCode;
  String province;
  String city;
  String username;
  String password;
  String role;
  DateTime? birthDate;
  double weight;
  double height;
  String? activityLevel;
  String? goal;
  bool? deleted;
  bool? enabled;
  String? biography;
  List<Speciality>? specialtyList;
  String? gymName;
  String? gymLocation;
  List<GymClass>? enrolledClasses;
  bool? paymentStatus;
  double? debt;
  Set<DateTime>? attendanceDays;
  DateTime? createdDate;
  DateTime? updatedDate;
  List<Routine>? routines;
  List<Exercise>? exercises;
  List<NutritionPlan>? nutritionPlans;
  List<Achievement>? achievements;
  List<ClassReservation>? classReservations;
  List<WorkoutLog>? workoutLogs;
  List<MealLog>? mealLogs;
  List<MusclePainLog>? musclePainLogs;
  int? attendance;
  Set<UserInjury>? injuriesList;
   List<GymUser>? gymBros;
  bool? churn;
  String? token;

  GymUser({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.postalCode,
    required this.province,
    required this.city,
    required this.username,
    required this.password,
    required this.role,
    this.birthDate,
    required this.weight,
    required this.height,
    this.activityLevel,
    this.goal,
    this.deleted,
    this.enabled,
    this.biography,
    this.specialtyList,
    this.gymName,
    this.gymLocation,
    this.enrolledClasses,
    this.paymentStatus,
    this.debt,
    this.attendanceDays,
    this.createdDate,
    this.updatedDate,
    this.routines,
    this.exercises,
    this.nutritionPlans,
    this.achievements,
    this.classReservations,
    this.workoutLogs,
    this.mealLogs,
    this.musclePainLogs,
    this.attendance,
    this.injuriesList,
      this.gymBros,
    this.churn,
    this.token,
  });

  factory GymUser.fromJson(Map<String, dynamic> json) {
    return GymUser(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dni: json['dni'],
      postalCode: json['postalCode'],
      province: json['province'],
      city: json['city'],
      username: json['username'],
      password: json['password'],
      role: json['role'],
      birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      weight: json['weight'].toDouble(),
      height: json['height'].toDouble(),
      activityLevel: json['activityLevel'],
      goal: json['goal'],
      deleted: json['deleted'],
      enabled: json['enabled'],
      biography: json['biography'],
      specialtyList: json['specialtyList'] != null ? (json['specialtyList'] as List).map((e) => Speciality.fromJson(e)).toList() : null,
      gymName: json['gymName'],
      gymLocation: json['gymLocation'],
      enrolledClasses: json['enrolledClasses'] != null ? (json['enrolledClasses'] as List).map((e) => GymClass.fromJson(e)).toList() : null,
      paymentStatus: json['paymentStatus'],
      debt: json['debt']?.toDouble(),
      attendanceDays: json['attendanceDays'] != null ? (json['attendanceDays'] as List).map((e) => DateTime.parse(e)).toSet() : null,
      createdDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']) : null,
      updatedDate: json['updatedDate'] != null ? DateTime.parse(json['updatedDate']) : null,
     routines: json['routines'] != null ? (json['routines'] as List).map((e) => Routine.fromJson(e)).toList() : null,

      exercises: json['exercises'] != null ? (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList() : null,
      nutritionPlans: json['nutritionPlans'] != null ? (json['nutritionPlans'] as List).map((e) => NutritionPlan.fromJson(e)).toList() : null,
      achievements: json['achievements'] != null ? (json['achievements'] as List).map((e) => Achievement.fromJson(e)).toList() : null,
      classReservations: json['classReservations'] != null ? (json['classReservations'] as List).map((e) => ClassReservation.fromJson(e)).toList() : null,
      workoutLogs: json['workoutLogs'] != null ? (json['workoutLogs'] as List).map((e) => WorkoutLog.fromJson(e)).toList() : null,
      mealLogs: json['mealLogs'] != null ? (json['mealLogs'] as List).map((e) => MealLog.fromJson(e)).toList() : null,
      musclePainLogs: json['musclePainLogs'] != null ? (json['musclePainLogs'] as List).map((e) => MusclePainLog.fromJson(e)).toList() : null,
      attendance: json['attendance'] ?? 0,
      injuriesList: json['injuriesList'] != null ? (json['injuriesList'] as List).map((e) => UserInjury.fromJson(e)).toSet() : null,
       gymBros: json['gymBros'] != null ? (json['gymBros'] as List).map((e) => GymUser.fromJson(e)).toList() : null,
      churn: json['churn'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dni': dni,
      'postalCode': postalCode,
      'province': province,
      'city': city,
      'username': username,
      'password': password,
      'role': role,
      'birthDate': birthDate?.toIso8601String(),
      'weight': weight,
      'height': height,
      'activityLevel': activityLevel,
      'goal': goal,
      'deleted': deleted,
      'enabled': enabled,
      'biography': biography,
      'specialtyList': specialtyList?.map((e) => e.toJson()).toList(),
      'gymName': gymName,
      'gymLocation': gymLocation,
      'enrolledClasses': enrolledClasses?.map((e) => e.toJson()).toList(),
      'paymentStatus': paymentStatus,
      'debt': debt,
      'attendanceDays': attendanceDays?.map((e) => e.toIso8601String()).toList(),
      'createdDate': createdDate?.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
      'routines': routines?.map((e) => e.toJson()).toList(),
      'exercises': exercises?.map((e) => e.toJson()).toList(),
      'nutritionPlans': nutritionPlans?.map((e) => e.toJson()).toList(),
      'achievements': achievements?.map((e) => e.toJson()).toList(),
      'classReservations': classReservations?.map((e) => e.toJson()).toList(),
      'workoutLogs': workoutLogs?.map((e) => e.toJson()).toList(),
      'mealLogs': mealLogs?.map((e) => e.toJson()).toList(),
      'musclePainLogs': musclePainLogs?.map((e) => e.toJson()).toList(),
      'attendance': attendance,
      'injuriesList': injuriesList?.map((e) => e.toJson()).toList(),
        'gymBros': gymBros?.map((e) => e.toJson()).toList(),
      'churn': churn,
      'token': token,
    };
  }
}