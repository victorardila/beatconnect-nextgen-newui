import 'package:beatconnect_nextgen_newui/imports.dart';

class ErrorView extends StatelessWidget {
  final String message;

  const ErrorView({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con gradiente y partículas en el fondo
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: backgroundGradientDark(1),
              ),
              child: ParticlesFly(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                numberOfParticles: 50,
                speedOfParticles: 2,
                awayRadius: 500,
                isRandomColor: true,
                maxParticleSize: 2,
                randColorList: const [
                  Color(0xFF333333),
                  Color(0xFF0597F2),
                  Color(0xCC0597F2),
                  Color(0x990597F2),
                  Color(0x660597F2),
                  Color(0x330597F2),
                  Color(0x00333333),
                ],
                lineColor: const Color(0x990597F2),
                lineStrokeWidth: 0.2,
                awayAnimationDuration: const Duration(milliseconds: 100),
                awayAnimationCurve: Curves.easeIn,
                connectDots: true,
              ),
            ),
          ),
          // Contenido principal (Icono, texto de error y mensaje)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.exclamationTriangle,
                  color: Colors.red,
                  size: MediaQuery.of(context).size.width * 0.2,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Error',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
