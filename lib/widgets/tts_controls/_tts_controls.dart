import 'package:flutter/material.dart';

import '../../core/core_exports.dart';

class TtsControls extends StatefulWidget {
  final bool isPlaying;
  final bool isPaused;
  final double progress;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;
  final Function(double) onSeek;

  const TtsControls({
    super.key,
    required this.isPlaying,
    required this.isPaused,
    required this.progress,
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
    if (!_isDragging && oldWidget.progress != widget.progress) {
      _dragValue = widget.progress;
    }
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
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            width: AppSizes.borderWithSmall,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                child: Slider(
                  value: displayValue.clamp(0.0, 1.0),
                  onChanged: (value) {
                    setState(() {
                      _isDragging = true;
                      _dragValue = value;
                    });
                  },
                  onChangeEnd: (value) {
                    setState(() {
                      _isDragging = false;
                    });
                    widget.onSeek(value);
                  },
                  activeColor: theme.colorScheme.primary,
                  inactiveColor: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.stop,
                  color: theme.colorScheme.primary,
                ),
                onPressed: widget.onStop,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

