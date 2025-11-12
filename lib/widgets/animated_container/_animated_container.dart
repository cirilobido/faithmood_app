import 'package:flutter/material.dart';

enum AnimationMode { floating, pulse, both }

class AnimatedContainer extends StatefulWidget {
  /// Widget hijo a animar
  final Widget child;

  /// Modo de animación (floating, pulse o both)
  final AnimationMode mode;

  /// Duración del ciclo completo (ida y vuelta)
  final Duration duration;

  /// Rango del movimiento vertical (solo para floating)
  final double floatRange;

  /// Escala mínima y máxima (solo para pulse)
  final double minScale;
  final double maxScale;

  const AnimatedContainer({
    super.key,
    required this.child,
    this.mode = AnimationMode.floating,
    this.duration = const Duration(seconds: 3),
    this.floatRange = 10,
    this.minScale = 0.96,
    this.maxScale = 1.10,
  });

  @override
  State<AnimatedContainer> createState() => _AnimatedContainerState();
}

class _AnimatedContainerState extends State<AnimatedContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(
      begin: 0,
      end: widget.floatRange,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _scaleAnim = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        Widget animatedChild = child!;

        // Aplica animaciones según el modo seleccionado
        switch (widget.mode) {
          case AnimationMode.floating:
            animatedChild = Transform.translate(
              offset: Offset(0, -_floatAnim.value),
              child: child,
            );
            break;

          case AnimationMode.pulse:
            animatedChild = Transform.scale(
              scale: _scaleAnim.value,
              child: child,
            );
            break;

          case AnimationMode.both:
            animatedChild = Transform.translate(
              offset: Offset(0, -_floatAnim.value),
              child: Transform.scale(
                scale: _scaleAnim.value,
                child: child,
              ),
            );
            break;
        }

        return animatedChild;
      },
      child: widget.child,
    );
  }
}
