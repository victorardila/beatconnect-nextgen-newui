import 'dart:async';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AnimatedTooltip extends StatefulWidget {
  final Widget child;
  final String tooltipText;
  final double bottomOffset;
  final double leftOffset;
  final Duration duration;
  final double height;

  const AnimatedTooltip({
    super.key,
    required this.child,
    required this.tooltipText,
    this.bottomOffset = 0,
    this.leftOffset = 0,
    this.duration = const Duration(seconds: 3),
    this.height = 100,
  });

  @override
  State<AnimatedTooltip> createState() => _AnimatedTooltipState();
}

class _AnimatedTooltipState extends State<AnimatedTooltip> {
  bool _isVisible = true;
  Timer? _hideTimer;
  double _opacity = 1.0; // Variable para controlar la opacidad

  @override
  void initState() {
    super.initState();
    _hideTimer = Timer(widget.duration, _hideTooltip);
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _hideTooltip() {
    setState(() {
      _opacity =
          0.0; // Cambia la opacidad a 0 para el efecto de desvanecimiento
    });
    Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _isVisible = false; // Oculta el tooltip después de que se desvanece
      });
    });
  }

  void _showTooltip() {
    setState(() {
      _isVisible = true; // Muestra el tooltip
      _opacity = 1.0; // Restaura la opacidad
    });
    _hideTimer?.cancel(); // Cancela el temporizador anterior
    _hideTimer = Timer(widget.duration, _hideTooltip); // Inicia el temporizador
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('tooltip-${widget.tooltipText}'),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0) {
          _showTooltip();
        }
      },
      child: Stack(
        children: [
          // Mantener el child en su posición original
          Positioned(
            bottom: widget.bottomOffset,
            left: widget.leftOffset,
            child: widget.child,
          ),
          // Mostrar el tooltip solo si es visible
          if (_isVisible)
            Positioned(
              bottom:
                  widget.bottomOffset + 40, // Ajusta la posición del tooltip
              left: widget.leftOffset,
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(
                    milliseconds: 300), // Duración de la animación
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width -
                        40, // Ajusta el ancho máximo
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey[100]!,
                        Colors.grey[300]!,
                        Colors.grey[400]!,
                        Colors.grey[500]!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey[400]!,
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.tooltipText,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    maxLines: 2, // Limita el número de líneas
                    overflow: TextOverflow
                        .ellipsis, // Agrega "..." si el texto se corta
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
