import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonOtherLogins extends StatefulWidget {
  final String? text;
  final String? svgPath;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Gradient? gradient;
  final Color? svgColor; // Color opcional para el SVG

  const ButtonOtherLogins({
    this.text,
    required this.onPressed,
    this.svgPath,
    this.width,
    this.height,
    this.gradient,
    this.svgColor, // Añade el color del SVG al constructor
    Key? key,
  }) : super(key: key);

  @override
  State<ButtonOtherLogins> createState() => _ButtonOtherLoginsState();
}

class _ButtonOtherLoginsState extends State<ButtonOtherLogins> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: widget.width ?? 60,
        height: widget.height ?? 60,
        decoration: BoxDecoration(
          gradient: widget.gradient ??
              LinearGradient(
                colors: [Colors.blue, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.svgPath != null)
                  SvgPicture.asset(
                    widget.svgPath!,
                    height: constraints.maxHeight *
                        0.8, // 80% de la altura del contenedor
                    fit: BoxFit.contain,
                    color: widget.svgColor,
                  ),
                if (widget.text != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      widget.text!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
