import 'package:borgo/feature/presentation/controllers/splash_controller.dart';
import 'package:borgo/feature/presentation/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (controller) {
        return PopScope(canPop: false, child: LoadingPage());
      },
    );
  }
}
