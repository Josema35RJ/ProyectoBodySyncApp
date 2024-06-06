import 'dart:core';

class UserInjury {
  final int id;
  final String injuryName;
  final String description;
  final String severity;
  final DateTime startDate;
  final DateTime recoveryDate;

  UserInjury({
    required this.id,
    required this.injuryName,
    required this.description,
    required this.severity,
    required this.startDate,
    required this.recoveryDate,
  });

  factory UserInjury.fromJson(Map<String, dynamic> json) {
    return UserInjury(
      id: json['id'] ?? 0,
      injuryName: json['injuryName'] ?? '',
      description: json['description'] ?? '',
      severity: json['severity'] ?? '',
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      recoveryDate: DateTime.tryParse(json['recoveryDate'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'injuryName': injuryName,
      'description': description,
      'severity': severity,
      'startDate': startDate.toIso8601String(),
      'recoveryDate': recoveryDate.toIso8601String(),
    };
  }
}
