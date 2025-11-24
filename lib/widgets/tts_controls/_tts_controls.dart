import 'package:flutter/material.dart';

import '../../core/core_exports.dart';

class TtsControls extends StatefulWidget {
  final bool isPlaying;
  final bool isPaused;
  final double progress;
  final int currentPosition;
  final int totalLength;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;
  final Function(double) onSeek;

  const TtsControls({
    super.key,
    required this.isPlaying,
    required this.isPaused,
    required this.progress,
    required this.currentPosition,
    required this.totalLength,
    required this.onPlayPause,
    required this.onStop,
    required this.onSeek,
  });

  @override
  State<TtsControls> createState() => _TtsControlsState();
}

class _TtsControlsState extends State<TtsControls> {
  bool _isDragging = false;
  double _dragValue = 0.0;

  @override
  void didUpdateWidget(TtsControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDragging) {
      _dragValue = widget.progress;
    }
  }

  @override
  void initState() {
    super.initState();
    _dragValue = widget.progress;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayValue = _isDragging ? _dragValue : widget.progress;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  widget.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: theme.colorScheme.primary,
                ),
                onPressed: widget.onPlayPause,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    trackShape: GradientActiveTrackShape(
                      gradient: AppColors.progressGradient,
                      inactiveColor: theme.colorScheme.tertiary.withValues(
                        alpha: 0.2,
                      ),
                    ),
                    thumbColor: theme.colorScheme.primary,
                    overlayColor: theme.colorScheme.tertiary.withValues(
                      alpha: 0.2,
                    ),
                  ),
                  child: Slider(
                    value: displayValue.clamp(0.0, 1.0),
                    onChanged: (value) {
                      setState(() {
                        _isDragging = true;
                        _dragValue = value;
                      });
                    },
                    onChangeEnd: (value) {
                      setState(() => _isDragging = false);
                      widget.onSeek(value);
                    },
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.stop, color: theme.colorScheme.primary),
                onPressed: widget.onStop,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSizes.paddingSmall,
              right: AppSizes.paddingSmall,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time,
                  size: AppSizes.iconSizeSmall,
                  color: theme.iconTheme.color,
                ),
                const SizedBox(width: AppSizes.spacingXSmall),
                Text(
                  '${_formatTime(widget.currentPosition)}/${_formatTime(widget.totalLength)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int chars) {
    if (chars == 0) return '00:00';

    const charsPerSecond = 15.0;
    final seconds = (chars / charsPerSecond).round();
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

class GradientActiveTrackShape extends SliderTrackShape {
  final Gradient gradient;
  final Color inactiveColor;

  GradientActiveTrackShape({
    required this.gradient,
    required this.inactiveColor,
  });

  @override
  Rect getPreferredRect({
    bool isDiscrete = false,
    bool isEnabled = true,
    Offset offset = Offset.zero,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = true,
    required RenderBox parentBox,
    Offset? secondaryOffset,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required Offset thumbCenter,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      offset: offset,
    );

    final double activeWidth = thumbCenter.dx - trackRect.left;

    // ACTIVE TRACK (gradient)
    final Rect activeRect = Rect.fromLTWH(
      trackRect.left,
      trackRect.top,
      activeWidth.clamp(0, trackRect.width),
      trackRect.height,
    );

    final Paint activePaint = Paint()
      ..shader = gradient.createShader(activeRect);

    // INACTIVE TRACK
    final Rect inactiveRect = Rect.fromLTWH(
      activeRect.right,
      trackRect.top,
      (trackRect.width - activeWidth).clamp(0, trackRect.width),
      trackRect.height,
    );

    final Paint inactivePaint = Paint()..color = inactiveColor;

    // Draw active
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(
        activeRect,
        Radius.circular(trackRect.height / 2),
      ),
      activePaint,
    );

    // Draw inactive
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(
        inactiveRect,
        Radius.circular(trackRect.height / 2),
      ),
      inactivePaint,
    );
  }
}
