import 'package:bodysyncapp/models/gymClass.dart';
import 'package:bodysyncapp/presentation/instructor/memberInstructor.screen.dart';
import 'package:bodysyncapp/services/login.service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeInstructorScreen extends StatefulWidget {
  static const String name = 'homeInstructor_screen';
  static GymClass? selectedGymClass; // Variable para almacenar el GymClass seleccionado

  const HomeInstructorScreen({super.key});

  @override
  _HomeInstructorScreenState createState() => _HomeInstructorScreenState();
}

class _HomeInstructorScreenState extends State<HomeInstructorScreen> {
  late Future<List<GymClass>> _futureClasses;
  late String token;

  @override
  void initState() {
    super.initState();
    _futureClasses = fetchInstructorClasses();

  }

  Future<List<GymClass>> fetchInstructorClasses() async {
    final result = await UserService().getInstructorClasses(int.parse(UserService.userId));
    if (result.isNotEmpty) {
      return result;
    } else {
      throw Exception('No hay clases disponibles para este instructor.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            onPressed: () async {
              bool confirmar = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cerrar sesión'),
                  content: const Text('¿Está seguro de que desea cerrar sesión?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              );

              if (confirmar == true) {
                // Aquí puedes manejar el cierre de sesión
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¡Bienvenido!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tus clases:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<GymClass>>(
                future: _futureClasses,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final clases = snapshot.data!;
                    if (clases.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay clases disponibles para ti.',
                          style: TextStyle(fontSize: 18.0, color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: clases.length,
                      itemBuilder: (context, index) {
                        final clase = clases[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                            leading: const Icon(Icons.fitness_center, color: Colors.teal, size: 40),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  clase.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Instructor: ${clase.instructorId} ${clase.instructorId}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(clase.description),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 16, color: Colors.teal),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Fecha: ${clase.startDate.toLocal().toString().split(' ')[0]} - ${clase.endDate.toLocal().toString().split(' ')[0]}',
                                      style: const TextStyle(fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 16, color: Colors.teal),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Horario: ${clase.time.format(context)}',
                                      style: const TextStyle(fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.timer, size: 16, color: Colors.teal),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Duración: ${clase.duration} minutos',
                                      style: const TextStyle(fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.people, size: 16, color: Colors.teal),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Capacidad máxima: ${clase.maximumCapacity}',
                                      style: const TextStyle(fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal),
                            onTap: () {
                              HomeInstructorScreen.selectedGymClass = clase; // Actualizar el GymClass seleccionado
                              context.pushNamed(HomeMemberScreen.name);
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
