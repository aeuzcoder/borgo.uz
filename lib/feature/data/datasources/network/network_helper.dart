import 'dart:async';
import 'dart:convert';

import 'package:borgo/core/services/log_service.dart';
import 'package:borgo/feature/data/datasources/db_service.dart';
import 'package:http_interceptor/http_interceptor.dart';

class HttpInterceptor implements InterceptorContract {
  @override
  FutureOr<BaseRequest> interceptRequest({required BaseRequest request}) {
    try {
      // Проверяем URL для авторизации
      if (request.url.path.contains('/token')) {
        // Устанавливаем заголовок для авторизации
        request.headers.clear();
        request.headers['Content-Type'] = 'application/x-www-form-urlencoded';
      } else {
        // Общие заголовки для остальных запросов
        var accessToken = DBService.to.getAccessToken();
        request.headers.clear();
        request.headers['Content-Type'] = 'application/json; charset=UTF-8';
        if (accessToken.isNotEmpty) {
          request.headers['Authorization'] = 'Bearer $accessToken';
        }
      }

      // Логируем URL
    } catch (e) {
      LogService.e('Error in interceptRequest: ${e.toString()}');
    }
    return request;
  }

  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response is Response) {
        LogService.i('Response Body: ${jsonDecode(response.body).toString()}');
      }
    } else {
      LogService.e('Response Status Code: ${response.statusCode}');
      if (response is Response) {
        LogService.i(
            'Error Response Body: ${jsonDecode(response.body).toString()}');
      } else {
        LogService.e('Error Response: ${response.toString()}');
      }
    }
    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest() {
    return true;
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    return true;
  }
}
