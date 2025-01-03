import 'package:beatconnect_nextgen_newui/imports.dart';

class AnimatedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final bool obscureText;
  final bool isFocused;
  final List<String>? autofillHints; // Cambiado a List<String>?
  final ValueChanged<bool> onFocusChange;

  const AnimatedTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.obscureText = false,
    required this.onFocusChange,
    this.autofillHints,
    required this.isFocused,
  });

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (isFocused) {
        setState(() {
          widget.onFocusChange(isFocused);
          if (isFocused) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: BorderPainterTextField(_animation.value),
                child: child,
              );
            },
            child: Container(
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: widget.controller,
                obscureText: widget.obscureText,
                autofillHints:
                    widget.autofillHints, // Aquí se pasa correctamente
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  labelStyle: TextStyle(
                    color: widget.isFocused ? Color(0xFF6BA5F2) : Colors.grey,
                  ),
                  prefixIcon: Icon(
                    widget.prefixIcon,
                    color: widget.isFocused ? Color(0xFF6BA5F2) : Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
                cursorColor: Color(0xFF6BA5F2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BorderPainterTextField extends CustomPainter {
  final double progress;

  BorderPainterTextField(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Apply the gradientApp shader to the paint
    final paint = Paint()
      ..shader = gradientApp.createShader(rect)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(10)));

    final pathMetrics = path.computeMetrics().first;
    final animatedPath =
        pathMetrics.extractPath(0, pathMetrics.length * progress);
    canvas.drawPath(animatedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
