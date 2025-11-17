import 'package:flutter/material.dart';

class GradientGreenContainer extends StatefulWidget {
  const GradientGreenContainer({super.key});

  @override
  State<GradientGreenContainer> createState() => _GradientGreenContainerState();
}

class _GradientGreenContainerState extends State<GradientGreenContainer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.center,
      child: Transform.scale(
        scaleY: 0.6,
        child: Container(
          width: 400,
          // height: 200,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, 0.2),
              // subtle offset like your example
              radius: 0.5,
              colors: [
                theme.colorScheme.secondary.withValues(alpha: 0.8),
                // solid green center
                theme.colorScheme.secondary.withValues(alpha: 0.5),
                // semi-transparent midpoint
                theme.colorScheme.secondary.withValues(alpha: 0.0),
                // fully transparent edge
              ],
              stops: const [0.0, 0.2, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
      ),
    );
  }
}
