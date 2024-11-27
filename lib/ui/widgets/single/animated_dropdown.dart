import 'package:beatconnect_app/imports.dart';

class AnimatedDropdown<T> extends StatefulWidget {
  final double height;
  final double width;
  final String hint;
  final List<T> items;
  final T? selectedItem;
  final Function(T?) onChanged;
  final String Function(T) itemLabelBuilder;
  final bool enableScaleAnimation;

  const AnimatedDropdown({
    super.key,
    this.height = 0.0,
    this.width = 0.0,
    required this.hint,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.itemLabelBuilder,
    this.enableScaleAnimation = true,
  });

  @override
  State<AnimatedDropdown> createState() => _AnimatedDropdownState<T>();
}

class _AnimatedDropdownState<T> extends State<AnimatedDropdown<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _borderAnimation;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // Animación de escala
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Animación de borde
    _borderAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _controller.reverse();
      }
    });
    print(
      widget.items
          .map((item) => widget.itemLabelBuilder(item))
          .toList()
          .toString(),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(T? newValue) {
    setState(() {
      widget.onChanged(newValue);
      if (newValue != null) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final double width =
        widget.width != 0.0 ? widget.width : MediaQuery.of(context).size.width;
    final double height = widget.height == 0.0 ? 56.0 : widget.height;

    final animatedContent = Container(
      decoration: BoxDecoration(
        color: bgComponents,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: AnimatedBuilder(
        animation: _borderAnimation,
        builder: (context, child) {
          return ClipRect(
            // Agregar ClipRect aquí
            child: CustomPaint(
              painter: BorderPainterDropdown(_borderAnimation.value),
              child: child,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.transparent),
          ),
          child: Focus(
            focusNode: _focusNode,
            child: DropdownButton<T>(
              borderRadius: BorderRadius.circular(10),
              padding: EdgeInsets.only(left: 10),
              hint: Text(
                widget.hint,
                style: TextStyle(
                  color: isDarkMode ? letterColor : Colors.black,
                ),
              ),
              dropdownColor: isDarkMode ? Colors.grey[800] : letterColor,
              icon: Icon(
                Icons.arrow_drop_down,
                color: isDarkMode ? letterColor : Colors.black,
              ),
              iconSize: 24,
              isExpanded: true,
              underline: SizedBox(),
              style: TextStyle(
                color: isDarkMode ? letterColor : Colors.black,
              ),
              value: widget.selectedItem,
              onChanged: (newValue) {
                _onChanged(newValue);
                _focusNode.requestFocus();
              },
              items: widget.items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(widget.itemLabelBuilder(item)),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );

    return Container(
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.enableScaleAnimation
              ? Expanded(
                  // Agrega Expanded aquí para limitar el ancho y evitar desbordamiento
                  child: ScaleTransition(
                      scale: _scaleAnimation, child: animatedContent),
                )
              : Expanded(
                  // Agrega Expanded aquí también si la animación está deshabilitada
                  child: animatedContent,
                ),
        ],
      ),
    );
  }
}

class BorderPainterDropdown extends CustomPainter {
  final double progress;

  BorderPainterDropdown(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(1, 1, size.width - 2, size.height - 2);

    // Definir borde blanco
    final whiteBorderPaint = Paint()
      ..color = const Color.fromRGBO(188, 188, 188, 1)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Definir borde con gradiente
    final gradientPaint = Paint()
      ..shader = gradientApp.createShader(rect)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Crear el Path para el borde redondeado
    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(10)));

    // Verificar el estado de la animación para decidir qué borde mostrar
    if (progress > 0) {
      // Dibujar el borde gradiente durante la interacción
      final pathMetrics = path.computeMetrics().first;
      final animatedPath =
          pathMetrics.extractPath(0, pathMetrics.length * progress);
      canvas.drawPath(animatedPath, gradientPaint);
    } else {
      // Dibujar el borde blanco cuando no hay interacción
      canvas.drawPath(path, whiteBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
