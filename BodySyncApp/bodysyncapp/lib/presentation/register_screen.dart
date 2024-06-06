import 'package:bodysyncapp/models/gymUser.dart';
import 'package:bodysyncapp/services/login.service.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const String name = '/register';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'firstName': TextEditingController(),
    'lastName': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
    'confirmPassword': TextEditingController(),
    'dni': TextEditingController(),
    'postalCode': TextEditingController(),
    'city': TextEditingController(),
    'province': TextEditingController(),
    'birthDate': TextEditingController(),
    'weight': TextEditingController(),
    'height': TextEditingController(),
    'biography': TextEditingController(),
    'fitnessGoal': TextEditingController(),
    'activityLevel': TextEditingController(),
  };

  static const List<String> fitnessGoals = [
    'Perder peso',
    'Ganar masa muscular',
    'Tonificar',
    'Mejorar resistencia cardiovascular',
    'Mejorar flexibilidad',
    'Mejorar salud general',
    'Entrenar para competiciones',
    'Otro'
  ];

  static const List<String> activityLevels = [
    'Sedentario',
    'Ligero (poco o ningún ejercicio)',
    'Moderado (ejercicio ligero o moderado 3-5 días a la semana)',
    'Activo (ejercicio moderado o intenso 6-7 días a la semana)',
    'Muy activo (ejercicio intenso diario o ejercicio físico en el trabajo)'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Miembro'),
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionTitle('Detalles Personales'),
                _buildPersonalDetailsFields(),
                _buildSectionTitle('Detalles de Contacto'),
                _buildContactDetailsFields(),
                _buildSectionTitle('Detalles Físicos y Metas'),
                _buildPhysicalDetailsFields(),
                _buildFitnessGoalsField(),
                _buildActivityLevelField(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registerMember,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Registrarse',),
                  
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildPersonalDetailsFields() {
    return Column(
      children: [
        _buildTextInputField(
          controller: _controllers['firstName']!,
          label: 'Nombre',
          icon: Icons.person_outline,
        ),
        _buildTextInputField(
          controller: _controllers['lastName']!,
          label: 'Apellido',
          icon: Icons.person_outline,
        ),
        _buildTextInputField(
          controller: _controllers['dni']!,
          label: 'DNI',
          icon: Icons.credit_card,
        ),
      ],
    );
  }

  Widget _buildContactDetailsFields() {
    return Column(
      children: [
        _buildTextInputField(
          controller: _controllers['email']!,
          label: 'Correo Electrónico',
          icon: Icons.email,
        ),
        _buildPasswordInputField(
          controller: _controllers['password']!,
          label: 'Contraseña',
        ),
        _buildPasswordInputField(
          controller: _controllers['confirmPassword']!,
          label: 'Confirmar Contraseña',
        ),
        _buildNumericInputField(
          controller: _controllers['postalCode']!,
          label: 'Código Postal',
          icon: Icons.location_on,
        ),
        _buildTextInputField(
          controller: _controllers['city']!,
          label: 'Ciudad',
          icon: Icons.location_city,
        ),
        _buildTextInputField(
          controller: _controllers['province']!,
          label: 'Provincia',
          icon: Icons.location_city,
        ),
      ],
    );
  }

  Widget _buildPhysicalDetailsFields() {
    return Column(
      children: [
        _buildBirthDateField(),
        _buildNumericInputField(
          controller: _controllers['weight']!,
          label: 'Peso (kg)',
          icon: Icons.fitness_center,
        ),
        _buildNumericInputField(
          controller: _controllers['height']!,
          label: 'Altura (cm)',
          icon: Icons.height,
        ),
        _buildTextInputField(
          controller: _controllers['biography']!,
          label: 'Biografía',
          icon: Icons.book,
        ),
      ],
    );
  }

  Widget _buildTextInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: Colors.black87,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingresa $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildNumericInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: Colors.black87,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingresa $label';
          }
          if (double.tryParse(value) == null) {
            return 'Por favor, ingresa un número válido';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordInputField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.black87,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingresa $label';
          }
          if (controller == _controllers['password']! && value.length < 6) {
            return 'La contraseña debe tener al menos 6 caracteres';
          }
          if (controller == _controllers['confirmPassword']! &&
              value != _controllers['password']!.text) {
            return 'Las contraseñas no coinciden';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildBirthDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: TextFormField(
            controller: _controllers['birthDate']!,
            decoration: InputDecoration(
              labelText: 'Fecha de Nacimiento',
              prefixIcon: Icon(
                Icons.calendar_today,
                color: Colors.black87,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa la fecha de nacimiento';
              }
              if (DateTime.tryParse(value) == null) {
                return 'Por favor, ingresa una fecha válida';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFitnessGoalsField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Objetivo de Fitness',
          prefixIcon: Icon(
            Icons.fitness_center,
            color: Colors.black87,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        value: _controllers['fitnessGoal']!.text.isEmpty
            ? null
            : _controllers['fitnessGoal']!.text,
        onChanged: (String? newValue) {
          setState(() {
            _controllers['fitnessGoal']!.text = newValue!;
          });
        },
        items: fitnessGoals.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, selecciona un objetivo de fitness';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildActivityLevelField() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Nivel de Actividad',
        prefixIcon: Icon(
          Icons.directions_run,
          color: Colors.black87,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      value: _controllers['activityLevel']!.text.isEmpty
          ? null
          : _controllers['activityLevel']!.text,
      onChanged: (String? newValue) {
        setState(() {
          _controllers['activityLevel']!.text = newValue!;
        });
      },
      items: activityLevels.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6, // Ajusta el ancho aquí
            child: Text(
              value,
              overflow: TextOverflow.ellipsis, // Trunca el texto si se desborda
            ),
          ),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, selecciona un nivel de actividad';
        }
        return null;
      },
    ),
  );
}


  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now().subtract(const Duration(days: 365 * 18));
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _controllers['birthDate']!.text = picked.toIso8601String().split('T').first;
    }
  }

 void _registerMember() {
  if (_formKey.currentState!.validate()) {
    // Creación de un nuevo usuario
    GymUser gymUser = GymUser(
      firstName: _controllers['firstName']!.text,
      lastName: _controllers['lastName']!.text,
      dni: _controllers['dni']!.text,
      postalCode: _controllers['postalCode']!.text,
      province: _controllers['province']!.text,
      city: _controllers['city']!.text,
      username: _controllers['email']!.text,
      password: _controllers['password']!.text,
      role: "ROL_GYMUSER",
      birthDate: DateTime.parse(_controllers['birthDate']!.text),
      weight: double.parse(_controllers['weight']!.text.trim()),
      height: double.parse(_controllers['height']!.text.trim()), // Remove leading/trailing spaces
      activityLevel: _controllers['activityLevel']!.text,
      goal: _controllers['fitnessGoal']!.text,
      biography: _controllers['biography']!.text,
      churn: false,
      createdDate: DateTime.now(),
    );

    // Llamada al servicio de registro
    UserService().register(gymUser).then((response) {
      if (response == 'success') {
        _showSuccessDialog('Usuario registrado exitosamente.');
      } else {
        _showErrorDialog(response);
      }
    }).catchError((error) {
      _showErrorDialog('Ocurrió un error al registrar el usuario: $error');
    });
  }
}


  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Éxito'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  } 
}
