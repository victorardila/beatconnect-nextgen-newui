import 'package:beatconnect_app/ui/widgets/animated_textfield.dart';
import 'package:beatconnect_app/ui/widgets/button_gradient.dart';
import 'package:beatconnect_app/ui/widgets/logotype.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatefulWidget {
  final VoidCallback onClose;
  const ForgotPasswordView({super.key, required this.onClose});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  TextEditingController email = TextEditingController();
  // Focus nodes to track focus state of each text field
  FocusNode emailFocusNode = FocusNode();

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    email.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF262626),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LogoType(
                              text: 'Registro',
                              color: Colors.white,
                              fontSize: 35,
                            ),
                          ],
                        ),
                      ),
                      // Texto informativo
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Ingrese el correo electrónico asociado a su cuenta para recibir un código de recuperación.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      // Formulario de datos
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedTextField(
                              controller: email,
                              labelText: 'Correo electronico',
                              prefixIcon: Icons.person,
                              isFocused: emailFocusNode.hasFocus,
                              onFocusChange: (hasFocus) {
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: ButtonGradient(
                          text: 'Enviar',
                          onPressed: () {
                            // Aquí llamamos al callback al presionar el botón
                            widget.onClose();
                          },
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
