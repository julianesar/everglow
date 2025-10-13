// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_report_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiReportServiceHash() => r'f6e5b1c44a1f7601551935f4e8a87b07e221ada1';

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
///
/// Copied from [aiReportService].
@ProviderFor(aiReportService)
final aiReportServiceProvider = AutoDisposeProvider<AiReportService>.internal(
  aiReportService,
  name: r'aiReportServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aiReportServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AiReportServiceRef = AutoDisposeProviderRef<AiReportService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
