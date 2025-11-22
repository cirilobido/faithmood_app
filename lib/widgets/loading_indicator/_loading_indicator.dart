import 'package:flutter/material.dart';

import '../../core/core_exports.dart';

class LoadingIndicator extends StatelessWidget {
  final double? size;
  final double strokeWidth;
  final EdgeInsets? padding;

  const LoadingIndicator({
    super.key,
    this.size,
    this.strokeWidth = 3,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox(
      width: size ?? AppSizes.iconSizeMedium,
      height: size ?? AppSizes.iconSizeMedium,
      child: CircularProgressIndicator(strokeWidth: strokeWidth),
    );

    if (padding != null) {
      return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: padding!,
          child: indicator,
        ),
      );
    }

    return indicator;
  }
}

