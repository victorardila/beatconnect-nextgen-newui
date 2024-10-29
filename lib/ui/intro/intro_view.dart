import 'package:beatconnect_app/ui/auth/auth_view.dart';
import 'package:beatconnect_app/ui/widgets/button_gradient.dart';
import 'package:beatconnect_app/ui/widgets/logotype.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class IntroView extends StatefulWidget {
  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView>
    with SingleTickerProviderStateMixin {
  bool _showAuthView = false;
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Empieza desde abajo de la pantalla
      end: Offset.zero, // Termina en su posición normal
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleAuthView() {
    setState(() {
      if (_showAuthView) {
        // Si la vista de autenticación está activa, revertir la animación
        _animationController.reverse().then((_) {
          setState(() {
            _showAuthView =
                false; // Cambiar el estado después de que la animación se complete
          });
        });
      } else {
        _showAuthView = true; // Cambiar el estado inmediatamente al abrir
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF262626), // Cambia a cualquier color que desees
      body: Stack(
        children: [
          // Fondo de IntroView con imagen
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/concept_art_intro.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradiente vertical
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Contenido inferior con texto y botón
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LogoType(
                      text: 'BeatConnect',
                      color: const Color(0xFF418EF2),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Crea, comparte y conecta al ritmo del mundo.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ButtonGradient(
                      icon: FontAwesomeIcons.angleRight,
                      onPressed: _toggleAuthView,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Efecto de desenfoque sobre el fondo solo si se muestra la vista de autenticación
          if (_showAuthView) // Verifica si la vista de autenticación está activa
            GestureDetector(
              onTap:
                  _toggleAuthView, // Cierra la vista de autenticación al tocar
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color:
                      Colors.black.withOpacity(0.5), // Ajuste de fondo oscuro
                ),
              ),
            ),
          // Vista de autenticación en superposición con animación de desplazamiento desde la parte inferior
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _offsetAnimation,
              child: FractionallySizedBox(
                heightFactor: 0.75,
                child: _showAuthView // Solo muestra la vista de autenticación si está activa
                    ? AuthenticationView()
                    : Container(), // Muestra un contenedor vacío si no está activa
              ),
            ),
          ),
        ],
      ),
    );
  }
}
