import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selah_app/core/core_exports.dart';
import '../../../../dev_utils/dev_utils_exports.dart';
import '../../data/repository/analytics_repository_impl.dart';
import '../repository/analytics_repository.dart';

final analyticsUseCaseProvider = Provider<AnalyticsUseCase>(
  (ref) => AnalyticsUseCase(ref.watch(analyticsRepositoryProvider)),
);

class AnalyticsUseCase extends FutureUseCase<dynamic, dynamic> {
  final AnalyticsRepository repository;

  AnalyticsUseCase(this.repository);

  Future<Result<Analytics?, Exception>> getUserAnalytics(
    int userId,
    String startDate,
    String endDate, {
    bool forceRefresh = false,
  }) async {
    try {
      final result = await repository.getUserAnalytics(
        userId,
        startDate,
        endDate,
        forceRefresh: forceRefresh,
      );
      return Success(result);
    } catch (e) {
      devLogger('AnalyticsUseCase.getUserAnalytics() - ERROR: $e');
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<dynamic, Exception>> run(params) {
    throw UnimplementedError();
  }
}

