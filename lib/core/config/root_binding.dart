import 'package:borgo/feature/presentation/controllers/base_controller.dart';
import 'package:borgo/feature/presentation/controllers/home_controller.dart';
import 'package:borgo/feature/presentation/controllers/splash_controller.dart';
import 'package:get/get.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    // Controllers
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<BaseController>(() => BaseController(), fenix: true);
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
  }
}
