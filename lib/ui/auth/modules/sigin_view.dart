// Agrega esta importación al principio de tu archivo
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:beatconnect_app/controller/user_auth_controller.dart';
import 'package:beatconnect_app/ui/constants.dart';
import 'package:beatconnect_app/ui/widgets/animated_textfield.dart';
import 'package:beatconnect_app/ui/widgets/button_gradient.dart';
import 'package:beatconnect_app/ui/widgets/button_otherlogins.dart';
import 'package:beatconnect_app/ui/widgets/logo_image.dart';
import 'package:beatconnect_app/ui/widgets/logo_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninView extends StatefulWidget {
  final VoidCallback onForgotPassword; // Callback para olvidar la contraseña

  const SigninView({super.key, required this.onForgotPassword});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  UserAuthController _userAuthC = Get.put(UserAuthController());
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool _rememberMe = false;
  bool _isUserFocused = false;
  bool _isPassFocused = false;
  bool _isForgotPasswordPressed = false;

  void _handleSignIn() {
    // Expresión regular para validar un nombre de usuario (letras, números y un punto opcional)
    final userRegex = RegExp(r'^[a-zA-Z0-9]+(?:\.[a-zA-Z0-9]+)?$');

    // Validación para correo o nombre de usuario
    if (user.text.isEmpty ||
        (!user.text.contains('@') && !userRegex.hasMatch(user.text))) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error de campos',
          message:
              'Por favor ingresa un correo electrónico o un nombre de usuario válido.',
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return; // Termina la ejecución si hay error
    } else if (pass.text.isEmpty || pass.text.length <= 8) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error de campos',
          message: 'La contraseña debe tener al menos 6 caracteres.',
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return; // Termina la ejecución si hay error
    }

    // Intento de login
    _userAuthC.login(user.text, pass.text).then((value) {
      if (_userAuthC.validUser != null &&
          _userAuthC.userMessage.contains('exitoso')) {
        // Mostrar Snackbar de éxito
        final successSnackbar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: _userAuthC.userMessage,
            message: 'Has iniciado sesión correctamente.',
            contentType: ContentType.success,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(successSnackbar);

        // Navegar a la ruta principal
        Navigator.pushNamed(context, '/root');
      } else {
        if (_userAuthC.userMessage.contains('incorrecta')) {
          // Manejar el caso de error en autenticación
          final errorSnackbar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: _userAuthC.userMessage,
              message: 'Por favor verifique y vuelva a intentarlo',
              contentType: ContentType.failure,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
        } else {
          // Manejar el caso de error en autenticación
          final errorSnackbar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Error de autenticación',
              message: 'Usuario o contraseña incorrectos.',
              contentType: ContentType.failure,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
        }
      }
    });
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
