import 'package:beatconnect_app/ui/constants.dart';
import 'package:flutter/material.dart';

class SpinnerLoad extends StatefulWidget {
  const SpinnerLoad({super.key});

  @override
  State<SpinnerLoad> createState() => _SpinnerLoadState();
}

class _SpinnerLoadState extends State<SpinnerLoad> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: backgroundGradientDark(1)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Spinner moderno
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                strokeWidth: 7,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0597F2)),
              ),
            ),
            const SizedBox(height: 20),
            // Texto de carga
            const Text(
              'Cargando...',
              style: TextStyle(
                color: letterColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
