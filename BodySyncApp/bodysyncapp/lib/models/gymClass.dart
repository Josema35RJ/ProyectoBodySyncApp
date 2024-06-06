import 'package:flutter/material.dart';

class GymClass {
  int id;
  String name;
  String description;
  DateTime startDate;
  DateTime endDate;
  List<String> daysOfWeek;
  TimeOfDay time;
  int duration;
  int maximumCapacity;
  int instructorId;
  bool active;
  List<int>? attendeeIds;
  List<int>? reservationIds;

  GymClass({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.daysOfWeek,
    required this.time,
    required this.duration,
    required this.maximumCapacity,
    required this.instructorId,
    required this.active,
     this.attendeeIds,
    this.reservationIds,
  });

  factory GymClass.fromJson(Map<String, dynamic> json) {
    // Parse time from string in format 'HH:MM:SS'
    List<String> timeParts = (json['time'] as String).split(':');
    TimeOfDay classTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    return GymClass(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      daysOfWeek: List<String>.from(json['daysOfWeek']),
      time: classTime,
      duration: json['duration'] ?? 0, // Verificar nulidad y proporcionar un valor predeterminado
      maximumCapacity: json['maximumCapacity'] ?? 0, // Verificar nulidad y proporcionar un valor predeterminado
      instructorId: json['instructorId'] ?? 0, // Verificar nulidad y proporcionar un valor predeterminado
      active: json['active'] ?? false, // Verificar nulidad y proporcionar un valor predeterminado
      attendeeIds: json['attendeeIds'] != null ? List<int>.from(json['attendeeIds']) : [], // Manejar la lista nula
      reservationIds: json['reservationIds'] != null ? List<int>.from(json['reservationIds']) : [], // Manejar la lista nula
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'daysOfWeek': daysOfWeek,
      'time': '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00',
      'duration': duration,
      'maximumCapacity': maximumCapacity,
      'instructorId': instructorId,
      'active': active,
      'attendeeIds': attendeeIds,
      'reservationIds': reservationIds,
    };
  }
}
