import 'package:borgo/core/config/root_binding.dart';
import 'package:borgo/core/services/root_service.dart';
import 'package:borgo/core/utils/app_colors.dart';
import 'package:borgo/feature/presentation/pages/home_page/home_page.dart';
import 'package:borgo/feature/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  //DB
  await RootService.init();

  //For system colors
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.bgColor, // Устанавливаем нужный цвет
      statusBarIconBrightness: Brightness.dark, // Белые иконки
      statusBarBrightness: Brightness.dark, // Для iOS

      systemNavigationBarColor: AppColors.bgColor, // Цвет нижней панели
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      enableLog: true,
      debugShowMaterialGrid: false,
      theme: ThemeData(fontFamily: 'Poppins', useMaterial3: true),
      title: 'Borgo.uz',
      debugShowCheckedModeBanner: false,
      initialBinding: RootBinding(),
      defaultTransition: Transition.native,
      transitionDuration: const Duration(milliseconds: 100),
      getPages: [
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/splash', page: () => SplashPage()),
      ],
      initialRoute: '/splash',
    );
  }
}
