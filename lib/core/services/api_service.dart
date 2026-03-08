import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import '../model/api_model.dart';
import '../utils/local_storage.dart';

class ApiService {
  static ApiService? _apiService;

  ApiService._();

  static ApiService? get instance {
    _apiService ??= ApiService._();
    return _apiService;
  }

  Dio dio = Dio();

  // Update Cookie for API calls
  void updateCookie(Headers headers) {
    //Get the value of the cookie passed in the response
    final rawCookie = headers['set-cookie'];

    if (rawCookie != null) {
      Logger().i("Cookies: $rawCookie");

      //Get the index of the equals symbol
      int indexOfEquals = rawCookie[0].indexOf('=');
      //Get index of the first semiColon symbol
      int indexOfSemiColon = rawCookie[0].indexOf(';');

      //Stores the value of the token
      String token = "";

      // Handle cases where the string might not contain an equals symbol
      if (indexOfEquals != -1 &&
          indexOfSemiColon != -1 &&
          indexOfEquals < indexOfSemiColon) {
        //Get the string after the first equals symbol
        token = rawCookie[0].substring(indexOfEquals + 1, indexOfSemiColon);

        //Store the token in the localStorage
        LocalStorageHelper().setAccessToken(accessToken: token);

        Logger().i("Auth: $token");
      } else {
        // Optionally handle cases where the string doesn't have an equals symbol
        token = "";

        //Store the token in the localStorage
        LocalStorageHelper().setAccessToken(accessToken: token);

        Logger().i("Auth: $token");
      }
    }
  }

