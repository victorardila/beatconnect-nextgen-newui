import 'package:beatconnect_app/ui/widgets/animated_textfield.dart';
import 'package:beatconnect_app/ui/widgets/button_gradient.dart';
import 'package:beatconnect_app/ui/widgets/logoimage.dart';
import 'package:beatconnect_app/ui/widgets/logotype.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  TextEditingController user = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController repeatPass = TextEditingController();

  // Focus nodes to track focus state of each text field
  FocusNode userFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  FocusNode repeatPassFocusNode = FocusNode();

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    user.dispose();
    email.dispose();
    pass.dispose();
    repeatPass.dispose();
    userFocusNode.dispose();
    emailFocusNode.dispose();
    passFocusNode.dispose();
    repeatPassFocusNode.dispose();
    super.dispose();
  }

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
            height: MediaQuery.of(context).size.width * 0.2,
            child: Column(
              children: [
                LogoType(
                  text: 'Registro',
                  color: Colors.white,
                  fontSize: 35,
                ),
              ],
            ),
          ),
          // Formulario de datos
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedTextField(
                  controller: user,
                  labelText: 'Usuario',
                  prefixIcon: Icons.person,
                  isFocused: userFocusNode.hasFocus,
                  onFocusChange: (hasFocus) {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                AnimatedTextField(
                  controller: email,
                  labelText: 'Correo electrónico',
                  prefixIcon: Icons.email,
                  isFocused: emailFocusNode.hasFocus,
                  onFocusChange: (hasFocus) {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                AnimatedTextField(
                  controller: pass,
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  isFocused: passFocusNode.hasFocus,
                  onFocusChange: (hasFocus) {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                AnimatedTextField(
                  controller: repeatPass,
                  labelText: 'Repetir contraseña',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  isFocused: repeatPassFocusNode.hasFocus,
                  onFocusChange: (hasFocus) {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          Container(
            child: ButtonGradient(text: 'Registrarme', onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
