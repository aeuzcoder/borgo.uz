import 'dart:async';
import 'dart:developer';

import 'package:borgo/feature/data/datasources/db_service.dart';
import 'package:borgo/feature/presentation/pages/home_page/home_page.dart';
import 'package:borgo/feature/presentation/pages/login_page/login_page.dart';
import 'package:get/get.dart';

import 'base_controller.dart';

class SplashController extends BaseController {
  initTimer() {
    Timer(const Duration(seconds: 2), () {
      _callNextPage();
    });
  }

  _callNextPage() async {
    if (DBService.to.getAccessToken().isNotEmpty) {
      Get.off(() => const HomePage());
    } else {
      final userData = await userRepo.getUser();
      userData.fold((error) {
        log(error);
        Get.off(() => const LoginPage());
      }, (userMap) async {
        final result =
            await userRepo.signIn(phone: userMap['l'], password: userMap['p']);
        result.fold((error) {
          log(error);
        }, (success) {
          Get.off(() => const HomePage());
        });
      });
    }
  }
}
