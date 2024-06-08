import 'dart:async';

import 'package:bodysyncapp/models/exercise.dart';
import 'package:bodysyncapp/models/gymClass.dart';
import 'package:bodysyncapp/models/gymUser.dart';
import 'package:bodysyncapp/models/mealLog.dart';
import 'package:bodysyncapp/presentation/miembros/gymBrosScreen.dart';
import 'package:bodysyncapp/presentation/miembros/musclePainLogScreen.dart';
import 'package:bodysyncapp/services/login.service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

class GymUserScreen extends StatefulWidget {
  static const String name = 'gym_user_screen';

  const GymUserScreen({Key? key});

  @override
  _GymUserScreenState createState() => _GymUserScreenState();
}

class _GymUserScreenState extends State<GymUserScreen> {
  late Future<GymUser?> _gymUserFuture;
  int _selectedIndex = 0;
  int? _muscleClassEnrolledPeople = 0;

  @override
  void initState() {
    super.initState();
    _gymUserFuture = _fetchGymUser();
    _fetchMuscleClassEnrolledPeople();
  }

  Future<GymUser?> _fetchGymUser() async {
    try {
      String userIdString = UserService.userId.toString();
      GymUser response =
          await UserService().getGymUserById();
      return response;
    } catch (e) {
      print('Error al obtener el usuario: $e');
      return null;
    }
  }

  Future<void> _fetchMuscleClassEnrolledPeople() async {
    try {
      int enrolledPeople = await UserService().countClassMusculationUsers();
      setState(() {
        _muscleClassEnrolledPeople = enrolledPeople;
      });
    } catch (e) {
      print('Error al obtener el número de personas apuntadas a la clase de musculación: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Bienvenido De Nuevo',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_list_numbered_sharp),
            onPressed: () {
              context.pushNamed(GymBrosScreen.name);
            },
          ),
           IconButton(
            icon: const Icon(Icons.personal_injury),
            onPressed: () {
              context.pushNamed(MusclePainLogScreen.name);
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildCalendarAndAnnouncements();
      case 1:
        return _buildClassesSection();
      case 2:
        return _buildTrainingLogSection();
      case 3:
        return _buildNutritionPlansSection();
      case 4:
        return _buildAchievementsSection();
      case 5:
        return _buildCustomRoutinesSection();
      case 7:
        return const MusclePainLogScreen(
          gymUserId: 54,
        );
      default:
        return Container(); // Placeholder
    }
  }
 Widget _buildCalendarAndAnnouncements() {
    return FutureBuilder<GymUser?>(
      future: _gymUserFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final gymUser = snapshot.data;
          if (gymUser == null) {
            return const Center(
              child: Text(
                'No se encontraron datos del usuario del gimnasio.',
                style: TextStyle(fontSize: 16.0),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildCalendarSection(gymUser),
              const SizedBox(height: 20),
              _buildAnnouncementsSection(),
            ],
          );
        }
      },
    );
  }

