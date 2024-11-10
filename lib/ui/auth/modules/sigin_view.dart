// Agrega esta importación al principio de tu archivo
import 'package:beatconnect_app/ui/constants.dart';
import 'package:beatconnect_app/ui/widgets/animated_textfield.dart';
import 'package:beatconnect_app/ui/widgets/button_gradient.dart';
import 'package:beatconnect_app/ui/widgets/button_otherlogins.dart';
import 'package:beatconnect_app/ui/widgets/logo_image.dart';
import 'package:beatconnect_app/ui/widgets/logo_type.dart';
import 'package:flutter/material.dart';

class SigninView extends StatefulWidget {
  final VoidCallback onForgotPassword; // Callback para olvidar la contraseña

  const SigninView({super.key, required this.onForgotPassword});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool _rememberMe = false;
  bool _isUserFocused = false;
  bool _isPassFocused = false;
  bool _isForgotPasswordPressed = false;

  // Método para manejar la navegación al iniciar sesión
  void _handleSignIn() {
    // Aquí puedes agregar la lógica para verificar las credenciales de usuario
    // Si las credenciales son válidas, navega a la ruta /root
    Navigator.pushNamed(context, '/root');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.18,
                        child: Column(
                          children: [
                            LogoImage(
                              assets: 'assets/icon/icon.png',
                              height: MediaQuery.of(context).size.height * 0.12,
                            ),
                            LogoType(
                              text: 'Iniciar sesión',
                              color: letterColor,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.04,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedTextField(
                              controller: user,
                              labelText: 'Correo electrónico',
                              prefixIcon: Icons.email,
                              onFocusChange: (focused) {
                                setState(() {
                                  _isUserFocused = focused;
                                });
                              },
                              isFocused: _isUserFocused,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            AnimatedTextField(
                              controller: pass,
                              labelText: 'Contraseña',
                              obscureText: true,
                              prefixIcon: Icons.lock,
                              onFocusChange: (focused) {
                                setState(() {
                                  _isPassFocused = focused;
                                });
                              },
                              isFocused: _isPassFocused,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        activeColor: colorApp,
                                      ),
                                      Text(
                                        'Recordarme',
                                        style: TextStyle(color: letterColor),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTapDown: (_) {
                                      setState(() {
                                        _isForgotPasswordPressed = true;
                                      });
                                    },
                                    onTapUp: (_) {
                                      setState(() {
                                        _isForgotPasswordPressed = false;
                                      });
                                    },
                                    onTap: () {
                                      widget
                                          .onForgotPassword(); // Llamar al callback
                                    },
                                    child: ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return _isForgotPasswordPressed
                                            ? gradientApp.createShader(bounds)
                                            : LinearGradient(
                                                colors: [
                                                  letterColor,
                                                  letterColor,
                                                ],
                                              ).createShader(bounds);
                                      },
                                      child: Text(
                                        '¿Olvidé mi contraseña?',
                                        style: TextStyle(
                                          color: letterColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Modifica el onPressed del botón para que llame a _handleSignIn
                            ButtonGradient(
                              text: 'Entrar',
                              onPressed: _handleSignIn,
                            ),
                          ],
                        ),
                      ),
                      // Otras opciones de inicio de sesión
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.175,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonOtherLogins(
                              svgPath: 'assets/svg/icon-google.svg',
                              gradient: buttonOtherLogins,
                              onPressed: () {},
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                            ),
                            ButtonOtherLogins(
                              svgPath: 'assets/svg/icon-spotify.svg',
                              svgColor: colorSpotify,
                              gradient: buttonOtherLogins,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
