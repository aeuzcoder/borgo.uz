import 'dart:convert';

import 'package:borgo/feature/data/datasources/db_service.dart';
import 'package:borgo/feature/presentation/controllers/base_controller.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class HomeController extends BaseController {
  InAppWebViewController? controller;
  bool isFirstOpen = true;
  late bool loginData;
  late String? access;
  late String? refres;
  List<String> externalSchemes = [
    'tel',
    'mailto',
    'tg',
    'whatsapp',
    'vk',
    'viber',
    'instagram',
    'facebook',
    'skype'
  ];
  List<String> externalDomains = [
    'vk.com',
    'twitter.com',
    'instagram.com',
    'facebook.com',
    'linkedin.com',
  ];

  final String loginUrl = Uri.https('borgo.uz', '/').toString();
  bool isLoading2 = false;

  @override
  void onInit() async {
    super.onInit();
    changeLoading(true);

    final arguments = await Get.arguments;
    final resultLogin = await DBService.to.getLogin();
    if (resultLogin == '1') {
      loginData = true;
    } else {
      loginData = false;
    }
    if (arguments != null) {
      access = arguments['access'];
      refres = arguments['refresh'];
      DBService.to.setRefreshToken(refres);
    } else {
      access = null;
      refres = null;
    }

    if (access != null && refres != null) {
      change2(true);
    }

    changeLoading(false);
  }

  Future<String?> getRefreshToken(Map<String, dynamic> data) async {
    if (data.containsKey('AuthTokenBorgoUser')) {
      final authToken = jsonDecode(data['AuthTokenBorgoUser'] ?? '');

      if (authToken.containsKey('refresh') &&
          authToken['refresh'].toString().isNotEmpty) {
        final refreshToken = authToken['refresh'];
        await DBService.to.setRefreshToken(refreshToken);
        return authToken['refresh'];
      }
    }

    return null;
  }

  Future<Map<String, dynamic>?> getLocalStorage(
      InAppWebViewController webViewController) async {
    var localStorageData =
        await webViewController.evaluateJavascript(source: """
    JSON.stringify(localStorage);
  """);
    Map<String, dynamic> result =
        await jsonDecode(localStorageData ?? '') ?? {};
    if (!result.containsKey('AuthTokenBorgoUser')) {
      return null;
    }

    return jsonDecode(localStorageData ?? '') ?? {};
  }

  void changeFirst(bool status) {
    isFirstOpen = status;

    update();
  }

  Future<void> changeLogin(bool status) async {
    await DBService.to.changeLogin(status);
    loginData = status;
    update();
  }

  void changeTokens() {
    access = null;
    refres = null;
    update();
  }

  void change2(bool state) {
    isLoading2 = state;
    update();
  }
}
