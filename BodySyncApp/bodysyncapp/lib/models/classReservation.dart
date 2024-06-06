class ClassReservation {
  int id;
  int gymUserId;
  DateTime reservedAt;
  DateTime classStartTime;
  String className;

  ClassReservation({
    required this.id,
    required this.gymUserId,
    required this.reservedAt,
    required this.classStartTime,
    required this.className,
  });

  factory ClassReservation.fromJson(Map<String, dynamic> json) {
    return ClassReservation(
      id: json['id'],
      gymUserId: json['gymUserId'],
      reservedAt: DateTime.tryParse(json['reservedAt'] ?? '') ?? DateTime.now(),
      classStartTime: DateTime.tryParse(json['classStartTime'] ?? '') ?? DateTime.now(),
      className: json['className'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gymUserId': gymUserId,
      'reservedAt': reservedAt.toIso8601String(),
      'classStartTime': classStartTime.toIso8601String(),
      'className': className,
    };
  }
}
