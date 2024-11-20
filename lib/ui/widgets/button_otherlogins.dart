import 'package:beatconnect_app/imports.dart';

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
  bool _isPressed = false; // Variable para controlar el estado de presión

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true; // Cambia el estado al presionar
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false; // Cambia el estado al soltar
        });
        widget.onPressed(); // Llama a la función onPressed al soltar
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false; // Cambia el estado si se cancela el toque
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Duración de la animación
        curve: Curves.easeInOut, // Curva de la animación
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
        transform: _isPressed
            ? Matrix4(0.95, 0, 0, 0, 0, 0.95, 0, 0, 0, 0, 1, 0, 0, 0, 0,
                1) // Crea la matriz de escala manualmente
            : Matrix4.identity(),

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
                        color: letterColor,
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
