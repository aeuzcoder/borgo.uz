import 'dart:convert';
import 'package:borgo/feature/data/datasources/db_service.dart';
import 'package:borgo/feature/presentation/controllers/base_controller.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class HomeController extends BaseController {
  bool isFirstOpen = true;
  late bool loginData;
  String? access, refres;

  final List<String> externalSchemes = [
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

  final List<String> externalDomains = [
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
    loginData = (await DBService.to.getLogin()) == '1';

    access = arguments?['access'];
    refres = arguments?['refresh'];

    if (refres != null) DBService.to.setRefreshToken(refres!);
    if (access != null && refres != null) change2(true);

    changeLoading(false);
  }

  Future<String?> getRefreshToken(Map<String, dynamic> data) async {
    final authToken = jsonDecode(data['AuthTokenBorgoUser'] ?? '{}');
    final refreshToken = authToken['refresh']?.toString();

    if (refreshToken?.isNotEmpty == true) {
      await DBService.to.setRefreshToken(refreshToken!);
      return refreshToken;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getLocalStorage(
      InAppWebViewController controller) async {
    final localStorageData = await controller.evaluateJavascript(
        source: "JSON.stringify(localStorage)");
    final result = jsonDecode(localStorageData ?? '{}');
    return result.containsKey('AuthTokenBorgoUser') ? result : null;
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
    access = refres = null;
    update();
  }

  void change2(bool state) {
    isLoading2 = state;
    update();
  }
}
