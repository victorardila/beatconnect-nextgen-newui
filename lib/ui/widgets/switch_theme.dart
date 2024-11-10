import 'dart:async';
import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  @override
  _ToggleSwitchState createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  bool isDarkMode = false;
  double opacity = 1.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startOpacityTimer(); // Iniciar el temporizador al inicio
  }

  void _startOpacityTimer() {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: 2), () {
      setState(() {
        opacity = 0.2; // Cambiar opacidad después de 2 segundos
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isDarkMode = !isDarkMode; // Cambia el estado al tocar
          opacity = 1.0; // Restablece la opacidad al interactuar
        });
        _startOpacityTimer();
      },
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.height * 0.035,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              if (opacity == 1.0) // Estilo original
                CustomPaint(
                  painter: TogglePainter(isDarkMode),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: const Color.fromARGB(255, 216, 216, 216),
                        width: 0.8,
                      ),
                    ),
                  ),
                )
              else // Nuevo estilo cuando esté opaco
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black : Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              AnimatedAlign(
                alignment:
                    isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
                duration: Duration(milliseconds: 200),
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.03,
                  height: MediaQuery.of(context).size.height * 0.03,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFFD0D8E1)
                        : (opacity == 1.0 ? Color(0xFFF2C12E) : Colors.white),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      if (opacity == 1.0) // Solo sombra en diseño original
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                    ],
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  child: isDarkMode && opacity == 1.0
                      ? CustomPaint(
                          painter: CraterPainter(),
                          child: Container(),
                        )
                      : Container(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TogglePainter extends CustomPainter {
  final bool isDarkMode;

  TogglePainter(this.isDarkMode);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    paint.color = isDarkMode ? Colors.black : Colors.lightBlue;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(0, 0, size.width, size.height),
        Radius.circular(20),
      ),
      paint,
    );

    if (isDarkMode) {
      paint.color = const Color.fromARGB(255, 239, 239, 239);
      canvas.drawCircle(Offset(size.width * 0.12, size.height * 0.3), 4, paint);
      canvas.drawCircle(Offset(size.width * 0.45, size.height * 0.6), 3, paint);
      canvas.drawCircle(
          Offset(size.width * 0.28, size.height * 0.48), 2, paint);
      canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.3), 2, paint);
      canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.7), 1, paint);
      canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.8), 3, paint);
    } else {
      paint.color = const Color.fromRGBO(255, 255, 255, .5);
      canvas.drawCircle(
          Offset(size.width * 0.84, size.height * 0.35), 8, paint);
      canvas.drawCircle(
          Offset(size.width * 0.82, size.height * 0.65), 7.4, paint);
      canvas.drawCircle(
          Offset(size.width * 0.70, size.height * 0.66), 7, paint);
      canvas.drawCircle(
          Offset(size.width * 0.55, size.height * 0.72), 7.2, paint);
      paint.color = Colors.white;
      canvas.drawCircle(
          Offset(size.width * 0.88, size.height * 0.45), 7, paint);
      canvas.drawCircle(
          Offset(size.width * 0.85, size.height * 0.65), 7, paint);
      canvas.drawCircle(
          Offset(size.width * 0.75, size.height * 0.75), 7, paint);
      canvas.drawCircle(
          Offset(size.width * 0.6, size.height * 0.75), 6.6, paint);
    }
  }

  @override
  bool shouldRepaint(TogglePainter oldDelegate) {
    return oldDelegate.isDarkMode != isDarkMode;
  }
}

class CraterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint craterPaint = Paint()
      ..color = const Color(0xFFA8B1C6)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(size.width * 0.3, size.height * 0.3), 2, craterPaint);
    canvas.drawCircle(
        Offset(size.width * 0.6, size.height * 0.4), 1.5, craterPaint);
    canvas.drawCircle(
        Offset(size.width * 0.4, size.height * 0.7), 1.8, craterPaint);
    canvas.drawCircle(
        Offset(size.width * 0.7, size.height * 0.6), 1.2, craterPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
