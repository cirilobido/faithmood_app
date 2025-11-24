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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(widget.currentPosition),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  _formatTime(widget.totalLength),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int chars) {
    if (chars == 0) return '0:00';
    
    const charsPerSecond = 15.0;
    final seconds = (chars / charsPerSecond).round();
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    
    return '${minutes}:${secs.toString().padLeft(2, '0')}';
  }
}

