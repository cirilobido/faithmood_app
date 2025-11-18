import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/widgets_exports.dart';
import '../_welcome_view_model.dart';
import '../widgets/_section_container.dart';

class PageSocial extends ConsumerWidget {
  const PageSocial({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(welcomeViewModelProvider.notifier);
    final lang = S.of(context);

    final options = {
      'whatsapp': '📱 WhatsApp',
      'facebook': '📘 Facebook',
      'instagram': '📸 Instagram',
      'tiktok': '🎵 TikTok',
      'twitter-x': '🐦 X (Twitter)',
      'youtube': '▶️ YouTube',
      'website': '🌐 Website',
      'reddit': '👽 Reddit',
      'friend': lang.socialDiscoverQ9,
      'church': lang.socialDiscoverQ10,
      'search': lang.socialDiscoverQ11,
    };

    return SectionContainer(
      title: lang.socialDiscoverTitle,
      subtitle: null,
      content: RadioListSelector(
        options: options,
        initialSelectedKey: vm.selectedSocial,
        onChanged: (v) => vm.selectedSocial = v,
      ),
    );
  }
}
