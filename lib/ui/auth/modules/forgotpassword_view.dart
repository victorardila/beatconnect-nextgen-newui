import 'dart:convert'; // Importar para trabajar con JSON
import 'package:beatconnect_app/ui/widgets/animated_textfield.dart';
import 'package:beatconnect_app/ui/widgets/button_gradient.dart';
import 'package:beatconnect_app/ui/widgets/logotype.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Importar para usar rootBundle

class Country {
  final String name;
  final String code;
  final String iso;
  final String flag;

  Country({
    required this.name,
    required this.code,
    required this.iso,
    required this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      code: json['code'],
      iso: json['iso'],
      flag: json['flag'],
    );
  }
}

class ForgotPasswordView extends StatefulWidget {
  final VoidCallback onClose; // Callback para cerrar la vista
  const ForgotPasswordView(
      {super.key,
      required this.onClose}); // Asegúrate de incluirlo en el constructor

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  TextEditingController email = TextEditingController();
  TextEditingController codeController =
      TextEditingController(); // Controlador para el código
  FocusNode emailFocusNode = FocusNode();
  FocusNode codeFocusNode = FocusNode();
  IconData textFieldIcon = Icons.email; // Icono inicial del TextField
  bool showDropdown = false;
  bool showCodeField = false; // Controlar si mostrar el campo del código
  Country?
      countrySeleccionado; // Cambiar tallaSeleccionada a countrySeleccionado
  List<Country> countries = [];

  @override
  void initState() {
    super.initState();
    loadCountries();

    email.addListener(() {
      final text = email.text;
      setState(() {
        showDropdown = text.isNotEmpty && RegExp(r'\d{2}').hasMatch(text);
        textFieldIcon = showDropdown ? Icons.phone : Icons.email;

        // Cambiar el texto del botón basado en si se está mostrando el campo del código
        if (text.isEmpty) {
          showCodeField =
              false; // Restablecer el campo del código si el email está vacío
        }
      });
    });
  }

  // Método para cargar el JSON
  Future<void> loadCountries() async {
    // Cargar el archivo JSON desde los assets
    final String response =
        await rootBundle.loadString('assets/json/Phone_codes.json');
    final List<dynamic> data = json.decode(response);

    setState(() {
      countries = data.map((country) => Country.fromJson(country)).toList();
      if (countries.isNotEmpty) {
        // Asignar el primer país como seleccionado
        countrySeleccionado = countries[0];
      }
    });
  }

  @override
  void dispose() {
    email.dispose();
    codeController.dispose(); // Dispose del controlador de código
    emailFocusNode.dispose();
    super.dispose();
  }

  void handleSubmit() {
    if (showCodeField) {
      // Lógica para validar el código ingresado
      // Aquí puedes agregar la lógica que necesites para validar el código
      print("Código ingresado: ${codeController.text}");
      // Aquí puedes llamar a un método para validar el código
    } else {
      setState(() {
        showCodeField = true; // Mostrar el campo para el código
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: const Color(0xFF262626),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Cambiado para ajustar la altura
              children: [
                IconButton(
                  onPressed:
                      widget.onClose, // Llama al callback para cerrar la vista
                  icon: Icon(
                    FontAwesomeIcons.caretDown,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                Container(
                  // Eliminada la altura fija y sustituida por un margen
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: LogoType(
                            text: 'Restablecer acceso',
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                          ),
                        ),
                        Container(
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
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    if (showDropdown)
                                      Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 8.0),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            width:
                                                100, // Establecer un ancho fijo para el Dropdown
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey.shade500,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: DropdownButton<Country>(
                                              hint: Text(
                                                'Indicativo',
                                                style: TextStyle(
                                                  color: _isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              dropdownColor: _isDarkMode
                                                  ? Colors.grey[800]
                                                  : Colors.white,
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                color: _isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              iconSize: 24,
                                              isExpanded: true,
                                              underline: SizedBox(),
                                              style: TextStyle(
                                                color: _isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              value: countrySeleccionado,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  countrySeleccionado =
                                                      newValue!;
                                                });
                                              },
                                              items: countries.map((country) {
                                                return DropdownMenuItem<
                                                    Country>(
                                                  value: country,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('${country.code}'),
                                                      Text(country
                                                          .flag), // Mostrar la bandera
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                        ],
                                      ),
                                    Expanded(
                                      child: AnimatedTextField(
                                        controller: email,
                                        labelText: 'Correo electronico',
                                        prefixIcon:
                                            textFieldIcon, // Cambiar icono aquí
                                        isFocused: emailFocusNode.hasFocus,
                                        onFocusChange: (hasFocus) {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Mostrar el campo para ingresar el código si es necesario
                              if (showCodeField && showDropdown)
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: AnimatedTextField(
                                    controller: codeController,
                                    labelText: 'Escribir código',
                                    prefixIcon:
                                        Icons.lock, // Cambiar icono aquí
                                    isFocused: codeFocusNode.hasFocus,
                                    onFocusChange: (hasFocus) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: ButtonGradient(
                            text: showCodeField ? 'Validar' : 'Enviar',
                            onPressed: handleSubmit,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
