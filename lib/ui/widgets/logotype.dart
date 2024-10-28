import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogoType extends StatefulWidget {
  final String text; // Texto requerido
  final Color color; // Color requerido
  final double fontSize; // Tamaño de fuente opcional con valor por defecto

  const LogoType({
    Key? key,
    required this.text, // Parámetro requerido
    required this.color, // Parámetro requerido
    this.fontSize = 40, // Valor por defecto
  }) : super(key: key);

  @override
  State<LogoType> createState() => _LogoTypeState();
}

class _LogoTypeState extends State<LogoType> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Text(
        widget.text, // Usar el texto proporcionado
        style: TextStyle(
          backgroundColor: Colors.transparent,
          fontFamily: 'Omegle',
          color: widget.color, // Usar el color proporcionado
          fontWeight: FontWeight.normal,
          fontSize: widget
              .fontSize, // Usar el tamaño de fuente proporcionado o el por defecto
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
