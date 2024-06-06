import 'package:bodysyncapp/presentation/instructor/homeInstructor_screen.dart';
import 'package:bodysyncapp/presentation/miembros/gymUser_Screen.dart';
import 'package:bodysyncapp/presentation/register_screen.dart';
import 'package:bodysyncapp/services/login.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  static const String name = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

  extendBodyBehindAppBar: true,
  body: Stack(
    fit: StackFit.expand,
    children: <Widget>[
      Image.asset(
        'assets/images/iconoApp.jpg',
        fit: BoxFit.cover,
      ),
      Container(
        color: Colors.black.withOpacity(0.0),
      ),
      Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
      'BodySync',
      style: TextStyle(
        fontSize:  50,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 0, 0, 0),
      ),
    ),
              // Aumenta el valor aquí para más espacio
              SizedBox(height: kToolbarHeight + 10), // Ajusta este valor según necesites
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                icon: Icons.email,
              ),
              const SizedBox(height: 12.0),
              _buildTextField(
                controller: _passwordController,
                labelText: 'Contraseña',
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 24.0),
              _buildLoginButton(),
              const SizedBox(height: 24.0),
              _buildRegisterButton(context),
            ],
          ),
        ),
      ),
    ],
  ),
);

  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85), // Fondo blanco con opacidad
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black87),
          prefixIcon: Icon(icon, color: Colors.black87),
          border: InputBorder.none, // Sin borde
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        primary: Colors.white, // Botón blanco
        onPrimary: Colors.black, // Texto negro
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      child: _isLoading
          ? const SpinKitCircle(color: Colors.black, size: 24.0)
          : const Text('Iniciar sesión', style: TextStyle(fontSize: 18)),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.pushNamed(RegisterScreen.name);
      },
      style: TextButton.styleFrom(
        primary: const Color.fromARGB(255, 0, 0, 0), // Texto blanco
      ),
      child: const Text('Registrarse', style: TextStyle(fontSize: 16)),
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final String? loginResult = await UserService().login(email, password);

    if (loginResult == 'success') {
      final String userRole = UserService.userRole;

      switch (userRole) {
        case 'ROL_GYMUSER':
          context.pushNamed(GymUserScreen.name);
          break;
        case 'ROL_GYMINSTRUCTOR':
          context.pushNamed(HomeInstructorScreen.name);
          break;
        // Agrega más casos según los roles que maneje tu aplicación
        default:
          print('Rol no válido: $userRole');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loginResult ?? 'Error en el inicio de sesión'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }
}
