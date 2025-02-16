import 'dart:async';

import 'package:borgo/feature/data/datasources/db_service.dart';
import 'package:borgo/feature/presentation/pages/home_page/home_page.dart';
import 'package:borgo/feature/presentation/pages/login_page/login_page.dart';
import 'package:get/get.dart';

import 'base_controller.dart';

class SplashController extends BaseController {
  @override
  void onInit() async {
    super.onInit();
    final first = await DBService.to.getFirstOpen();
    if (first) {
      await initTimer(2);
    } else {
      await initTimer(0);
    }
  }

  initTimer(int second) async {
    Timer(Duration(seconds: second), () {
      _callNextPage();
    });
  }

  _callNextPage() async {
    if (DBService.to.getAccessToken().isNotEmpty) {
      Get.off(() => const HomePage());
    } else {
      final userData = await userRepo.getUser();
      userData.fold((error) {
        Get.off(() => const LoginPage());
      }, (userMap) async {
        final result =
            await userRepo.signIn(phone: userMap['l'], password: userMap['p']);
        result.fold((error) {}, (success) {
          Get.off(() => const HomePage());
        });
      });
    }
  }
}
