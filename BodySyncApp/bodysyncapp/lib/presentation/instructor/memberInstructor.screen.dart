import 'package:bodysyncapp/models/gymUser.dart';
import 'package:bodysyncapp/presentation/instructor/homeInstructor_screen.dart';
import 'package:bodysyncapp/services/login.service.dart';
import 'package:flutter/material.dart';

class HomeMemberScreen extends StatefulWidget {
  static const String name = 'memberInstructor_screen';

  const HomeMemberScreen({super.key});

  @override
  _HomeMemberScreenState createState() => _HomeMemberScreenState();
}

class _HomeMemberScreenState extends State<HomeMemberScreen> {
  late Future<List<GymUser>> _futureMembers;

  @override
  void initState() {
    super.initState();
    final selectedGymClass = HomeInstructorScreen.selectedGymClass;
    if (selectedGymClass != null) {
      _futureMembers = fetchMembers(selectedGymClass.id);
    } else {
      // Manejar el caso cuando no hay ningún GymClass seleccionado
      // Por ejemplo, puedes mostrar un mensaje de error o regresar a la pantalla anterior
    }
  }

  Future<List<GymUser>> fetchMembers(int classId) async {
    final result = await UserService().getMembersByClassId(classId);
    if (result.isNotEmpty) {
      return result;
    } else {
      throw Exception('No hay miembros disponibles.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Miembros de la Clase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<GymUser>>(
          future: _futureMembers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final members = snapshot.data!;
              if (members.isEmpty) {
                return const Center(
                  child: Text(
                    'No hay miembros inscritos en esta clase.',
                    style: TextStyle(fontSize: 18.0, color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                      leading: const Icon(Icons.person, color: Colors.teal, size: 40),
                      title: Text(
                        '${member.firstName} ${member.lastName}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'Correo electrónico: ${member.username}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                      onTap: () {
                        // Aquí puedes manejar la acción al hacer clic en un miembro
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
