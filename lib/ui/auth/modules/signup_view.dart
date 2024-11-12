import 'package:beatconnect_app/ui/constants.dart';
import 'package:beatconnect_app/ui/widgets/animated_container_image.dart';
import 'package:beatconnect_app/ui/widgets/animated_textfield.dart';
import 'package:beatconnect_app/ui/widgets/button_gradient.dart';
import 'package:beatconnect_app/ui/widgets/logo_type.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class SignupView extends StatefulWidget {
  final Function(bool isCompany) onSignupSuccess;
  const SignupView({super.key, required this.onSignupSuccess});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  TextEditingController user = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController repeatPass = TextEditingController();
  bool isCompany = false; // Para rastrear si el usuario seleccionó "Empresa"
  bool isTypeSelected =
      false; // Para rastrear si se seleccionó un tipo de usuario
  bool showRepeatPass =
      false; // Para mostrar/ocultar el campo "Repetir contraseña"

  FocusNode userFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  FocusNode repeatPassFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Agregamos un listener al campo de contraseña para mostrar/ocultar el campo "Repetir contraseña"
    pass.addListener(_toggleRepeatPassVisibility);
  }

  @override
  void dispose() {
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

  void _toggleRepeatPassVisibility() {
    setState(() {
      showRepeatPass = pass.text.isNotEmpty;
    });
  }

  void selectUserType(bool company) {
    setState(() {
      isCompany = company;
      isTypeSelected = true; // Oculta `selectTypeUser` y muestra `formRegister`
    });
  }

  @override
  Widget build(BuildContext context) {
    // Formularios de registro
    final registrationForm = Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                setState(() {
                  isTypeSelected = !isTypeSelected;
                });
              },
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.caretLeft,
                    color: colorApp,
                  ),
                  Text(
                    'Seleccionar otro tipo',
                    style: TextStyle(
                      color: colorApp,
                    ),
                  ),
                ],
              )),
          AnimatedTextField(
            controller: user,
            labelText: isCompany ? 'Nombre de negocio' : 'Usuario',
            prefixIcon: isCompany ? Icons.business : Icons.person,
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
          // Solo mostramos el campo "Repetir contraseña" si `showRepeatPass` es true
          if (showRepeatPass)
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
    );

    // Seleccion de tipo de usuario
    final userTypeselection = Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Elija el tipo de usuario',
            style: TextStyle(
              color: letterColor,
              fontSize: MediaQuery.of(context).size.height * 0.022,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedContainerImage(
                      image: 'assets/img/user_auth.png',
                      text: 'Persona',
                      onTap: () => selectUserType(false),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainerImage(
                      image: 'assets/img/businesswoman.jpg',
                      text: 'Negocio',
                      onTap: () => selectUserType(true),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

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
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          children: [
                            LogoType(
                              text: 'Registro',
                              color: letterColor,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.04,
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          if (!isTypeSelected) userTypeselection,
                          if (isTypeSelected) registrationForm,
                        ],
                      ),
                      isTypeSelected
                          ? Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: ButtonGradient(
                                text: 'Registrarme',
                                onPressed: () {
                                  widget.onSignupSuccess(isCompany);
                                },
                              ),
                            )
                          : Container(),
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
