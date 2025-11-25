import '../theme/_app_assets.dart';

enum MoodAnimation {
  happy('happy', AppAnimations.happy),
  sad('sad', AppAnimations.sad),
  grateful('grateful', AppAnimations.grateful),
  worried('worried', AppAnimations.worried),
  anxious('anxious', AppAnimations.anxious),
  confused('confused', AppAnimations.confused),
  hopeful('hopeful', AppAnimations.hopeful),
  lonely('lonely', AppAnimations.lonely),
  motivated('motivated', AppAnimations.motivated),
  peaceful('peaceful', AppAnimations.peaceful),
  thoughtful('thoughtful', AppAnimations.thoughtful),
  tired('tired', AppAnimations.tired);

  final String moodKey;
  final String animationPath;

  const MoodAnimation(this.moodKey, this.animationPath);

  static String? getAnimationPath(String? moodKey) {
    if (moodKey == null) return null;

    for (final animation in MoodAnimation.values) {
      if (animation.moodKey == moodKey) {
        return animation.animationPath;
      }
    }
    return null;
  }
}

