import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto1_tienda/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:proyecto1_tienda/screens/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var _isLogin = true;
  
  void _clearTextFields() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    Uri url;
    Map<String, String> requestBody;

    if (_isLogin) {
      url = Uri.parse('http://192.168.0.18:6060/auth/signin');
      requestBody = {
        "email": _emailController.text,
        "password": _passwordController.text
      };
    } else {
      url = Uri.parse('http://192.168.0.18:6060/auth/signup');
      requestBody = {
        "name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "role": "USER"
      };
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        if (_isLogin) {
          final responseData = jsonDecode(response.body);
          final email = responseData['email'];
          final role = responseData['role'];
          final token = responseData['token'];
          
          if (!mounted) return;
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(email: email, role: role, token: token);
        } else {
          _clearTextFields();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario creado exitosamente')),
          );
          setState(() {
            _isLogin = true;
          });
          return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        print('Error en la solicitud. Código de estado: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }
    } catch (error) {
      print('Error en la solicitud: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17203A),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 200.0,
                    color: Colors.transparent,
                  ),
                  const Icon(
                    Icons.person_sharp,
                    size: 280.0,
                    color: Colors.white,
                  ),
                ],
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (!_isLogin)
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Nombre',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF17203A)),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor, introduzca su nombre.';
                                }
                                return null;
                              },
                            ),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Correo electrónico',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF17203A)),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty || !value.contains('@')) {
                                return 'Introduzca una dirección de correo electrónico válida.';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Contraseña',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF17203A)),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Contraseña debe tener al menos 6 caracteres.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF17203A),
                            ),
                            child: Text(
                              _isLogin ? 'Acceder' : 'Crear Cuenta',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin ? 'Crear una cuenta' : 'Ya tengo una cuenta.',
                              style: const TextStyle(color: Color(0xFF17203A)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}