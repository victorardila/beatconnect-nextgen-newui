import 'package:beatconnect_app/ui/widgets/button_gradient.dart';
import 'package:beatconnect_app/ui/widgets/logoimage.dart';
import 'package:beatconnect_app/ui/widgets/logotype.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool _rememberMe = false; // Estado del checkbox

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              children: [
                LogoImage(
                    assets: 'assets/icon/logo.png',
                    height: MediaQuery.of(context).size.height * 0.12),
                LogoType(
                  text: 'Iniciar sesión',
                  color: Colors.white,
                  fontSize: 35,
                ),
              ],
            ),
          ),
          // Formulario de datos
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: user,
                  enableSuggestions: true,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFF6BA5F2)),
                    ),
                    labelText: 'Correo electrónico',
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                TextFormField(
                  obscureText: true,
                  controller: pass,
                  enableSuggestions: true,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFF6BA5F2)),
                    ),
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                  ),
                ),
                // Opciones de sesión
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            activeColor:
                                Color(0xFF6BA5F2), // Color del checkbox
                          ),
                          const Text(
                            'Remember me',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                // Button gradient
                ButtonGradient(text: 'Entrar', onPressed: () {}),
              ],
            ),
          ),
          // Otras opciones de inicio de sesion
        ],
      ),
    );
  }
}
