import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selah_app/core/core_exports.dart';
import '../../data/repository/settings_repository_impl.dart';
import '../repository/settings_repository.dart';

final settingsUseCaseProvider = Provider<SettingsUseCase>(
  (ref) => SettingsUseCase(ref.watch(settingsRepositoryProvider)),
);

class SettingsUseCase extends FutureUseCase<dynamic, dynamic> {
  final SettingsRepository repository;

  SettingsUseCase(this.repository);

  Future<Result<Settings?, Exception>> getSettings() async {
    try {
      final result = await repository.getSettings();
      return Success(result);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Result<dynamic, Exception>> run(params) {
    throw UnimplementedError();
  }
}
