import 'package:beatconnect_app/ui/widgets/animated_textfield.dart';
import 'package:beatconnect_app/ui/widgets/button_gradient.dart';
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
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.7,
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
                            activeColor: Color(0xFF6BA5F2),
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
                ButtonGradient(text: 'Entrar', onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
