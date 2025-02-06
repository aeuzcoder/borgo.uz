// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:borgo/core/utils/app_colors.dart';
import 'package:borgo/feature/presentation/pages/login_page/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({
    super.key,
    required this.phoneCtr,
    required this.passwordCtr,
    required this.controllerH,
  });

  final TextEditingController phoneCtr;
  final TextEditingController passwordCtr;
  final GetxController controllerH;

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  @override
  void initState() {
    super.initState();
    widget.phoneCtr.clear();
    widget.passwordCtr.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 72,
                child: TextFieldWidget(
                  isRegion: true,
                  title: '+998',
                  controller: null,
                  isPhone: true,
                  controllerH: widget.controllerH,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFieldWidget(
                  isRegion: false,
                  title: 'Telefon raqam',
                  controller: widget.phoneCtr,
                  isPhone: true,
                  controllerH: widget.controllerH,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          TextFieldWidget(
            title: 'Parol',
            controller: widget.passwordCtr,
            isPassword: true,
            controllerH: widget.controllerH,
          ),
          Text(
            'Parolni unutdingizmi?',
            style: TextStyle(
              fontSize: 16,
              height: 2,
              letterSpacing: 0.2,
              color: AppColors.btnColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
