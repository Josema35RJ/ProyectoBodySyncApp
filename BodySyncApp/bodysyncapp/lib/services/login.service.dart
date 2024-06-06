import 'dart:convert';

import 'package:bodysyncapp/models/classReservation.dart';
import 'package:bodysyncapp/models/exercise.dart';
import 'package:bodysyncapp/models/gymClass.dart';
import 'package:bodysyncapp/models/gymUser.dart';
import 'package:bodysyncapp/models/routine.dart';
import 'package:bodysyncapp/models/userInjuryStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserService extends ChangeNotifier {
  final String baseURL = 'https://proyectointegradobodysyncapi.onrender.com';
  final storage = const FlutterSecureStorage();

  static String userEmail = '';
  static String userId = '';
  static String userRole = '';

  bool isLoading = true;
  String user = '';

  Future<String> register(GymUser gymUser) async {
  print(gymUser.toJson());
    final url = Uri.parse('$baseURL/register');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        
        body: json.encode(gymUser.toJson()),
      );

      final Map<String, dynamic> decoded = json.decode(response.body);

      if (decoded['success'] == true) {
        return 'success';
      } else {
        return handleRegisterError(decoded);
      }
    } catch (e) {
      return 'Error al conectar con el servidor: $e';
    }
  }

  Future<String?> login(String username, String password) async {
    final url =
        Uri.parse('$baseURL/login?username=$username&password=$password');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );

      final Map<String, dynamic> decoded = json.decode(response.body);

      if (decoded['success'] == true) {
        UserService.userId = decoded['data']['id'].toString();
        UserService.userEmail = username;
        UserService.userRole = decoded['data']['ROL'];

        await storage.write(key: 'token', value: decoded['data']['token']);
        await storage.write(key: 'id', value: decoded['data']['id'].toString());
        return 'success';
      } else {
        return handleLoginError(decoded);
      }
    } catch (e) {
      return 'Error al conectar con el servidor: $e';
    }
  }

  Future<List<GymClass>> getInstructorClasses(int id) async {
    final url = Uri.parse('$baseURL/apiGymInstructor/getClases/$id');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await storage.read(key: 'token')}',
        },
      );

      final decoded = json.decode(response.body);
      print("hola" + decoded);
      if (decoded['success'] == true && decoded['data'] != null) {
        List<dynamic> classesData = decoded['data'];
        List<GymClass> classes = classesData.map<GymClass>((classData) {
          return GymClass.fromJson(classData);
        }).toList();
        return classes;
      } else {
        throw Exception(decoded['message'] ??
            'No hay clases disponibles para este instructor.');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  String handleRegisterError(Map<String, dynamic> decoded) {
    if (decoded['message'] == "El correo electrónico ya está registrado") {
      return 'El correo electrónico ya está registrado';
    } else {
      return 'Error: ${decoded['message']}';
    }
  }

  String handleLoginError(Map<String, dynamic> decoded) {
    if (decoded['message'] == "Usuario o clave incorrectos") {
      return 'Usuario o contraseña incorrectos';
    } else if (decoded['message'] == "Error al iniciar sesion") {
      return 'Usuario o contraseña incorrectos';
    } else if (decoded['message'] == "El usuario no esta activado") {
      return 'El usuario no esta activado';
    } else if (decoded['message'] == "El usuario ha sido borrado") {
      return 'El usuario ha sido borrado';
    } else {
      return decoded['message'];
    }
  }

  String handleGetClassesError(Map<String, dynamic> decoded) {
    if (decoded['message'] == "No tienes permiso para ver estos servicios") {
      return 'No tienes permiso para ver estos servicios';
    } else {
      return 'Error: ${decoded['message']}';
    }
  }

  Future<List<GymUser>> getMembersByClassId(int id) async {
    final url = Uri.parse('$baseURL/apiGymInstructor/getMiembros/$id');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await storage.read(key: 'token')}',
        },
      );

      final decoded = json.decode(response.body);
      if (decoded['success'] == true && decoded['data'] != null) {
        List<dynamic> membersData = decoded['data'];
        List<GymUser> members = membersData.map<GymUser>((memberData) {
          return GymUser.fromJson(memberData);
        }).toList();
        return members;
      } else {
        throw Exception(decoded['message'] ?? 'Error fetching members');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<List<GymClass>> getClassesByUserId(int id) async {
    final url = Uri.parse('$baseURL/apiGymUser/getClases/$id');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await storage.read(key: 'token')}',
        },
      );

      final decoded = json.decode(response.body);
      if (decoded['success'] == true && decoded['data'] != null) {
        List<dynamic> classesData = decoded['data'];
        List<GymClass> classes = classesData.map<GymClass>((classData) {
          return GymClass.fromJson(classData);
        }).toList();
        return classes;
      } else {
        throw Exception(decoded['message'] ?? 'Error fetching classes');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<List<Routine>> getRoutines() async {
    final url = Uri.parse('$baseURL/apiGymUser/Routine');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await storage.read(key: 'token')}',
        },
      );

      final decoded = json.decode(response.body);
      if (decoded['success'] == true && decoded['data'] != null) {
        List<dynamic> routinesData = decoded['data'];
        List<Routine> routines = routinesData.map<Routine>((routineData) {
          return Routine.fromJson(routineData);
        }).toList();
        return routines;
      } else {
        throw Exception(decoded['message'] ?? 'Error fetching routines');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<List<ClassReservation>> getClassReservations() async {
    final url = Uri.parse('$baseURL/apiGymUser/ClassReservation');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await storage.read(key: 'token')}',
        },
      );

      final decoded = json.decode(response.body);
      if (decoded['success'] == true && decoded['data'] != null) {
        List<dynamic> reservationsData = decoded['data'];
        List<ClassReservation> reservations =
            reservationsData.map<ClassReservation>((reservationData) {
          return ClassReservation.fromJson(reservationData);
        }).toList();
        return reservations;
      } else {
        throw Exception(
            decoded['message'] ?? 'Error fetching class reservations');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<List<GymUser>> getInstructors() async {
    final url = Uri.parse('$baseURL/apiGymUser/Instructors');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await storage.read(key: 'token')}',
        },
      );

      final decoded = json.decode(response.body);
      if (decoded['success'] == true && decoded['data'] != null) {
        List<dynamic> instructorsData = decoded['data'];
        List<GymUser> instructors =
            instructorsData.map<GymUser>((instructorData) {
          return GymUser.fromJson(instructorData);
        }).toList();
        return instructors;
      } else {
        throw Exception(decoded['message'] ?? 'Error fetching instructors');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<List<GymUser>> getGymUsers() async {
    final url = Uri.parse('$baseURL/apiGymUser/GymUsers');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await storage.read(key: 'token')}',
        },
      );

      final decoded = json.decode(response.body);
      if (decoded['success'] == true && decoded['data'] != null) {
        List<dynamic> gymUsersData = decoded['data'];
        List<GymUser> gymUsers = gymUsersData.map<GymUser>((gymUserData) {
          return GymUser.fromJson(gymUserData);
        }).toList();
        return gymUsers;
      } else {
        throw Exception(decoded['message'] ?? 'Error fetching gym users');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<GymUser> getGymUserById() async {
    final url = Uri.parse('$baseURL/apiGymUser/getGymUser/$userId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await storage.read(key: 'token')}',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          return GymUser.fromJson(decoded['data']);
        } else {
          throw Exception(decoded['message'] ?? 'Error fetching gym user');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<List<GymClass>> listGymClasses() async {
    final url = Uri.parse('$baseURL/apiGymUser/ListClass');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await storage.read(key: 'token')}',
        },
      );

      final decoded = json.decode(response.body);
      if (decoded['success'] == true && decoded['data'] != null) {
        List<dynamic> classesData = decoded['data'];
        List<GymClass> classes = classesData.map<GymClass>((classData) {
          return GymClass.fromJson(classData);
        }).toList();
        return classes;
      } else {
        throw Exception(decoded['message'] ?? 'Error fetching gym classes');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // Método para actualizar los días de asistencia
Future<void> updateAttendanceDays(Set<DateTime> attendanceDays) async {
  try {
    final url = Uri.parse('$baseURL/apiGymUser/updateAttendanceDays/$userId');
    final response = await http.put(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await storage.read(key: 'token')}',
      },
      body: json.encode(
        attendanceDays.map((day) => day.toIso8601String().substring(0, 10)).toList(),
      ),
    );

    final decoded = json.decode(response.body);
    if (response.statusCode == 200 && decoded['success'] == true) {
      // Handle success here
    } else {
      throw Exception(decoded['message'] ?? 'Error updating attendance days');
    }
  } catch (e) {
    throw Exception('Error updating attendance days: $e');
  }
}



