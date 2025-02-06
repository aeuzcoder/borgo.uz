import 'dart:developer';

import 'package:borgo/core/utils/app_colors.dart';
import 'package:borgo/feature/domain/entities/user_entity.dart';
import 'package:borgo/feature/presentation/controllers/login_controller.dart';
import 'package:borgo/feature/presentation/pages/home_page/home_page.dart';
import 'package:borgo/feature/presentation/pages/login_page/widgets/sign_in_widget.dart';
import 'package:borgo/feature/presentation/pages/login_page/widgets/sign_up_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.exit = false});
  final bool exit;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) {
        return Container(
          color: AppColors.bgColor,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.bgColor,
              body: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 12.0,
                      left: 12.0,
                      bottom: 56,
                      top: controller.indexItem == 0
                          ? MediaQuery.of(context).size.height / 5
                          : 24,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.widgetColor,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.grey,
                              blurRadius: 4,
                            )
                          ],
                          borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //BORGO UZ
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'BORGO.UZ ga xush kelibsiz!',
                                    style: TextStyle(
                                      height: 1.5,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                  Text(
                                    controller.indexItem == 1
                                        ? 'Ro\'yhatdan o\'tish'
                                        : 'Hisobingizga kiring',
                                    style: TextStyle(
                                      height: 1.2,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            // TEXT FIELDS
                            controller.indexItem == 0
                                ? SignInWidget(
                                    phoneCtr: controller.phoneCtr,
                                    passwordCtr: controller.passwordCtr,
                                    controllerH: controller,
                                  )
                                : SignUpWidget(
                                    phoneCtr: controller.phoneCtr,
                                    nameCtr: controller.nameCtr,
                                    passwordCtr: controller.passwordCtr,
                                    emailCtr: controller.emailCtr,
                                    addressCtr: controller.surnameCtr,
                                    controllerH: controller,
                                  ),

                            SizedBox(
                                height: controller.errorText != null ? 10 : 20),
                            controller.errorText != null
                                ? Center(
                                    child: Text(
                                      controller.errorText!,
                                      style: TextStyle(
                                        height: 2,
                                        color: AppColors.red,
                                        letterSpacing: 0,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : SizedBox(),

                            // BUTTON
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: GestureDetector(
                                onTap: () async {
                                  if (controller.indexItem == 0 &&
                                      controller.canSignIn &&
                                      controller.isValide) {
                                    var isAuth = await controller.onSignIn(
                                      phone: controller.phoneCtr.text,
                                      password: controller.passwordCtr.text,
                                    );

                                    if (isAuth) {
                                      await controller.userRepo.setUser(
                                          controller.phoneCtr.text,
                                          controller.passwordCtr.text);
                                      Get.offAll(() => HomePage());
                                    }
                                  } else if (controller.indexItem == 1 &&
                                      controller.canSignUp &&
                                      controller.isValide) {
                                    log(controller.phoneCtr.text);
                                    final UserEntity user = UserEntity(
                                      name: controller.nameCtr.text,
                                      phoneNumber: controller.phoneCtr.text,
                                      password: controller.passwordCtr.text,
                                      email: controller.emailCtr.text,
                                      surname: controller.surnameCtr.text,
                                    );
                                    var isSignUp =
                                        await controller.onSignUp(user: user);

                                    Get.snackbar('Xolat', isSignUp);
                                    controller.changerItem();
                                  }
                                },
                                child: Container(
                                  height: 46,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: controller.canSend()
                                        ? AppColors.btnColor
                                        : Colors.grey,
                                  ),
                                  child: Center(
                                    child: controller.isLoading
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            controller.indexItem == 0
                                                ? 'Kirish'
                                                : 'Ro\'yhatdan o\'tish',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: AppColors.grey,
                                      height: 2,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      'Yoki',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        letterSpacing: 0,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: AppColors.grey,
                                      height: 2,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    controller.indexItem == 0
                                        ? 'Siznig hisobingiz yo\'qmi'
                                        : 'Hisobingiz bormi?',
                                    style: TextStyle(
                                      color: AppColors.black,
                                      letterSpacing: 0,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => controller.changerItem(),
                                    child: Container(
                                      color: AppColors.white,
                                      child: Text(
                                        controller.indexItem == 0
                                            ? 'Ro\'yhatdan o\'tish'
                                            : 'Hisobga kirish',
                                        style: TextStyle(
                                          height: 1,
                                          color: AppColors.btnColor,
                                          letterSpacing: 0,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
