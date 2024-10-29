import 'package:beatconnect_app/ui/widgets/animated_textfield.dart';
import 'package:beatconnect_app/ui/widgets/button_gradient.dart';
import 'package:beatconnect_app/ui/widgets/button_otherlogins.dart';
import 'package:beatconnect_app/ui/widgets/logoimage.dart';
import 'package:beatconnect_app/ui/widgets/logotype.dart';
import 'package:flutter/material.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

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
                                assets: 'assets/icon/logo.png',
                                height:
                                    MediaQuery.of(context).size.height * 0.12),
                            LogoType(
                              text: 'Iniciar sesión',
                              color: Colors.white,
                              fontSize: 35,
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
                                        activeColor: Color(0xFF6BA5F2),
                                      ),
                                      const Text(
                                        'Remember me',
                                        style: TextStyle(color: Colors.white),
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
                                    child: ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return _isForgotPasswordPressed
                                            ? LinearGradient(
                                                colors: [
                                                  Color(0xFF333333),
                                                  Color(0xFF0597F2),
                                                  Color(0xCC0597F2),
                                                  Color(0x990597F2),
                                                  Color(0x660597F2),
                                                  Color(0x330597F2),
                                                  Color(0x00333333),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ).createShader(bounds)
                                            : LinearGradient(
                                                colors: [
                                                  Colors.white,
                                                  Colors.white
                                                ],
                                              ).createShader(bounds);
                                      },
                                      child: Text(
                                        'Forgot password?',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ButtonGradient(text: 'Entrar', onPressed: () {}),
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
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF262626),
                                    Color(0xFF1C1C1C),
                                    Color(0xFF333333),
                                    Color(0xFF404040),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                onPressed: () {}),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            ButtonOtherLogins(
                                svgPath: 'assets/svg/icon-spotify.svg',
                                svgColor: Color(0xFF81b71a),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF262626),
                                    Color(0xFF1C1C1C),
                                    Color(0xFF333333),
                                    Color(0xFF404040),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                onPressed: () {}),
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
