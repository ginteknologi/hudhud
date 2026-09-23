import 'package:dio/dio.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/core/network/api_response.dart';
import 'package:masjid_app/core/network/app_exception.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({String? baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = PreferencesService.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic json)? fromJson,
  ) {
    final body = response.data;
    if (body is Map<String, dynamic>) {
      return ApiResponse<T>.fromJson(body, fromJson);
    } else {
      return ApiResponse<T>(
        success: response.statusCode == 200,
        code: response.statusCode ?? 200,
        message: 'Success',
        data: body as T?,
      );
    }
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'Koneksi ke server terputus. Pastikan internet Anda aktif.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        String message = 'Terjadi kesalahan pada server ($statusCode).';
        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        }

        if (statusCode == 401) {
          return UnauthorizedException(message: message);
        } else if (statusCode == 404) {
          return NotFoundException(message: message);
        }
        return ServerException(message: message, statusCode: statusCode);
      default:
        return AppException(
          message: error.message ?? 'Terjadi kesalahan yang tidak terduga.',
        );
    }
  }
}
