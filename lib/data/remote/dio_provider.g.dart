// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dioHash() => r'41817e203af3f472e93b3470468b7e2e20070db2';

/// Provides a configured Dio instance for HTTP requests.
///
/// This provider creates a Dio client with:
/// - Base URL configured for the AI API
/// - Timeouts for connection, receive, and send operations
/// - JSON content type headers
/// - Request/Response logging interceptor (in debug mode)
///
/// The Dio instance can be used directly or passed to Retrofit services.
///
/// Usage example:
/// ```dart
/// final dio = ref.read(dioProvider);
/// final response = await dio.post('/endpoint', data: {...});
/// ```
///
/// Copied from [dio].
@ProviderFor(dio)
final dioProvider = AutoDisposeProvider<Dio>.internal(
  dio,
  name: r'dioProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DioRef = AutoDisposeProviderRef<Dio>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