  Widget _buildCalendarSection(GymUser gymUser) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Calendario de Asistencia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          TableCalendar(
            calendarFormat: CalendarFormat.month,
            focusedDay: DateTime.now(),
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2024, 12, 31),
            selectedDayPredicate: (day) {
              // Verifica si el día está en la lista de días de asistencia y si no es un día pasado.
              return gymUser.attendanceDays?.contains(day) ?? false && !isPastDay(day);
            },
            eventLoader: (day) {
              List<dynamic> events = [];
              if (gymUser.attendanceDays?.contains(day) ?? false) {
                events.add(Icon(Icons.check, color: Colors.green)); // Icono de checkmark verde para indicar asistencia
              }
              return events;
            },
            onDaySelected: (selectedDay, focusedDay) async {
              if (!isPastDay(selectedDay)) {
                setState(() {
                  if (gymUser.attendanceDays?.contains(selectedDay) ?? false) {
                    gymUser.attendanceDays?.remove(selectedDay);
                  } else {
                    gymUser.attendanceDays?.add(selectedDay);
                  }
                });
                try {
                  await UserService().updateAttendanceDays(gymUser.attendanceDays!);
                } catch (e) {
                  print('Error actualizando días de asistencia: $e');
                }
              }
            },
          ),
        ],
      ),
    );
  }


  bool isPastDay(DateTime day) {
    final now = DateTime.now();
    return day.isBefore(DateTime(now.year, now.month, now.day));
  }

  

 Widget buildCalendarSection(GymUser gymUser) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Calendario de Asistencia',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        TableCalendar(
          calendarFormat: CalendarFormat.month,
          focusedDay: DateTime.now(),
          firstDay: DateTime.utc(2022, 1, 1),
          lastDay: DateTime.utc(2024, 12, 31),
          selectedDayPredicate: (day) {
            // Verifica si el día está en la lista de días de asistencia y si no es un día pasado.
            return gymUser.attendanceDays?.contains(day) ?? false && !isPastDay(day);
          },
          eventLoader: (day) {
            List<dynamic> events = [];
            if (gymUser.attendanceDays?.contains(day) ?? false) {
              events.add('Asistencia al gimnasio');
            }
            return events;
          },
          onDaySelected: (selectedDay, focusedDay) async {
            if (!isPastDay(selectedDay)) {
              setState(() {
                if (gymUser.attendanceDays?.contains(selectedDay) ?? false) {
                  gymUser.attendanceDays?.remove(selectedDay);
                } else {
                  gymUser.attendanceDays?.add(selectedDay);
                }
              });
              try {
                await UserService().updateAttendanceDays(gymUser.attendanceDays!);
              } catch (e) {
                print('Error actualizando días de asistencia: $e');
              }
            }
          },
        ),
      ],
    ),
  );
}

  Widget _buildAnnouncementsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Anuncios y Novedades',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          _buildAnnouncementItem(
              '¡Nueva clase de spinning todos los jueves a las 18:00!'),
          _buildAnnouncementItem(
              'Horario especial de apertura el próximo sábado de 9:00 a 14:00'),
          _buildAnnouncementItem(
              '¡Promoción especial de verano! ¡Descuento del 20% en membresías familiares!'),
        ],
      ),
    );
  }

  Widget _buildAnnouncementItem(String text) {
    return ListTile(
      title: Text(
        text,
        style: const TextStyle(color: Colors.black87),
      ),
      leading: const Icon(Icons.notifications, color: Colors.blue),
    );
  }

  Widget _buildClassesSection() {
    return FutureBuilder<GymUser?>(
      future: _gymUserFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final gymUser = snapshot.data;
          if (gymUser == null) {
            return const Center(
              child: Text(
                'No se encontraron datos del usuario del gimnasio.',
                style: TextStyle(fontSize: 16.0),
              ),
            );
          }
          return _buildClassesContent(gymUser);
        }
      },
    );
  }

