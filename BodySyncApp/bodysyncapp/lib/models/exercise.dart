class Exercise {
  int id;
  String? name;
  String description;
  String muscleGroup;
  String necessaryEquipment;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.muscleGroup,
    required this.necessaryEquipment,
  });

 factory Exercise.fromJson(Map<String, dynamic> json) {
  if (json['description'] == null || json['muscleGroup'] == null || json['necessaryEquipment'] == null) {
    throw FormatException('Invalid JSON: missing required fields');
  }

  return Exercise(
    id: json['id'] ?? 0,
    name: json['name'] ?? 'Nombre no disponible',
    description: json['description'],
    muscleGroup: json['muscleGroup'],
    necessaryEquipment: json['necessaryEquipment'],
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'muscleGroup': muscleGroup,
      'necessaryEquipment': necessaryEquipment,
    };
  }
}
