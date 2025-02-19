import 'package:borgo/feature/presentation/controllers/splash_controller.dart';
import 'package:borgo/feature/presentation/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Get.find<SplashController>().callNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (controller) {
        return PopScope(canPop: false, child: LoadingPage());
      },
    );
  }
}
