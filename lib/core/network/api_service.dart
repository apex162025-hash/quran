import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../commons/models/pagination_model.dart';
import 'api_response_handler.dart';
import 'dio_helper.dart';

class ApiService {
  static Future<ApiResponseHandler<T>> sendRequest<T>({
    required String url,
    required T Function(Map<String, dynamic>) fromJson,
    dynamic body,
    dynamic query,
    dynamic token,

    RequestMethod method = RequestMethod.get, // Default is GET
  }) async {
    try {
      Response response;
      switch (method) {
        case RequestMethod.get:
          response = await DioHelper.getData(url: url, query: query);
          break;
        case RequestMethod.post:
          response = await DioHelper.postData(
            url: url,
            data: body,
            token: token,
          );
          break;
        case RequestMethod.put:
          response = await DioHelper.putData(url: url, data: body);
          break;
        case RequestMethod.delete:
          response = await DioHelper.deleteData(url: url, query: query);
          break;
      }
      bool success = response.data['status'] ?? true;
      String message = response.data['message'] ?? "Request successful";

      // Treat any 2xx status code as success (200..299)
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300 &&
          success) {
        Pagination? pagination;
        if (response.data.containsKey('pagination') &&
            response.data['pagination'] != null) {
          pagination = Pagination.fromJson(response.data['pagination']);
        }
        if (response.data.containsKey('data')) {
          var responseData = response.data['data'];

          if (responseData == null) {
            return ApiResponseHandler.successWithoutData(message);
          } else if (responseData is List) {
            List<T> parsedList =
                responseData
                    .map((item) => fromJson(item as Map<String, dynamic>))
                    .toList();
            return ApiResponseHandler.successList(
              parsedList,
              message,
              pagination: pagination,
            );
          } else if (responseData is Map<String, dynamic>) {
            T parsedData = fromJson(responseData);
            return ApiResponseHandler.successSingle(
              parsedData,
              message,
              pagination: pagination,
            );
          } else if (responseData is String) {
            return ApiResponseHandler.successString(responseData, message);
          }
        }
        return ApiResponseHandler.successWithoutData(message);
      } else {
        return ApiResponseHandler.failure(
          _handleStatusCode(response.statusCode),
          message,
        );
      }
    } on DioException catch (e) {
      return ApiResponseHandler.failure(_handleDioError(e), "error_no_internet".tr);
    }
  }

  static String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return "error_400".tr;
      case 401:
        return "error_401".tr;
      case 403:
        return "error_403".tr;
      case 404:
        return "error_404".tr;
      case 405:
        return "error_405".tr;
      case 500:
        return "error_500".tr;
      default:
        return "unexpected_error".tr;
    }
  }

  /// Handles Dio errors
  static String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return "error_timeout".tr;
    }

    if (e.response != null && e.response!.data != null) {
      try {
        return e.response!.data['message'] ?? "error_unknown".tr;
      } catch (_) {
        return _handleStatusCode(e.response!.statusCode);
      }
    } else {
      return "error_no_internet".tr;
    }
  }

  ///////////////////////////////////
  static Future<ApiResponseHandler<T>> sendRawRequest<T>({
    required String url,
    required T Function(Map<String, dynamic>) fromJson,
    dynamic body,
    dynamic query,
    RequestMethod method = RequestMethod.get,
  }) async {
    try {
      Response response;

      switch (method) {
        case RequestMethod.get:
          response = await DioHelper.getData(url: url, query: query);
          break;
        case RequestMethod.post:
          response = await DioHelper.postData(url: url, data: body);
          break;
        case RequestMethod.put:
          response = await DioHelper.putData(url: url, data: body);
          break;
        case RequestMethod.delete:
          response = await DioHelper.deleteData(url: url, query: query);
          break;
      }

      // ========= SUCCESS CASE (any 2xx)
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        if (response.data is Map<String, dynamic>) {
          return ApiResponseHandler.successSingle(
            fromJson(response.data),
            response.data["message"] ?? "Success",
          );
        }

        return ApiResponseHandler.failure(
          "Unexpected API format",
          "Unexpected structure",
        );
      }

      // ========= ANY OTHER NON-200 STATUS
      return ApiResponseHandler.failure(
        _handleStatusCode(response.statusCode),
        response.data["message"] ?? "Unexpected API structure",
      );
    }
    // ========= DIO VALIDATION ERRORS
    on DioException catch (e) {
      final res = e.response;

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponseHandler.failure(
          "error_timeout".tr,
          "error_timeout".tr,
        );
      }

      // ---- Laravel validation error (422)
      if (res != null && res.statusCode == 422) {
        return ApiResponseHandler.failure(
          "validation_error".tr,
          res.data["message"] ??
              res.data["errors"]?.values.first.first ??
              "validation_error".tr,
        );
      }

      // ---- Other known HTTP errors like 400, 401, 403, 500
      if (res != null) {
        return ApiResponseHandler.failure(
          _handleStatusCode(res.statusCode),
          res.data["message"] ?? "error_unknown".tr,
        );
      }

      // ---- No response at all (connection problems)
      return ApiResponseHandler.failure(
        "error_no_internet".tr,
        "error_no_internet".tr,
      );
    }
    // ========= UNKNOWN ERROR
    catch (e) {
      return ApiResponseHandler.failure("error_unknown".tr, e.toString());
    }
  }
}

/// Enum to represent HTTP request methods
enum RequestMethod { get, post, put, delete }
