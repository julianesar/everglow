import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'ai_report_service.dart';
import 'dio_provider.dart';

part 'ai_report_service_provider.g.dart';

/// Provides an instance of [AiReportService].
///
/// This provider creates a Retrofit-based API service for communicating with
/// the Google Gemini API. It uses the [dioProvider] to get a configured Dio
/// instance (with API key authentication) and passes it to the AiReportService
/// constructor.
///
/// The service handles all HTTP communication with the Gemini API, including:
/// - Request serialization
/// - Response deserialization
/// - API key authentication via interceptor
/// - Error handling
///
/// Usage example:
/// ```dart
/// final service = ref.read(aiReportServiceProvider);
/// final response = await service.generateReport({
///   'contents': [
///     {
///       'parts': [
///         {'text': 'Generate a report about...'}
///       ]
///     }
///   ]
/// });
/// final generatedText = response['candidates'][0]['content']['parts'][0]['text'];
/// ```
@riverpod
AiReportService aiReportService(AiReportServiceRef ref) {
  final dio = ref.watch(dioProvider);
  return AiReportService(dio);
}
