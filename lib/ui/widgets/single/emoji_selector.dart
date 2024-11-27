import 'package:beatconnect_app/imports.dart';

class EmojiSelector extends StatefulWidget {
  final Function(String) onEmojiSelected;
  const EmojiSelector({Key? key, required this.onEmojiSelected})
      : super(key: key);

  @override
  _EmojiSelectorState createState() => _EmojiSelectorState();
}

class _EmojiSelectorState extends State<EmojiSelector>
    with SingleTickerProviderStateMixin {
  String? selectedEmoji;

  // Lista de emojis disponibles
  final List<String> emojis = [
    '😀', '😂', '😍', '😎', '🥳', '😢', '😡', '🤔', '🤗', '🙌',
    // Agrega más emojis si lo deseas
  ];

  // Gradiente para el borde
  final gradient = LinearGradient(
    colors: [
      Color(0xFF333333),
      Color(0xFF0597F2),
      Color(0xCC0597F2),
      Color(0x990597F2),
      Color(0x660597F2),
      Color(0x330597F2),
      Color(0x00333333),
    ],
  );

  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(); // Repite la animación indefinidamente

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Libera el controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Contenedor que muestra el emoji seleccionado o el ícono de emoji
        GestureDetector(
          onTap: () => _showEmojiPicker(context),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Color de la sombra
                  spreadRadius: 1, // Radio de expansión de la sombra
                  blurRadius: 5, // Radio de difuminado de la sombra
                  offset: Offset(0, 3), // Desplazamiento de la sombra
                ),
              ],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Aquí está el borde giratorio
                AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value *
                          2 *
                          3.141592653589793, // Convertir a radianes
                      child: CustomPaint(
                        painter: GradientBorderPainter(
                          strokeWidth: 2, // Ajusta el grosor del borde
                          gradient: gradient,
                        ),
                        child: Container(
                          width: 40, // Ajusta el ancho del contenedor
                          height: 40, // Ajusta el alto del contenedor
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Contenido interno que no gira
                selectedEmoji != null
                    ? Text(
                        selectedEmoji!,
                        style: TextStyle(fontSize: 25),
                      )
                    : Icon(
                        Icons.insert_emoticon,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        size: 30,
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Método para mostrar el selector de emojis
  void _showEmojiPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true, // Permite cerrar tocando fuera del modal
      enableDrag: true, // Permite deslizar para cerrar el modal
      builder: (context) {
        return Container(
          height: 200,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
            ),
            itemCount: emojis.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedEmoji = emojis[index];
                  });
                  widget.onEmojiSelected(emojis[index]); // Llama al callback
                  Navigator.pop(context); // Cierra el modal inmediatamente
                },
                child: Center(
                  child: Text(
                    emojis[index],
                    style: TextStyle(fontSize: 20), // Tamaño de los emojis
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class GradientBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Gradient gradient;

  GradientBorderPainter({required this.strokeWidth, required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Dibuja un círculo con el borde gradiente
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      (size.width / 2) - (strokeWidth / 2), // Radio del círculo
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
