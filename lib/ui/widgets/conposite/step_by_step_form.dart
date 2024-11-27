import '../../../imports.dart';

class StepByStepForm extends StatefulWidget {
  final List<IconData> iconsStep;
  final List<Widget> steps; // Cambia a una lista de StepData
  final Function? onSubmit; // Función a ejecutar al enviar el formulario.

  const StepByStepForm({
    Key? key,
    required this.iconsStep,
    required this.steps,
    this.onSubmit,
  }) : super(key: key);
  @override
  _StepByStepFormState createState() => _StepByStepFormState();
}

class _StepByStepFormState extends State<StepByStepForm> {
  int _currentStep = 0;
  late List<Widget> stepDataList; // Nueva variable para almacenar StepData

  void _goToNextStep() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _handleSwipe(DragEndDetails details) {
    // Detectar si el gesto es hacia la izquierda o derecha
    if (details.primaryVelocity != null) {
      if (details.primaryVelocity! < 0) {
        // Deslizar hacia la izquierda (siguiente paso)
        _goToNextStep();
      } else if (details.primaryVelocity! > 0) {
        // Deslizar hacia la derecha (paso anterior)
        _goToPreviousStep();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    stepDataList = widget.steps; // Asigna directamente la lista de pasos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: GestureDetector(
                  onHorizontalDragEnd:
                      _handleSwipe, // Detectar el gesto horizontal
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Barra de progreso
                      AnimatedProgressStepper(
                        totalSteps: widget.steps.length,
                        iconsStep: widget.iconsStep,
                        currentStep: _currentStep, // Pasar el paso actual
                      ),
                      Flexible(
                        child: SizedBox(
                          height: double.infinity,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: // Aquí está el cambio crucial
                                _currentStep < widget.steps.length
                                    ? KeyedSubtree(
                                        key: ValueKey(
                                            _currentStep), // Clave única para cada paso
                                        child: widget.steps[_currentStep],
                                      )
                                    : Container(), // Maneja el caso de _currentStep fuera de rango
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: _currentStep == 0
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          if (_currentStep > 0)
                            ButtonGradient(
                              width: MediaQuery.of(context).size.width * 0.3,
                              text: 'Anterior',
                              icon: FontAwesomeIcons.arrowLeft,
                              iconDirection: 'left',
                              onPressed: _goToPreviousStep,
                            ),
                          ButtonGradient(
                            width: MediaQuery.of(context).size.width * 0.3,
                            text: _currentStep < (widget.steps.length) - 1
                                ? 'Siguiente'
                                : 'Crear',
                            icon: _currentStep < (widget.steps.length) - 1
                                ? FontAwesomeIcons.arrowRight
                                : null,
                            iconDirection: 'right',
                            onPressed: _currentStep < (widget.steps.length) - 1
                                ? _goToNextStep
                                : () {
                                    if (widget.onSubmit != null) {
                                      widget.onSubmit!();
                                    }
                                  },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
