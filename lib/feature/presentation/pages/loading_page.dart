import 'package:borgo/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key, this.isLogin = true});
  final bool isLogin;

  @override
  State<LoadingPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);

    _shineAnimation =
        Tween<double>(begin: -1.0, end: 2.0).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.bgColor,
          body: Center(
            child: ClipRRect(
              // Обрезаем границы
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _shineAnimation,
                    builder: (context, child) {
                      return ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [
                              _shineAnimation.value - 0.3,
                              _shineAnimation.value,
                              _shineAnimation.value + 0.3
                            ],
                            colors: [
                              Colors.transparent,
                              // ignore: deprecated_member_use
                              Colors.white.withOpacity(0.4),
                              Colors.transparent,
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcATop, // Улучшает смешивание
                        child: Image.asset(
                          'assets/logo.png',
                          color: AppColors.btnColor,
                          width: 180,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
