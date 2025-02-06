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
  final controller = Get.find<SplashController>();
  @override
  void initState() {
    super.initState();
    controller.initTimer();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPage();
  }
}
