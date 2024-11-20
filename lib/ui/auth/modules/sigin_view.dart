import 'package:beatconnect_app/imports.dart';

class SigninView extends StatefulWidget {
  final VoidCallback onForgotPassword; // Callback para olvidar la contraseña

  const SigninView({super.key, required this.onForgotPassword});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final UserAuthController _userAuthC = Get.find<UserAuthController>();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool _rememberMe = false;
  bool _isUserFocused = false;
  bool _isPassFocused = false;
  bool _isForgotPasswordPressed = false;
  late Box box; // Variable para almacenar la caja

  void _handleSignIn() async {
    // Expresión regular para validar un nombre de usuario (letras, números y un punto opcional)
    final userRegex = RegExp(r'^[a-zA-Z0-9]+(?:\.[a-zA-Z0-9]+)?$');
    if (user.text.isEmpty ||
        (!user.text.contains('@') && !userRegex.hasMatch(user.text))) {
      SnackbarMessage.showSnackbar(
        context,
        'Error de campos',
        'Por favor ingresa un correo electrónico o un nombre de usuario válido.',
        'failure',
      );
      return;
    } else if (pass.text.isEmpty || pass.text.length <= 8) {
      SnackbarMessage.showSnackbar(context, 'Error de campos',
          'La contraseña debe tener al menos 8 caracteres.', 'failure');
      return;
    }

    try {
      // Intento de login
      _userAuthC.login(user.text, pass.text).then((value) async {
        if (_userAuthC.validUser != null &&
            _userAuthC.userMessage.contains('exitoso')) {
          if (_rememberMe) {
            // Guardar usuario y contraseña en Hive si "Recordarme" está activado
            var box = Hive.box('sesion');
            String storedPassword = box.get('password', defaultValue: '');

            // Solo actualizar si la contraseña es diferente
            if (pass.text != storedPassword) {
              await box.put('username', user.text);
              await box.put('password', pass.text);
            }
          } else {
            // Limpiar los campos si no está activado "Recordarme"
            setState(() {
              user.clear();
              pass.clear();
            });
          }
          SnackbarMessage.showSnackbar(
            context,
            _userAuthC.userMessage,
            'Has iniciado sesión correctamente.',
            'success',
            route: '/root', // Ruta opcional
          );
        } else {
          String errorMessage = _userAuthC.userMessage.contains('incorrecta')
              ? 'Por favor verifique y vuelva a intentarlo.'
              : 'Usuario o contraseña incorrectos.';
          SnackbarMessage.showSnackbar(
              context, 'Error de autenticación', errorMessage, 'failure');
        }
      });
    } catch (e) {
      SnackbarMessage.showSnackbar(
          context,
          'Error de inicio de sesión',
          'Hubo un problema al intentar iniciar sesión. Inténtalo de nuevo.',
          'failure');
    }
  }

  @override
  void initState() {
    super.initState();

    // Abrir la caja de Hive antes de acceder a ella
    Hive.openBox('sesion').then((openedBox) {
      setState(() {
        box = openedBox;
        user.text = box.get('username', defaultValue: '');
        pass.text = box.get('password', defaultValue: '');
      });
    });
  }

  @override
  void dispose() {
    user.dispose();
    pass.dispose();
    super.dispose();
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
                              autofillHints: [AutofillHints.email],
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
                              autofillHints: [AutofillHints.password],
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
