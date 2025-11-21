import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';
import '../widgets_exports.dart';

class TagsModal {
  static void show({
    required BuildContext context,
    required List<Tag> tags,
    ValueChanged<Tag>? onTagSelected,
  }) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    showDialog(
      context: context,
      builder: (BuildContext modalContext) {
        return Dialog(
          backgroundColor: theme.colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        lang.selectTag,
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(modalContext).pop(),
                      child: SvgPicture.asset(
                        AppIcons.closeIcon,
                        width: AppSizes.iconSizeMedium,
                        colorFilter: ColorFilter.mode(
                          theme.iconTheme.color!,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spacingMedium),
                Flexible(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: AppSizes.spacingSmall,
                      runSpacing: AppSizes.spacingSmall,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: tags.map((tag) {
                        return DevotionalTagChip(
                          tag: tag,
                          onTap: () {
                            Navigator.of(modalContext).pop();
                            if (onTagSelected != null) {
                              onTagSelected(tag);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spacingMedium),
              ],
            ),
          ),
        );
      },
    );
  }
}

