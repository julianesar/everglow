import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

/// Configuration constants for the API client.
class ApiConfig {
  /// The base URL for the AI API.
  ///
  /// TODO: Replace this with your actual API endpoint.
  /// Consider using environment variables for different environments:
  /// - Development: 'http://localhost:3000/api'
  /// - Production: 'https://api.yourapp.com'
  static const String baseUrl = 'https://api.example.com';

  /// Default connection timeout in milliseconds (30 seconds).
  static const int connectTimeout = 30000;

  /// Default receive timeout in milliseconds (30 seconds).
  static const int receiveTimeout = 30000;

  /// Default send timeout in milliseconds (30 seconds).
  static const int sendTimeout = 30000;
}

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
@riverpod
Dio dio(DioRef ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConfig.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeout),
      sendTimeout: const Duration(milliseconds: ApiConfig.sendTimeout),
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

  // Add authentication interceptor if needed
  // dio.interceptors.add(AuthInterceptor());

  return dio;
}
