import '../../../imports.dart';

class AnimatedProgressStepper extends StatefulWidget {
  final List<IconData> iconsStep;
  final int totalSteps;
  final int currentStep;

  const AnimatedProgressStepper({
    Key? key,
    required this.iconsStep,
    required this.totalSteps,
    required this.currentStep,
  }) : super(key: key);

  @override
  State<AnimatedProgressStepper> createState() =>
      _AnimatedProgressStepperState();
}

class _AnimatedProgressStepperState extends State<AnimatedProgressStepper>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Duración de la animación
    );
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, // Suavizar la animación
      ),
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      // Verificamos si el currentStep ha aumentado o disminuido
      if (widget.currentStep > oldWidget.currentStep) {
        // Si se está avanzando, animamos hacia adelante
        _animationController.forward(from: 0);
      } else {
        // Si se está retrocediendo, animamos hacia atrás
        _animationController.reverse();
      }

      // Esperar a que la animación termine antes de cambiar el color del círculo
      Future.delayed(Duration(milliseconds: 1200), () {
        setState(() {
          // Aquí cambiamos el color del círculo correspondiente
        });
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.totalSteps,
        (index) => Row(
          children: [
            if (index > 0)
              AnimatedBuilder(
                animation:
                    _animationController, // Usamos el controlador directamente
                builder: (context, child) {
                  final progress = index <= widget.currentStep
                      ? _animationController
                          .value // Usamos el valor del controlador
                      : 0.0;
                  final isFilled = index <= widget.currentStep;

                  return SizedBox(
                    width: 40,
                    height: 4,
                    child: CustomPaint(
                      painter: StepLinePainter(
                          progress: progress, isFilled: isFilled),
                    ),
                  );
                },
              ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final circleColor = index == 0 // First circle is always blue
                    ? Colors.blue
                    : index < widget.currentStep
                        ? Colors.blue
                        : (index == widget.currentStep &&
                                _animationController.isCompleted)
                            ? Colors.blue
                            : Colors.grey[300];
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: circleColor,
                      ),
                    ),
                    Icon(
                      index < widget.currentStep
                          ? Icons.check
                          : widget.iconsStep[index],
                      color: Colors.white,
                      size: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class StepLinePainter extends CustomPainter {
  final double progress; // Progreso de la línea (0 a 1)
  final bool isFilled;

  StepLinePainter({required this.progress, required this.isFilled});

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = size.height * 0.3
      ..style = PaintingStyle.stroke;

    // Dibuja la línea base gris
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      basePaint,
    );

    if (isFilled && progress > 0) {
      final progressPaint = Paint()
        ..color = Color.lerp(
            Colors.white, Colors.blue, progress)! // Interpolación de color
        ..strokeWidth = size.height * 0.3
        ..style = PaintingStyle.stroke;

      final progressWidth = size.width * progress;
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(progressWidth, size.height / 2),
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant StepLinePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isFilled != isFilled;
  }
}
