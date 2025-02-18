import 'dart:async';

import 'package:borgo/feature/data/datasources/db_service.dart';
import 'package:borgo/feature/presentation/pages/home_page/home_page.dart';
import 'package:get/get.dart';

import 'base_controller.dart';

class SplashController extends BaseController {
  @override
  void onInit() async {
    super.onInit();

    await initTimer(1);
  }

  initTimer(int second) async {
    Timer(Duration(seconds: second), () {
      _callNextPage();
    });
  }

  _callNextPage() async {
    if (DBService.to.getDataToken() != null) {
      if (await DBService.to.isTokenExpired()) {
        final refreshToken = DBService.to.getRefreshToken();
        final accessToken = await userRepo.getRefresh(refreshToken);

        accessToken.fold((error) {
          Get.offAll(() => HomePage());
        }, (access) {
          Get.offAll(() => HomePage(),
              arguments: {'access': access, 'refresh': refreshToken});
        });
      } else {
        Get.offAll(() => HomePage());
      }
    } else {
      Get.offAll(() => HomePage());
    }
  }
}
