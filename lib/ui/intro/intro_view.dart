import 'package:beatconnect_app/ui/auth/auth_view.dart';
import 'package:beatconnect_app/imports.dart';

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
  bool _isFaded = false; // Controla la visibilidad del logo

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));

    _startFadeAnimationLoop(); // Inicia el bucle de animación
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startFadeAnimationLoop() {
    // Configura un bucle de animación cada 5 segundos
    Future.delayed(Duration(milliseconds: 1800), () {
      setState(() {
        _isFaded = !_isFaded; // Alterna la visibilidad del logo
      });

      // Reinicia el bucle para la próxima animación después de 5 segundos
      _startFadeAnimationLoop();
    });
  }

  void _toggleAuthView() {
    setState(() {
      if (_showAuthView) {
        _animationController.reverse().then((_) {
          setState(() {
            _showAuthView = false;
          });
        });
      } else {
        _showAuthView = true;
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF262626),
      body: Stack(
        children: [
          // Fondo de imagen
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
          // Gradiente de fondo
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
          // ToggleSwitch en la esquina superior derecha
          Positioned(
            top: 40,
            right: 20,
            child: ToggleSwitch(),
          ),
          // Contenido principal
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeOutParticle(
                      disappear: _isFaded,
                      child: LogoType(
                        text: 'BeatConnect',
                        color: const Color(0xFF418EF2),
                      ),
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
                      icon: FontAwesomeIcons.play,
                      onPressed: _toggleAuthView,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Vista de autenticación superpuesta
          if (_showAuthView)
            GestureDetector(
              onTap: _toggleAuthView,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          // Animación deslizante de la vista de autenticación
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _offsetAnimation,
              child: FractionallySizedBox(
                heightFactor: 0.75,
                child: _showAuthView ? AuthenticationView() : Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
