import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'ai_report_service.dart';
import 'dio_provider.dart';

part 'ai_report_service_provider.g.dart';

/// Provides an instance of [AiReportService].
///
/// This provider creates a Retrofit-based API service for generating AI reports.
/// It uses the [dioProvider] to get a configured Dio instance and passes it
/// to the AiReportService constructor.
///
/// The service handles all HTTP communication with the AI API, including:
/// - Request serialization
/// - Response deserialization
/// - Error handling
///
/// Usage example:
/// ```dart
/// final service = ref.read(aiReportServiceProvider);
/// final response = await service.generateReport({'userData': {...}});
/// final reportText = response.report;
/// ```
@riverpod
AiReportService aiReportService(AiReportServiceRef ref) {
  final dio = ref.watch(dioProvider);
  return AiReportService(dio);
}
