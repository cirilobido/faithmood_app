import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/core_exports.dart';
import '../widgets_exports.dart';
import '../../features/devotionals/devotional_details/_devotional_details_view_model.dart';

class TtsPlayerDialog {
  static Future<void> show({
    required BuildContext context,
    required int devotionalId,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(
              devotionalDetailsViewModelProvider(devotionalId),
            );
            final vm = ref.read(
              devotionalDetailsViewModelProvider(devotionalId).notifier,
            );
            final theme = Theme.of(context);
            
            if (state.devotional == null) {
              return const SizedBox.shrink();
            }
            
            final devotional = state.devotional!;
            
            return AlertDialog(
              alignment: Alignment.center,
              contentPadding: const EdgeInsets.all(AppSizes.paddingMedium),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: AppSizes.iconSizeRegular),
                      Expanded(
                        child: Text(
                          devotional.title ?? '',
                          style: theme.textTheme.titleMedium,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(dialogContext).pop(),
                        child: SvgPicture.asset(
                          AppIcons.closeIcon,
                          width: AppSizes.iconSizeMedium,
                          height: AppSizes.iconSizeMedium,
                          colorFilter: ColorFilter.mode(
                            theme.primaryIconTheme.color!,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacingLarge),
                  _buildImageOrEmoji(context, theme, devotional),
                  const SizedBox(height: AppSizes.spacingLarge),
                  TtsControls(
                    isPlaying: state.isPlaying,
                    isPaused: state.isPaused,
                    progress: state.progress,
                    currentPosition: state.currentPosition,
                    totalLength: state.totalLength,
                    onPlayPause: () async {
                      if (state.isPlaying) {
                        await vm.pauseTTS();
                      } else {
                        await vm.playTTS();
                      }
                    },
                    onStop: () => vm.stopTTS(),
                    onSeek: (progress) => vm.seekToPosition(progress),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildImageOrEmoji(BuildContext context, ThemeData theme, Devotional devotional) {
    
    if (devotional.coverImage != null && devotional.coverImage!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: CachedNetworkImage(
          imageUrl: devotional.coverImage!,
          width: double.infinity,
          height: AppSizes.dialogIconSize,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: double.infinity,
            height: AppSizes.dialogIconSize,
            color: theme.colorScheme.surface,
            child: const Center(child: LoadingIndicator()),
          ),
          errorWidget: (context, url, error) => _buildEmojiContainer(theme, devotional.iconEmoji),
        ),
      );
    }

    return _buildEmojiContainer(theme, devotional.iconEmoji);
  }

  static Widget _buildEmojiContainer(ThemeData theme, String? emoji) {
    return Container(
          width: double.infinity,
      height: AppSizes.dialogIconSize,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      alignment: Alignment.center,
      child: Text(
        emoji ?? '📖',
        textAlign: TextAlign.center,
        style: theme.textTheme.headlineMedium,
      ),
    );
  }
}

