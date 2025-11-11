import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faithmood_app/core/core_exports.dart';
import '../../data/repository/local_storage_repository_impl.dart';
import '../repository/local_storage_repository.dart';

final localStorageUseCaseProvider = Provider<LocalStorageUseCase>(
  (ref) => LocalStorageUseCase(ref.watch(localStorageRepositoryProvider)),
);

class LocalStorageUseCase extends FutureUseCase<dynamic, dynamic> {
  final LocalStorageRepository _repository;

  LocalStorageUseCase(this._repository);

  Future<bool> getIsUserLoggedIn() async {
    return _repository.getIsUserLoggedIn();
  }

  Future<void> setIsFirstTimeOpen(bool isDarkMode) async {
    return _repository.setFirstTimeOpen(isDarkMode);
  }

  Future<bool> getIsFirstTimeOpen() async {
    return _repository.getIsFirstTimeOpen();
  }

  Future<String?> getAppLanguage() async {
    return _repository.getAppLanguage();
  }

  Future<void> setAppLanguage(String language) async {
    return _repository.setAppLanguage(language);
  }

  Future<String?> getReminderTime() async {
    return _repository.getReminderTime();
  }

  Future<void> setReminderTime(String time) async {
    return _repository.setReminderTime(time);
  }

  Future<void> deleteReminderTime() async {
    return _repository.deleteReminderTime();
  }

  @override
  Future<Result<dynamic, Exception>> run(params) {
    throw UnimplementedError();
  }
}
