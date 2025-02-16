// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:borgo/core/errors/exception.dart';
import 'package:borgo/core/network/api_constants.dart';
import 'package:borgo/feature/data/datasources/network/network_helper.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  static final client = InterceptedClient.build(
    interceptors: [HttpInterceptor()],
  );

  static String getServer() {
    return ApiConstants.BASE_URL;
  }

  /* Http Requests */
  static Future<String?> GET(String api, Map<String, dynamic> params) async {
    try {
      var uri = Uri.https(getServer(), api, params);
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        _throwException(response);
      }
    } on SocketException catch (_) {
      rethrow;
    }
    return null;
  }

  static Future<String?> POST(String api, Map<String, dynamic> params,
      {bool isAuth = false, String? path}) async {
    try {
      var uri = Uri.https(getServer(), api);

      // Если передан файл, используем MultipartRequest
      if (path != null) {
        var request = http.MultipartRequest('POST', uri);

        // Добавляем файл в запрос
        request.files.add(
          await http.MultipartFile.fromPath(
            'file', // Название параметра для файла (зависит от API)
            path,
            filename: path.split('/').last,
          ),
        );

        // Добавляем остальные параметры
        params.forEach((key, value) {
          request.fields[key] = value.toString();
        });

        // Используем http_interceptor
        var streamedResponse = await client.send(request);
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200 || response.statusCode == 201) {
          return response.body;
        } else {
          _throwException(response);
        }
      } else {
        // Обычный POST-запрос
        String? body;
        Map<String, String> headers = {};

        if (isAuth) {
          body = params.entries
              .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
              .join('&');
          headers['Content-Type'] = 'application/x-www-form-urlencoded';
        } else {
          body = jsonEncode(params);
          headers['Content-Type'] = 'application/json';
        }

        var response = await client.post(uri, body: body, headers: headers);

        if (response.statusCode == 200 || response.statusCode == 201) {
          return response.body;
        } else {
          _throwException(response);
        }
      }
    } on SocketException catch (_) {
      rethrow;
    }
    return null;
  }

  static Future<String?> PUT(String api,
      {Map<String, dynamic> body = const {}}) async {
    try {
      var uri = Uri.https(getServer(), api);
      var response = await client.put(uri, body: jsonEncode(body));
      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.body;
      } else {
        _throwException(response);
      }
    } on SocketException catch (_) {
      rethrow;
    }
    return null;
  }

  static Future<String?> DEL(String api) async {
    try {
      var uri = Uri.https(getServer(), api);
      var response = await client.delete(uri);
      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.body;
      } else {
        _throwException(response);
      }
    } on SocketException catch (_) {
      rethrow;
    }
    return null;
  }

  static _throwException(Response response) {
    String reason = response.reasonPhrase!;
    switch (response.statusCode) {
      case 400:
        throw BadRequestException(reason);
      case 401:
        throw InvalidInputException(reason);
      case 403:
        throw UnauthorisedException(reason);
      case 404:
        throw FetchDataException(reason);
      case 500:
      default:
        throw FetchDataException(reason);
    }
  }

  /* Http Params */

  static Map<String, String> paramsEmpty() {
    Map<String, String> params = {};
    return params;
  }
}
