import 'package:borgo/feature/data/datasources/db_service.dart';
import 'package:borgo/feature/presentation/controllers/base_controller.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class HomeController extends BaseController {
  InAppWebViewController? controller;
  bool isFirstOpen = true;
  late final String? access;
  late final String? refres;
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

  Future<String?> getRefreshToken(String data) async {
    int? startindex, endIndex;

    for (var i = 0; i < data.length; i++) {
      if (data[i] == 'r' && data.substring(i, i + 10).contains('refresh')) {
        startindex = i + 12;
      }
      if (data[i] == '_' && data.substring(i, i + 10).contains('_ym_cs')) {
        endIndex = i - 6;
      }
    }

    if (startindex != null && endIndex != null) {
      final refreshToken = data.substring(startindex, endIndex);

      await DBService.to.setRefreshToken(refreshToken);
      return refreshToken;
    }
    return null;
  }

  Future<String> getLocalStorage(
      InAppWebViewController webViewController) async {
    var localStorageData =
        await webViewController.evaluateJavascript(source: """
    JSON.stringify(localStorage);
  """);
    return localStorageData;
  }

  void changeFirst(bool status) {
    isFirstOpen = status;
    update();
  }

  void change2(bool state) {
    isLoading2 = state;
    update();
  }
}
