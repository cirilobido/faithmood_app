import 'package:faithmood_app/core/core_exports.dart';

abstract class SettingsRepository {
  Future<Settings?> getSettings();
}