Widget _buildClassesContent(GymUser gymUser) {
  return FutureBuilder<List<GymClass>>(
    future: UserService().listGymClasses(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        final classes = snapshot.data!;
        // Filtra las clases inscritas por el usuario
        final enrolledClasses = gymUser.enrolledClasses ?? [];
        final List<GymClass> userEnrolledClasses = classes.where((gymClass) =>
            enrolledClasses.any((enrolledClass) => enrolledClass.id == gymClass.id)).toList();

        // Filtra las nuevas clases disponibles
        final List<GymClass> newClasses = classes.where((gymClass) =>
            !enrolledClasses.any((enrolledClass) => enrolledClass.id == gymClass.id)).toList();

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_muscleClassEnrolledPeople != null)
                ListTile(
                  title: const Text(
                    'Musculación',
                    style: TextStyle(color: Colors.black87),
                  ),
                  trailing: Text(
                    '$_muscleClassEnrolledPeople personas apuntadas',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Clases del Usuario',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              // Mostrar las clases inscritas por el usuario
              if (userEnrolledClasses.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: userEnrolledClasses.length,
                  itemBuilder: (context, index) {
                    final gymClass = userEnrolledClasses[index];
                    return ListTile(
                      title: Text(gymClass.name,
                          style: const TextStyle(color: Colors.black87)),
                      subtitle: Text(gymClass.description,
                          style: const TextStyle(color: Colors.black54)),
                      trailing: Text('Fecha: ${gymClass.startDate}',
                          style: const TextStyle(color: Colors.black54)),
                    );
                  },
                ),
              // Mostrar mensaje si no hay clases inscritas
              if (userEnrolledClasses.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'No se encontraron clases inscritas.',
                      style: TextStyle(fontSize: 16.0, color: Colors.black87),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Nuevas Clases Disponibles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              // Mostrar las nuevas clases disponibles
              if (newClasses.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: newClasses.length,
                  itemBuilder: (context, index) {
                    final gymClass = newClasses[index];
                    return ListTile(
                      title: Text(gymClass.name,
                          style: const TextStyle(color: Colors.black87)),
                      trailing: ElevatedButton(
                        onPressed: () {
                          UserService().addUserClass(gymClass.id);
                        },
                        child: const Text('Inscribirse'),
                      ),
                    );
                  },
                ),
              // Mostrar mensaje si no hay nuevas clases disponibles
              if (newClasses.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'No hay nuevas clases disponibles.',
                      style: TextStyle(fontSize: 16.0, color: Colors.black87),
                    ),
                  ),
                ),
            ],
          ),
        );
      }
    },
  );
}


  Widget _buildTrainingLogSection() {
    return FutureBuilder<GymUser?>(
      future: _gymUserFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final gymUser = snapshot.data;
          if (gymUser == null) {
            return const Center(
              child: Text(
                'No se encontraron datos del usuario del gimnasio.',
                style: TextStyle(fontSize: 16.0),
              ),
            );
          }
          return _buildTrainingLogContent(gymUser);
        }
      },
    );
  }

 Widget _buildTrainingLogContent(
  GymUser gymUser, {
  String? muscleGroupFilter,
  String? necessaryEquipmentFilter,
}) {
  return FutureBuilder<List<Exercise>>(
    future: UserService().listExercises(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        final allExercises = snapshot.data ?? [];
        List<Exercise> userExercises = gymUser.exercises ?? [];

        if (muscleGroupFilter != null && muscleGroupFilter.isNotEmpty) {
          userExercises = userExercises
              .where((exercise) => exercise.muscleGroup == muscleGroupFilter)
              .toList();
        }

        if (necessaryEquipmentFilter != null &&
            necessaryEquipmentFilter.isNotEmpty) {
          userExercises = userExercises
              .where((exercise) =>
                  exercise.necessaryEquipment == necessaryEquipmentFilter)
              .toList();
        }

        // Filter exercises for carousel
        List<Exercise> carouselExercises = allExercises;
        if (muscleGroupFilter != null && muscleGroupFilter.isNotEmpty) {
          carouselExercises = carouselExercises
              .where((exercise) => exercise.muscleGroup == muscleGroupFilter)
              .toList();
        }

        if (necessaryEquipmentFilter != null &&
            necessaryEquipmentFilter.isNotEmpty) {
          carouselExercises = carouselExercises
              .where((exercise) =>
                  exercise.necessaryEquipment == necessaryEquipmentFilter)
              .toList();
        }

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ejercicios',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                if (carouselExercises.isNotEmpty)
                  SizedBox(
                    height: 250,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: carouselExercises.map((exercise) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: _buildExerciseCard(exercise),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                if (userExercises.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: userExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = userExercises[index];
                      return _buildUserExerciseTile(exercise);
                    },
                  ),
                if (userExercises.isEmpty && allExercises.isEmpty)
                  const Text(
                    'No se encontraron ejercicios.',
                    style: TextStyle(fontSize: 20.0, color: Colors.redAccent),
                  ),
              ],
            ),
          ),
        );
      }
    },
  );
}


  Widget _buildExerciseCard(Exercise exercise) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.fitness_center, color: Colors.blue),
          const SizedBox(height: 8),
          Text(
            exercise.name ?? '',
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Flexible( // Wrap the description text with Flexible
            child: Text(
              'Descripción: ${exercise.description}\n'
              'Grupo muscular: ${exercise.muscleGroup}\n'
              'Equipo necesario: ${exercise.necessaryEquipment}',
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildUserExerciseTile(Exercise exercise) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: const Icon(Icons.check_circle_outline, color: Colors.green),
        title: Text(
          exercise.name ?? '',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Grupo muscular: ${exercise.muscleGroup}\n'
          'Equipo necesario: ${exercise.necessaryEquipment}',
          style: const TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
  
void _showAddMealDialog() async {
  try {
    // Llama a listMealLog para obtener la lista de comidas
    List<MealLog> mealLogList = await UserService().listMealLog();

    // Variable para almacenar la comida seleccionada
    MealLog? selectedMeal;

    // Crea una lista de elementos ListTile para mostrar en el diálogo
    List<Widget> mealListTiles = mealLogList.map((meal) {
      return ListTile(
        title: Text(meal.mealDescription),
        subtitle: Text(meal.caloriesConsumed.toString()),
        onTap: () {
          // Actualiza la comida seleccionada
          selectedMeal = meal;
        },
      );
    }).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Comida'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: mealListTiles, // Mostrar la lista de comidas aquí
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedMeal != null) {
                  try {
                    // Llamar al servicio addMealLog
                    await UserService().addMealLog( selectedMeal!.id);
                    Navigator.of(context).pop(); // Cierra el diálogo
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Comida añadida con éxito'),
                    ));
                  } catch (e) {
                    // Manejar errores aquí, como mostrar un mensaje de error al usuario
                    print('Error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Error: $e'),
                    ));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Por favor seleccione una comida'),
                  ));
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    // Manejar errores aquí, como mostrar un mensaje de error al usuario
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error: $e'),
    ));
  }
}

Widget _buildNutritionPlansSection() {
  return FutureBuilder<GymUser?>(
    future: _gymUserFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        final gymUser = snapshot.data;
        if (gymUser == null) {
          return const Center(
            child: Text(
              'No se encontraron datos del usuario del gimnasio.',
              style: TextStyle(fontSize: 16.0),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNutritionPlansContent(gymUser),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showAddMealDialog(); // Llama al método para mostrar la ventana emergente.
                },
                child: Text('Agregar Comida'),
              ),
            ),
          ],
        );
      }
    },
  );
}

