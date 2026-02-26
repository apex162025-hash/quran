import 'dart:developer';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constance/api_paths.dart';
import '../enums/enums.dart';
import '../local/cache_controller.dart';
import '../local/cache_helper.dart';
import '../routing/app_routes.dart';

class DioHelper {
  static late String initialLocale;
  static final Dio dio = Dio();

  /// Initializes Dio with base configurations
  static Future<void> init() async {
    initialLocale = await _getDeviceLanguageCode();
    _initializeDio();
  }

  /// Configures Dio with base options and interceptors
  static void _initializeDio() async {
    String token =
        await CacheHelper.safeRead(key: CacheKeys.userToken.name) ?? "";
    dio.options = BaseOptions(
      baseUrl: ApiPaths.baseUrl,
      followRedirects: false,
      receiveDataWhenStatusError: true,
      validateStatus: (status) => status! < 500, // Accept responses <500
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Language': CacheHelper.getData(key: 'langCode') ?? "ar",
        'Authorization': token != null ? "Bearer $token" : "",
        'X-Client-FCM-Token':
            CacheController().getter(key: CacheKeys.fcmToken)?.toString() ?? '',
      },
    );

    // Add interceptors
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // No need to call _updateHeaders() here, it's called in getData/postData
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.statusCode == 401) {
            log("Unauthorized! Redirecting to login...");
            _handleUnauthorized();
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            log("Unauthorized Error! Redirecting to login...");
            _handleUnauthorized();
          }
          return handler.next(e);
        },
      ),
    );

    // Enable logging in debug mode
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  /// Updates headers dynamically before every request
  static Future<void> _updateHeaders() async {
    String? token = await CacheHelper.safeRead(key: CacheKeys.userToken.name);
    log("Token in updateHeaders: $token");
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // ---  FIX 2: Use 'langCode' ---
      'Accept-Language': CacheHelper.getData(key: 'langCode') ?? "ar",
      'Authorization': token != null ? "Bearer $token" : "",
      'X-Client-FCM-Token':
          CacheController().getter(key: CacheKeys.fcmToken)?.toString() ?? '',
    };
    log("Updated Headers: ${dio.options.headers}");
  }

  /// Manually updates headers (e.g., when language changes)
  static updateHeadersManually() async {
    await _updateHeaders();
    log("Headers manually updated.");
  }

  /// Handles unauthorized responses (401)
  static void _handleUnauthorized() {
    CacheHelper.clearCache(key: CacheKeys.userToken.name);
    getx.Get.offAllNamed(Routes.loginRoute);
    log("Redirecting to login page...");
  }

  /// Retrieves the device's default language
  static Future<String> _getDeviceLanguageCode() async {
    final platformDispatcher = PlatformDispatcher.instance;
    return platformDispatcher.locale.languageCode;
  }

  // ====================== API REQUEST METHODS ======================

  /// Sends a GET request
  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    try {
      await _updateHeaders(); // Ensure headers are up to date
      final response = await dio.get(url, queryParameters: query);
      return response;
    } catch (e) {
      log("GET Error [$url]: $e");
      rethrow;
    }
  }

  /// Sends a POST request
  static Future<Response> postData({
    required String url,
    dynamic data,
    String? token,
    bool withFiles = false,
  }) async {
    try {
      await _updateHeaders(); // Ensure headers are up to date
      dio.options.headers['Content-Type'] =
          withFiles ? "multipart/form-data" : "application/json";
      if (token != null || token != "") {
        dio.options.headers['token'] = token ?? "";
      }
      final response = await dio.post(url, data: data);
      return response;
    } catch (e) {
      log("POST Error [$url]: $e");
      rethrow;
    }
  }

  // ... (putData and deleteData methods remain the same) ...

  /// Sends a PUT request
  static Future<Response> putData({required String url, dynamic data}) async {
    try {
      await _updateHeaders(); // Ensure headers are up to date
      final response = await dio.put(url, data: data);
      return response;
    } catch (e) {
      log("PUT Error [$url]: $e");
      rethrow;
    }
  }

  /// Sends a DELETE request
  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    try {
      await _updateHeaders(); // Ensure headers are up to date
      final response = await dio.delete(url, queryParameters: query);
      return response;
    } catch (e) {
      log("DELETE Error [$url]: $e");
      rethrow;
    }
  }
}
