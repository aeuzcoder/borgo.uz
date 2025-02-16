import 'package:borgo/core/network/api_constants.dart';
import 'package:borgo/feature/data/datasources/db_service.dart';
import 'package:borgo/feature/presentation/controllers/base_controller.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomeController extends BaseController {
  InAppWebViewController? controller;
  late bool isFirstOpen;
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

  final String loginUrl = Uri.https(ApiConstants.BASE_URL_SITE, '/').toString();
  bool isLoading2 = false;

  @override
  void onInit() async {
    super.onInit();
    changeLoading(true);
    change2(true);

    isFirstOpen = await DBService.to.getFirstOpen();
    if (isFirstOpen) {
      access = DBService.to.getAccessToken();
      refres = DBService.to.getRefreshToken();
    }

    changeLoading(false);
  }

  Future<void> setFirst(bool state) async {
    await DBService.to.setFirstOpen(state);
    isFirstOpen = false;
    update();
  }

  Future<void> delFirst() async {
    await DBService.to.delFirstOpen();
    update();
  }

  void change2(bool state) {
    isLoading2 = state;
    update();
  }
}
