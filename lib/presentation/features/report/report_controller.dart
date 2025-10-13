import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/repositories/ai_report_repository.dart';

part 'report_controller.g.dart';

/// Controller for managing the final AI report generation.
///
/// This controller handles the async state of report generation by calling
/// the AIReportRepository. It uses Riverpod's AsyncNotifier to manage
/// loading, error, and data states automatically.
@riverpod
class ReportController extends _$ReportController {
  /// Builds the initial state by generating the final AI report.
  ///
  /// This method:
  /// 1. Fetches the AIReportRepository
  /// 2. Calls generateFinalReport() to create the comprehensive report
  /// 3. Returns the generated report text
  ///
  /// The AsyncNotifier automatically handles:
  /// - Loading state during API call
  /// - Error state if generation fails
  /// - Data state when report is successfully generated
  ///
  /// Throws an exception if the repository fails to generate the report.
  @override
  Future<String> build() async {
    final repository = await ref.watch(aiReportRepositoryProvider.future);
    return await repository.generateFinalReport();
  }

  /// Manually triggers a report regeneration.
  ///
  /// This method can be called to refresh/regenerate the report.
  /// It sets the state to loading and calls the repository again.
  Future<void> regenerateReport() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(aiReportRepositoryProvider.future);
      return await repository.generateFinalReport();
    });
  }
}
