import 'package:flutter/material.dart';

class AnimatedDropdown<T> extends StatefulWidget {
  final String hint;
  final List<T> items;
  final T? selectedItem;
  final Function(T?) onChanged;
  final String Function(T) itemLabelBuilder;

  const AnimatedDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.itemLabelBuilder,
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
      duration: Duration(milliseconds: 300), // Duración de ambas animaciones
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
        _controller.reverse(); // Revertir ambas animaciones al perder foco
      }
    });
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
        _controller.forward(); // Inicia ambas animaciones
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsets.only(left: 8.0),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: AnimatedBuilder(
              animation: _borderAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: BorderPainter(_borderAnimation.value),
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.transparent),
                ),
                child: Focus(
                  focusNode: _focusNode,
                  child: DropdownButton<T>(
                    hint: Text(
                      widget.hint,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    iconSize: 24,
                    isExpanded: true,
                    underline: SizedBox(),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
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
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
      ],
    );
  }
}

class BorderPainter extends CustomPainter {
  final double progress;

  BorderPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final whiteBorderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color(0xFF333333),
          Color(0xFF0597F2),
          Color(0xCC0597F2),
          Color(0x990597F2),
          Color(0x660597F2),
          Color(0x330597F2),
          Color(0x00333333),
        ],
      ).createShader(rect)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(8)));

    if (progress > 0) {
      final pathMetrics = path.computeMetrics().first;
      final animatedPath =
          pathMetrics.extractPath(0, pathMetrics.length * progress);
      canvas.drawPath(animatedPath, gradientPaint);
    } else {
      canvas.drawPath(path, whiteBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
