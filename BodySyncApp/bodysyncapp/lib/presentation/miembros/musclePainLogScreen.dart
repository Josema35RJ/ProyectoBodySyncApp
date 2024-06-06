import 'package:bodysyncapp/models/gymUser.dart';
import 'package:bodysyncapp/models/userInjuryStatus.dart';
import 'package:bodysyncapp/services/login.service.dart';
import 'package:flutter/material.dart';

class MusclePainLogScreen extends StatefulWidget {
  final int gymUserId;
  static const String name = 'musclePainLog_screen';

  const MusclePainLogScreen({Key? key, required this.gymUserId}) : super(key: key);

  @override
  _MusclePainLogScreenState createState() => _MusclePainLogScreenState();
}

class _MusclePainLogScreenState extends State<MusclePainLogScreen> {
  bool _isLoading = true;
  GymUser? _gymUser;
  List<UserInjuryStatus> _userInjuryStatusList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      GymUser? gymUser = await _fetchGymUser();
      List<UserInjuryStatus> userInjuryStatusList = await _fetchUserInjuryStatus();
      if (mounted) {
        setState(() {
          _gymUser = gymUser;
          _userInjuryStatusList = userInjuryStatusList;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Error al cargar los datos: ${e.toString()}');
      }
    }
  }

  Future<GymUser?> _fetchGymUser() async {
    try {
      return await UserService().getGymUserById();
    } catch (e) {
      print('Error al obtener el usuario: $e');
      return null;
    }
  }

  Future<List<UserInjuryStatus>> _fetchUserInjuryStatus() async {
    try {
      return await UserService().listUserInjuryStatus();
    } catch (e) {
      print(e);
      throw Exception('Error al obtener estados de lesiones del usuario: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de Lesiones',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildUserInjuryStatusList(),
                    const SizedBox(height: 20),
                    // Add more widgets here if needed
                  ],
                ),
              ),
            ),
          ),
          // Add more widgets here if needed
        ],
      ),
    );
  }

  Widget _buildUserInjuryStatusList() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estado de Lesiones del Usuario:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _userInjuryStatusList.length,
            itemBuilder: (context, index) {
              final userInjuryStatus = _userInjuryStatusList[index];
              return ListTile(
                title: Text(userInjuryStatus.userInjury.injuryName),
                subtitle: Text(userInjuryStatus.isActive ? 'Activa' : 'Inactiva'),
                // Customize ListTile appearance as needed
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
