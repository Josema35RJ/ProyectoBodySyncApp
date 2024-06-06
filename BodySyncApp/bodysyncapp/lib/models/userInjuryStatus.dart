import 'package:bodysyncapp/models/gymUser.dart';
import 'package:bodysyncapp/models/userInjury.dart';
import 'package:intl/intl.dart';

class UserInjuryStatus {
  int id;
  GymUser? gymUser;
  UserInjury userInjury;
  List<DateTime> activationDates = [];
  List<DateTime> deactivationDates = [];
  bool isActive;

  UserInjuryStatus({
    required this.id,
    this.gymUser,
    required this.userInjury,
    required this.activationDates,
    required this.deactivationDates,
    required this.isActive,
  });

  // Métodos para activar y desactivar la lesión
  void activate() {
    isActive = true;
    activationDates.add(DateTime.now());
  }

  void deactivate() {
    isActive = false;
    deactivationDates.add(DateTime.now());
  }

  // Método para obtener el formato de fecha
  String formattedDate(DateTime date) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss').format(date);
  }

  factory UserInjuryStatus.fromJson(Map<String, dynamic> json) {
    return UserInjuryStatus(
      id: json['id'] ?? 0,
      gymUser: json['gymUser'] != null ? GymUser.fromJson(json['gymUser']) : null,
      userInjury: UserInjury.fromJson(json['userInjury'] ?? {}),
      activationDates: List<DateTime>.from(json['activationDates']?.map((date) => DateTime.parse(date)) ?? []),
      deactivationDates: List<DateTime>.from(json['deactivationDates']?.map((date) => DateTime.parse(date)) ?? []),
      isActive: json['active'] ?? false,
    );
  }

  // Método para convertir el objeto a un mapa
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gymUser': gymUser?.toJson(),
      'userInjury': userInjury.toJson(),
      'activationDates': activationDates.map(formattedDate).toList(),
      'deactivationDates': deactivationDates.map(formattedDate).toList(),
      'active': isActive,
    };
  }

  @override
  String toString() {
    return 'UserInjuryStatus{id: $id, gymUser: $gymUser, userInjury: $userInjury, '
        'activationDates: $activationDates, deactivationDates: $deactivationDates, '
        'isActive: $isActive}';
  }
}
