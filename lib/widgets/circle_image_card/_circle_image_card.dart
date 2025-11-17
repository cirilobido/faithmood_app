import 'package:flutter/material.dart';
import '../../core/core_exports.dart';

class CircleImageCard extends StatelessWidget {
  final String asset;
  final double? offsetX;
  final double? size;
  final Color? color;

  const CircleImageCard({
    super.key,
    required this.asset,
    this.offsetX = 0,
    this.size = AppSizes.iconSizeXXLarge,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Transform.translate(
      offset: Offset(offsetX!, 0),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingXXSmall),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color ?? theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.surface,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            asset,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
