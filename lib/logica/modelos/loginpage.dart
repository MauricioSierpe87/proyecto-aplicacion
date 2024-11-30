import 'package:flutter/material.dart';
import 'package:leufucadeapp/global/interface_shared.dart';
import 'package:leufucadeapp/logica/common/str_util.dart';

import 'main_menu.dart';
import 'register_screen.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'loginpage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Método para realizar el login
  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> jData = {
        'mail': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      };

      try {
        // Solicitud al servidor
        Map<dynamic, dynamic> fetch_data = await Request_Login(context, jData);

        if (fetch_data.isEmpty || fetch_data['login'] != true) {
          _showSnackBar(context, 'Error al iniciar sesión');
          return;
        }

        _showSnackBar(context, 'Ingresado correctamente');
        Navigator.pushNamed(context, MainMenu.id);
      } catch (e) {
        // Manejo de errores de conexión
        _showSnackBar(context, 'Ocurrió un error: ${e.toString()}');
      }
    }
  }

  /// Método para mostrar un mensaje en pantalla
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/a.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Correo Electrónico',
                          hintText: 'ejemplo@correo.com',
                          border: OutlineInputBorder(),
                        ),
                        validator: Validator_Mail,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(),
                        ),
                        validator: Validator_Password_Login,
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () => _login(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80.0, vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: const Color(0xFF3BAF98),
                          elevation: 10.0,
                        ),
                        child: const Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterScreen.id);
                        },
                        child: const Text(
                          '¿No tienes cuenta? Regístrate aquí',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