Widget _buildNutritionPlansContent(GymUser gymUser) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Nutrición y Dieta',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildNutritionSummary(gymUser),
        const SizedBox(height: 20),
        _buildMealLogs(gymUser),
      ],
    ),
  );
}

Widget _buildNutritionSummary(GymUser gymUser) {
  if (gymUser.nutritionPlans == null || gymUser.nutritionPlans!.isEmpty) {
    return const Center(
      child: Text(
        'No hay planes de nutrición disponibles.',
        style: TextStyle(fontSize: 16.0, color: Colors.black87),
      ),
    );
  } else {
    return ExpansionTile(
      title: const Text(
        'Planes de Nutrición',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Column(
          children: gymUser.nutritionPlans!.map((plan) {
            return ListTile(
              title: Text(plan.name),
              subtitle: Text(plan.description),
            );
          }).toList(),
        ),
      ],
    );
  }
}

Widget _buildMealLogs(GymUser gymUser) {
  if (gymUser.mealLogs == null || gymUser.mealLogs!.isEmpty) {
    return const Center(
      child: Text(
        'No hay registros de comidas.',
        style: TextStyle(fontSize: 16.0, color: Colors.black87),
      ),
    );
  } else {
    return ExpansionTile(
      title: const Text(
        'Registros de Comidas',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Column(
          children: gymUser.mealLogs!.map((log) {
            return ListTile(
              title: Text(log.mealDescription),
              subtitle: Text(log.caloriesConsumed.toString()),
            );
          }).toList(),
        ),
      ],
    );
  }
}

  Widget _buildAchievementsSection() {
    return FutureBuilder<GymUser?>(
      future: _gymUserFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final gymUser = snapshot.data;
          if (gymUser == null) {
            return const Center(
              child: Text(
                'No se encontraron datos del usuario del gimnasio.',
                style: TextStyle(fontSize: 16.0),
              ),
            );
          }
          return _buildAchievementsContent(gymUser);
        }
      },
    );
  }

  Widget _buildAchievementsContent(GymUser gymUser) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Logros del Usuario',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          if (gymUser.achievements != null && gymUser.achievements!.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              itemCount: gymUser.achievements!.length,
              itemBuilder: (context, index) {
                final achievement = gymUser.achievements![index];
                return ListTile(
                  title: Text(achievement.name,
                      style: const TextStyle(color: Colors.black87)),
                  subtitle: Text(achievement.description,
                      style: const TextStyle(color: Colors.black54)),
                );
              },
            ),
          if (gymUser.achievements == null || gymUser.achievements!.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No se encontraron logros.',
                  style: TextStyle(fontSize: 16.0, color: Colors.black87),
                ),
              ),
            ),
        ],
      ),
    );
  }

 Widget _buildCustomRoutinesSection() {
  return FutureBuilder<GymUser?>(
    future: _gymUserFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        final gymUser = snapshot.data;
        if (gymUser == null) {
          return const Center(
            child: Text(
              'No se encontraron datos del usuario del gimnasio.',
              style: TextStyle(fontSize: 16.0),
            ),
          );
        }
        return _buildCustomRoutinesContent(gymUser);
      }
    },
  );
}

Widget _buildCustomRoutinesContent(GymUser gymUser) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rutinas Personalizadas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          if (gymUser.routines != null && gymUser.routines!.isNotEmpty)
            Column(
              children: List.generate(
                gymUser.routines!.length,
                (index) {
                  final routine = gymUser.routines![index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rutina ${index + 1}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Días por semana: ${routine.daysPerWeek}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ejercicios:',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Column(
                        children: routine.exerciseList
                            .map(
                              (exercise) => Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Row(
                                  children: [
                                    const Icon(Icons.fitness_center, color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Text(
                                      exercise.name ?? 'Nombre no disponible',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const Divider(), // Añade un separador entre las rutinas
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
          if (gymUser.routines == null || gymUser.routines!.isEmpty)
            const Center(
              child: Text(
                'No se encontraron rutinas personalizadas.',
                style: TextStyle(fontSize: 16.0, color: Colors.black87),
              ),
            ),
        ],
      ),
    ),
  );
}


  Widget _buildNewsSection() {
    // Placeholder para sección de noticias
    return const Center(
      child: Text(
        'Sección de Noticias',
        style: TextStyle(fontSize: 18, color: Colors.blue),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      selectedItemColor: const Color.fromARGB(193, 54, 54, 54),
      unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendario',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Clases',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Registro',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Nutrición',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events),
          label: 'Logros',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Rutinas',
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
