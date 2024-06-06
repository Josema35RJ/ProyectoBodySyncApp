import 'package:bodysyncapp/models/gymUser.dart';
import 'package:bodysyncapp/services/login.service.dart';
import 'package:flutter/material.dart';

class GymBrosScreen extends StatefulWidget {
  static const String name = 'gymBro_screen';

  @override
  _GymBrosScreenState createState() => _GymBrosScreenState();
}

class _GymBrosScreenState extends State<GymBrosScreen> {
  late Future<GymUser?> _gymUserFuture;

  @override
  void initState() {
    super.initState();
    _gymUserFuture = _fetchGymUser();
  }

  Future<GymUser?> _fetchGymUser() async {
    try {
      String userIdString = UserService.userId.toString();
      GymUser response = await UserService().getGymUserById();
      return response;
    } catch (e) {
      print('Error al obtener el usuario: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gym Bros'),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () => _onAddFriendPressed(context),
          ),
          IconButton(
            icon: Icon(Icons.person_remove),
            onPressed: _onDeleteFriendPressed,
          ),    
        ],
      ),
      body: FutureBuilder<GymUser?>(
        future: _gymUserFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), 
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'), 
            );
          } else if (snapshot.hasData) {
            GymUser? user = snapshot.data;
            if (user != null) {
              List<GymUser>? gymBros = user.gymBros;
              return _buildGymBrosScreen(gymBros!);
            } else {
              return Center(
                child: Text('Usuario no encontrado'),
              );
            }
          } else {
            return Center(
              child: Text('Sin datos'),
            );
          }
        },
      ),
    );
  }

  Widget _buildGymBrosScreen(List<GymUser> gymBros) {
    return ListView.builder(
      itemCount: gymBros.length,
      itemBuilder: (context, index) {
        final gymBro = gymBros[index];
        return Card(
          margin: EdgeInsets.all(16.0),
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                    ),
                    SizedBox(width: 16.0),
                    Text(
                      gymBro.firstName,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildModernButton(
                      context,
                      'Challenge',
                      () => _onChallengePressed(gymBro.firstName),
                    ),
                    _buildModernButton(
                      context,
                      'Routines',
                      () => _onViewRoutinesPressed(gymBro.firstName),
                    ),
                    _buildModernButton(
                      context,
                      'Exercises',
                      () => _onViewExercisesPressed(gymBro.firstName),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernButton(BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        textStyle: TextStyle(
          fontSize: 14.0,
        ),
        elevation: 6.0,
        shadowColor: Colors.black.withOpacity(0.2),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }

  void _onAddFriendPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar amigo'),
          content: FutureBuilder<List<GymUser>>(
            future: UserService().listGymUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(), 
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'), 
                );
              } else if (snapshot.hasData) {
                List<GymUser> gymUsers = snapshot.data!;
                return Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: gymUsers.length,
                    itemBuilder: (context, index) {
                      final gymUser = gymUsers[index];
                      return ListTile(
                        title: Text(gymUser.firstName),
                        onTap: () {
                          print('Añadir ${gymUser.firstName}');
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: Text('Sin datos'),
                );
              }
            },
          ),
        );
      },
    );
  }

  void _onDeleteFriendPressed() {
    print('Delete friend pressed');
  }

  void _onChallengePressed(String userName) {
    print('Challenge pressed for $userName');
  }

  void _onViewRoutinesPressed(String userName) {
    print('View routines pressed for $userName');
  }

  void _onViewExercisesPressed(String userName) {
    print('View exercises pressed for $userName');
  }
}
