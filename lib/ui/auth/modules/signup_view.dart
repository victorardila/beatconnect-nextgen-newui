import 'package:beatconnect_app/imports.dart';

class SignupView extends StatefulWidget {
  final Function(bool isCompany) onSignupSuccess;
  const SignupView({super.key, required this.onSignupSuccess});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final UserAuthController _userAuthC = Get.find<UserAuthController>();
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
  // Nueva variable para guardar el tipo de usuario
  String userType = 'personal';

  void clearFields() {
    user.clear();
    email.clear();
    pass.clear();
    repeatPass.clear();
    isCompany = false; // Reinicia el estado de la empresa
    isTypeSelected = false; // Reinicia la selección de tipo
    showRepeatPass = false; // Oculta el campo de repetir contraseña
    userType = 'personal'; // Restablece el tipo de usuario
  }

  String normalizeUsername(String username) {
    // Eliminar acentos sin cambiar el caso
    String normalized = username;
    normalized = normalized.replaceAll(RegExp(r'[áàäâ]'), 'a');
    normalized = normalized.replaceAll(RegExp(r'[éèëê]'), 'e');
    normalized = normalized.replaceAll(RegExp(r'[íìïî]'), 'i');
    normalized = normalized.replaceAll(RegExp(r'[óòöô]'), 'o');
    normalized = normalized.replaceAll(RegExp(r'[úùüû]'), 'u');
    normalized = normalized.replaceAll(RegExp(r'[ñ]'), 'n');
    return normalized;
  }

  void _handleSignUp() {
    if (repeatPass.text != pass.text) {
      // Validación de los campos
      if (user.text.isEmpty || !user.text.contains('@')) {
        SnackbarMessage.showSnackbar(context, 'Error de campos',
            'Por favor ingresa un correo electrónico válido.', 'failure');
        return; // Termina la ejecución si hay error
      } else if (pass.text.isEmpty || pass.text.length < 8) {
        SnackbarMessage.showSnackbar(context, 'Error de campos',
            'La contraseña debe tener al menos 6 caracteres.', 'failure');
        return; // Termina la ejecución si hay error
      }
    }
    // final userId =
    //     Uuid().v4(); // Genera un UUID único para el usuario en una sola línea
    String normalizedUser = normalizeUsername(user.text);
    _userAuthC
        .createUser(userType, normalizedUser, email.text, pass.text)
        .then((value) {
      if (_userAuthC.validUser != null) {
        // SnackbarMessage.showSnackbar(context, 'Registro de usuario exitoso',
        //     _userAuthC.userMessage, 'success');
        widget.onSignupSuccess(isCompany);
        clearFields();
      } else {
        SnackbarMessage.showSnackbar(context, 'No se pudo crear el usuario.',
            _userAuthC.userMessage, 'failure');
      }
    });
  }

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
      if (!showRepeatPass) {
        repeatPass.clear();
      }
    });
  }

  void selectUserType(bool company) {
    setState(() {
      isCompany = company;
      isTypeSelected = true;
      userType = company ? 'business' : 'personal'; // Asigna el tipo de usuario
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
                                onPressed: _handleSignUp,
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
