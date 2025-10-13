import 'package:dio/dio.dart';
import 'package:everglow_app/data/remote/api_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

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
@riverpod
Dio dio(DioRef ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://generativelanguage.googleapis.com',
      queryParameters: {'key': geminiApiKey},
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );

  // Add logging interceptor for debugging
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      error: true,
      logPrint: (object) {
        // In production, you might want to use a proper logging library
        // ignore: avoid_print
        print('[Dio] $object');
      },
    ),
  );

  return dio;
}