Future<int> countClassMusculationUsers() async {
  final url = Uri.parse('$baseURL/apiGymUser/CountMusculationUsers');
  try {
    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await storage.read(key: 'token')}',
      },
    );

    if (response.statusCode == 200) {
      return int.parse(response.body); // Devuelve directamente el cuerpo como entero
    } else {
      throw Exception('Error al contar usuarios de musculación: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error contando usuarios de musculación: $e');
  }
}

 
Future<List<UserInjuryStatus>> listUserInjuryStatus() async {
  final url = Uri.parse('$baseURL/apiGymUser/UserInjuryStatus/$userId');
  try {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['success'] == true && decoded['data'] != null) {
      
        List<dynamic> userInjuryStatusData = decoded['data'];
       
        List<UserInjuryStatus> userInjuryStatus =
            userInjuryStatusData.map<UserInjuryStatus>((userInjuryStatusData ) {
                 
          return UserInjuryStatus.fromJson(userInjuryStatusData );
        }).toList();
        return userInjuryStatus;
      } else {
        throw Exception('Error fetching user injury status: ${decoded['message']}');
      }
    } else {
      throw Exception('Error fetching user injury status: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error connecting to server: $e');
  }
}


  Future<void> addUserInjury(String userInjuryId) async {
  final url = Uri.parse('$baseURL/apiGymUser/UserInjury/$userId');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await storage.read(key: 'token')}',
      },
      body: userInjuryId, // Envía solo el userInjuryId como el cuerpo de la solicitud
    );

    final decoded = json.decode(response.body);
    if (response.statusCode == 200 && decoded['success'] == true) {
    } else {
      throw Exception(decoded['message'] ?? 'Error adding user injury');
    }
  } catch (e) {
    throw Exception('Error connecting to server: $e');
  }
}


  Future<List<Exercise>> listExercises() async {
    final url = Uri.parse('$baseURL/apiGymUser/Exercises');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await storage.read(key: 'token')}',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          List<dynamic> exercisesData = decoded['data'];
          List<Exercise> exercises =
              exercisesData.map<Exercise>((exerciseData) {
            return Exercise.fromJson(exerciseData);
          }).toList();
          return exercises;
        } else {
          throw Exception(decoded['message'] ?? 'Error fetching exercises');
        }
      } else {
        throw Exception('Failed to load exercises: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<void> addUserClass(int classId) async {
    final url = Uri.parse('$baseURL/apiGymUser/addUserClass/$userId');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await storage.read(key: 'token')}',
        },
        body: json.encode(classId),
      );

      final decoded = json.decode(response.body);
      if (decoded['success'] == true) {
        // Handle success
      } else {
        throw Exception(decoded['message'] ?? 'Error adding user class');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<List<GymUser>> listGymUsers() async {
  final url = Uri.parse('$baseURL/apiGymUser/ListGymUser');
  try {
    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await storage.read(key: 'token')}',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['success'] == true && decoded['data'] != null) {
        List<dynamic> gymUsersData = decoded['data'];
        List<GymUser> gymUsers = gymUsersData.map<GymUser>((gymUserData) {
          return GymUser.fromJson(gymUserData);
        }).toList();
        return gymUsers;
      } else {
        throw Exception(decoded['message'] ?? 'Error fetching gym users');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error connecting to server: $e');
  }
}

}
