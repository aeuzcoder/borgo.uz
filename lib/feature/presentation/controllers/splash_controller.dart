import 'package:borgo/feature/data/datasources/db_service.dart';
import 'package:borgo/feature/presentation/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'base_controller.dart';

class SplashController extends BaseController {
  callNextPage() async {
    if (DBService.to.getDataToken() != null) {
      if (await DBService.to.isTokenExpired()) {
        final refreshToken = DBService.to.getRefreshToken();
        final accessToken = await userRepo.getRefresh(refreshToken);

        accessToken.fold((error) {
          debugPrint('ERROR: $error');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAll(() => HomePage());
          });
        }, (access) {
          debugPrint('ACCES TOKEN OLINDI VA HOMEGA JONATILDI');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAll(() => HomePage(),
                arguments: {'access': access, 'refresh': refreshToken});
          });
        });
      } else {
        debugPrint('TOKEN MUDDATI TUGAMAGAN');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAll(() => HomePage());
        });
      }
    } else {
      debugPrint('ROYHATDAN OTMAGAN');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => HomePage());
      });
    }
  }
}