  Future<ApiResponse<T>> postRequestHandler<T>(
    String url,
    dynamic body, {
    T Function(dynamic)? transform,
    Options? options,
    String? accessToken,
    String? apiKey,
    bool interchange = false,
    bool changeContent = false,
    CancelToken? cancelToken,
  }) async {
    transform ??= (dynamic r) => r.body as T;
    final ApiResponse<T> apiResponse = ApiResponse<T>();

    Logger().i("Request Path ${dotenv.env["BASE_URL"]}$url");
    Logger().i("Request body $body");

    try {
      // Set headers locally for this request
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': changeContent
            ? 'application/x-www-form-urlencoded'
            : 'application/json',
      };

      final requestOptions =
          options?.copyWith(headers: headers) ?? Options(headers: headers);

      Logger().i("Authorization: $accessToken");

      final res = await dio.post(
        "${dotenv.env["BASE_URL"]}$url",
        data: body,
        options: requestOptions,
        cancelToken: cancelToken,
      );

      final dynamic data = res.data;

      Logger().i("Response $data");

      if (res.statusCode == 200 || res.statusCode == 201) {
        //Call the update Cookie function
        updateCookie(res.headers);

        apiResponse.responseSuccessful = data['success'] ?? true;
        if (interchange) {
          apiResponse.responseMessage = 'Request completed';
          apiResponse.responseBody = transform(data['message']);
        } else {
          apiResponse.responseMessage = data['message'] ?? 'Request completed';
          apiResponse.responseBody = transform(data['data']);
        }
      } else {
        apiResponse.responseSuccessful = data['success'] ?? false;
        apiResponse.responseMessage = data['message'] ?? 'Error encountered';
      }
      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");
      Logger().i("Response Body: ${apiResponse.responseBody}");
    } on DioException catch (e) {
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;

      dynamic data = e.response?.data;
      String message = data["message"] ?? 'An error occurred';

      if (data is Map<String, dynamic>) {
        // ✅ Handle normal JSON errors
        final msg = data['responseMessage'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        // ✅ Handle HTML or text responses (like 502 Bad Gateway)
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable (502 Bad Gateway)';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (_) {
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage = "An Error occurred";

      Logger().i(
        "Socket Response Successful: ${apiResponse.responseSuccessful}",
      );
      Logger().i("Socket Response Successful: ${apiResponse.responseMessage}");
    }
    return apiResponse;
  }

  Future<ApiResponse> postRequest(
    String url,
    dynamic body, {
    Options? options,
    String? accessToken,
    String? apiKey,
    bool changeContent = false,
    CancelToken? cancelToken,
  }) async {
    final ApiResponse apiResponse = ApiResponse();

    Logger().i("Request Path ${dotenv.env["BASE_URL"]}$url");
    Logger().i("Request body $body");

    try {
      // Set headers locally for this request
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': changeContent
            ? 'application/x-www-form-urlencoded'
            : 'application/json',
      };

      final requestOptions =
          options?.copyWith(headers: headers) ?? Options(headers: headers);

      Logger().i("Authorization: $accessToken");

      final res = await dio.post(
        "${dotenv.env["BASE_URL"]}$url",
        data: body,
        options: requestOptions,
        cancelToken: cancelToken,
      );

      final dynamic data = res.data;
      final dynamic reqData = res.requestOptions.data;

      log("Responsesss body ${res.requestOptions.data}");

      if (reqData is Map) {
        log("Request Body is a Map with ${reqData.length} fields");

        reqData.forEach((key, value) {
          log("Field: $key | Value: $value | Type: ${value.runtimeType}");
        });
      } else {
        log("Request Body is NOT a Map. Type: ${reqData.runtimeType}");
      }

      Logger().i("Response body $data");

      if (res.statusCode == 200 || res.statusCode == 201) {
        //Call the update Cookie function
        updateCookie(res.headers);

        apiResponse.responseSuccessful = data['success'] ?? true;
        apiResponse.responseMessage = data['message'] ?? 'Request completed';
        apiResponse.responseBody = data['data'] ?? 'No Body';
      } else {
        apiResponse.responseSuccessful = data['success'] ?? false;
        apiResponse.responseMessage = data['message'] ?? 'Error encountered';
        apiResponse.responseBody = data['data'] ?? 'No Body';
      }
      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");
      Logger().i("Response Body: ${apiResponse.responseBody}");
    } on DioException catch (e) {
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;

      dynamic data = e.response?.data;
      String message = data["message"] ?? 'An error occurred';

      if (data is Map<String, dynamic>) {
        // ✅ Handle normal JSON errors
        final msg = data['responseMessage'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        // ✅ Handle HTML or text responses (like 502 Bad Gateway)
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable (502 Bad Gateway)';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (_) {
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage = "An Error occurred";

      Logger().i(
        "Socket Response Successful: ${apiResponse.responseSuccessful}",
      );
      Logger().i("Socket Response Successful: ${apiResponse.responseMessage}");
    }
    return apiResponse;
  }

  Future<ApiResponse<T>> getRequestHandler<T>(
    String url, {
    T Function(dynamic)? transform,
    Options? options,
    String? accessToken,
    String? apiKey,
    CancelToken? cancelToken,
  }) async {
    transform ??= (dynamic r) => r as T;
    final ApiResponse<T> apiResponse = ApiResponse<T>();

    Logger().i("Request Path ${dotenv.env["BASE_URL"]}$url");

    try {
      // Set headers locally for this request
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
      };

      final requestOptions =
          options?.copyWith(headers: headers) ?? Options(headers: headers);

      Logger().i("Authorization: $accessToken");

      final res = await dio.get(
        "${dotenv.env["BASE_URL"]}$url",
        options: requestOptions,
        cancelToken: cancelToken,
      );

      final dynamic data = res.data;

      Logger().i("Response $data");
      Logger().i("Response Status Code: ${res.statusCode}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        //Call the update Cookie function
        updateCookie(res.headers);

        apiResponse.responseSuccessful = data['success'] ?? true;
        apiResponse.responseMessage =
            data['responseMessage'] ?? 'Request completed';
        apiResponse.responseBody = transform(data['responseBody']);
      } else {
        apiResponse.responseSuccessful = data['success'] ?? false;
        apiResponse.responseMessage =
            data['responseMessage'] ?? 'Error encountered';
      }

      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");
      Logger().i("Response Body: ${apiResponse.responseBody}");
    } on DioException catch (e) {
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;

      dynamic data = e.response?.data;
      String message = 'An error occurred';

      if (data is Map<String, dynamic>) {
        // ✅ Handle normal JSON errors
        final msg = data['responseMessage'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        // ✅ Handle HTML or text responses (like 502 Bad Gateway)
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable (502 Bad Gateway)';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (_) {
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage = "An Error occurred";

      Logger().i(
        "Socket Response Successful: ${apiResponse.responseSuccessful}",
      );
      Logger().i("Socket Response Successful: ${apiResponse.responseMessage}");
    }
    return apiResponse;
  }

  Future<ApiResponse> patchRequest(
    String url,
    dynamic body, {
    Options? options,
    String? accessToken,
    String? apiKey,
    CancelToken? cancelToken,
  }) async {
    final ApiResponse apiResponse = ApiResponse();

    Logger().i("Request Path ${dotenv.env["BASE_URL"]}$url");
    Logger().i("Request body $body");

    try {
      // Set headers locally for this request
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
      };

      final requestOptions =
          options?.copyWith(headers: headers) ?? Options(headers: headers);

      Logger().i("Authorization: $accessToken");

      final res = await dio.patch(
        "${dotenv.env["BASE_URL"]}$url",
        data: body,
        options: requestOptions,
        cancelToken: cancelToken,
      );

      final dynamic data = res.data;

      Logger().i("Response body $data");

      if (res.statusCode == 200 || res.statusCode == 201) {
        //Call the update Token function
        updateCookie(res.headers);

        apiResponse.responseSuccessful = data['success'] ?? true;
        apiResponse.responseMessage =
            data['responseMessage'] ?? 'Request completed';
      } else {
        apiResponse.responseSuccessful = data['success'] ?? false;
        apiResponse.responseMessage =
            (data['responseMessage'] ?? 'Error encountered');
      }
      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");
      Logger().i("Response Body: ${apiResponse.responseBody}");
    } on DioException catch (e) {
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;

      dynamic data = e.response?.data;
      String message = 'An error occurred';

      if (data is Map<String, dynamic>) {
        // ✅ Handle normal JSON errors
        final msg = data['responseMessage'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        // ✅ Handle HTML or text responses (like 502 Bad Gateway)
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable (502 Bad Gateway)';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (_) {
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage = "An Error occurred";

      Logger().i(
        "Socket Response Successful: ${apiResponse.responseSuccessful}",
      );
      Logger().i("Socket Response Successful: ${apiResponse.responseMessage}");
    }
    return apiResponse;
  }

  Future<ApiResponse> putRequest(
    String url,
    dynamic body, {
    Options? options,
    String? accessToken,
    String? apiKey,
    CancelToken? cancelToken,
  }) async {
    final ApiResponse apiResponse = ApiResponse();

    Logger().i("Request Path ${dotenv.env["BASE_URL"]}$url");
    Logger().i("Request body $body");

    try {
      // Set headers locally for this request
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
      };

      final requestOptions =
          options?.copyWith(headers: headers) ?? Options(headers: headers);

      Logger().i("Authorization: $accessToken");

      final res = await dio.put(
        "${dotenv.env["BASE_URL"]}$url",
        data: body,
        options: requestOptions,
        cancelToken: cancelToken,
      );

      final dynamic data = res.data;

      Logger().i("Response body $data");

      if (res.statusCode == 200 || res.statusCode == 201) {
        //Call the update Token function
        updateCookie(res.headers);

        apiResponse.responseSuccessful = data['success'] ?? true;
        apiResponse.responseMessage =
            data['responseMessage'] ?? 'Request completed';
      } else {
        apiResponse.responseSuccessful = data['success'] ?? false;
        apiResponse.responseMessage =
            (data['responseMessage'] ?? 'Error encountered');
      }
      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");
      Logger().i("Response Body: ${apiResponse.responseBody}");
    } on DioException catch (e) {
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;

      dynamic data = e.response?.data;
      String message = 'An error occurred';

      if (data is Map<String, dynamic>) {
        // ✅ Handle normal JSON errors
        final msg = data['responseMessage'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        // ✅ Handle HTML or text responses (like 502 Bad Gateway)
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable (502 Bad Gateway)';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (_) {
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage = "An Error occurred";

      Logger().i(
        "Socket Response Successful: ${apiResponse.responseSuccessful}",
      );
      Logger().i("Socket Response Successful: ${apiResponse.responseMessage}");
    }
    return apiResponse;
  }

  Future<ApiResponse<T>> putRequestHandler<T>(
    String url,
    dynamic body, {
    T Function(dynamic)? transform,
    Options? options,
    String? accessToken,
    String? apiKey,
    CancelToken? cancelToken,
  }) async {
    transform ??= (dynamic r) => r as T;
    final ApiResponse<T> apiResponse = ApiResponse<T>();

    Logger().i("Request Path ${dotenv.env["BASE_URL"]}$url");
    Logger().i("Request body $body");

    try {
      // Set headers locally for this request
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
      };

      final requestOptions =
          options?.copyWith(headers: headers) ?? Options(headers: headers);

      Logger().i("Authorization: $accessToken");

      final res = await dio.put(
        "${dotenv.env["BASE_URL"]}$url",
        data: body,
        options: requestOptions,
        cancelToken: cancelToken,
      );

      final dynamic data = res.data;

      Logger().i("Response body $data");
      Logger().i("Response Status Code: ${res.statusCode}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        //Call the update Token function
        updateCookie(res.headers);

        apiResponse.responseSuccessful = data['success'] ?? true;
        apiResponse.responseMessage =
            data['responseMessage'] ?? 'Request completed';
        apiResponse.responseBody = transform(data['responseBody']);
      } else {
        apiResponse.responseSuccessful = data['success'] ?? false;
        apiResponse.responseMessage =
            (data['responseMessage'] ?? 'Error encountered');
      }
      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");
      Logger().i("Response Body: ${apiResponse.responseBody}");
    } on DioException catch (e) {
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;

      dynamic data = e.response?.data;
      String message = 'An error occurred';

      if (data is Map<String, dynamic>) {
        // ✅ Handle normal JSON errors
        final msg = data['responseMessage'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        // ✅ Handle HTML or text responses (like 502 Bad Gateway)
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable (502 Bad Gateway)';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (_) {
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage = "An Error occurred";

      Logger().i(
        "Socket Response Successful: ${apiResponse.responseSuccessful}",
      );
      Logger().i("Socket Response Successful: ${apiResponse.responseMessage}");
    }
    return apiResponse;
  }

  Future<ApiResponse> deleteRequest(
    String url,
    dynamic body, {
    Options? options,
    String? accessToken,
    String? apiKey,
    CancelToken? cancelToken,
  }) async {
    final ApiResponse apiResponse = ApiResponse();

    Logger().i("Request Path ${dotenv.env["BASE_URL"]}$url");
    Logger().i("Request body $body");

    try {
      // Set headers locally for this request
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
      };

      final requestOptions =
          options?.copyWith(headers: headers) ?? Options(headers: headers);

      Logger().i("Authorization: $accessToken");

      final res = await dio.delete(
        "${dotenv.env["BASE_URL"]}$url",
        data: body,
        options: requestOptions,
        cancelToken: cancelToken,
      );

      final dynamic data = res.data;

      Logger().i("Response body $data");

      if (res.statusCode == 200 || res.statusCode == 201) {
        //Call the update Token function
        updateCookie(res.headers);

        apiResponse.responseSuccessful = data['success'] ?? true;
        apiResponse.responseMessage =
            data['responseMessage'] ?? 'Request completed';
      } else {
        apiResponse.responseSuccessful = data['success'] ?? false;
        apiResponse.responseMessage =
            (data['responseMessage'] ?? 'Error encountered');
      }
      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");
      Logger().i("Response Body: ${apiResponse.responseBody}");
    } on DioException catch (e) {
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;

      dynamic data = e.response?.data;
      String message = 'An error occurred';

      if (data is Map<String, dynamic>) {
        // ✅ Handle normal JSON errors
        final msg = data['responseMessage'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        // ✅ Handle HTML or text responses (like 502 Bad Gateway)
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable (502 Bad Gateway)';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (_) {
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage = "An Error occurred";

      Logger().i(
        "Socket Response Successful: ${apiResponse.responseSuccessful}",
      );
      Logger().i("Socket Response Successful: ${apiResponse.responseMessage}");
    }
    return apiResponse;
  }
}
