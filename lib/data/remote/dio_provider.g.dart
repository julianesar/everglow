// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dioHash() => r'229e91309d806775ffd67d22585aa6fb218c1b60';

/// Provides a configured Dio instance for Gemini API requests.
///
/// This provider creates a Dio client with:
/// - Base URL configured for the Gemini API
/// - API key as query parameter for authentication (from api_keys.dart)
/// - JSON content type headers
/// - Request/Response logging interceptor (for debugging)
///
/// The Dio instance can be used directly or passed to Retrofit services.
///
/// Usage example:
/// ```dart
/// final dio = ref.read(dioProvider);
/// final response = await dio.post('/v1beta/models/gemini-2.5-flash:generateContent', data: {...});
/// ```
///
/// Copied from [dio].
@ProviderFor(dio)
final dioProvider = AutoDisposeProvider<Dio>.internal(
  dio,
  name: r'dioProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DioRef = AutoDisposeProviderRef<Dio>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
