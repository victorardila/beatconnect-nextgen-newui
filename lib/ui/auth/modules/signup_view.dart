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
            height: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
          ),
          // Otras opciones de inicio de sesion
        ],
      ),
    );
  }
}
