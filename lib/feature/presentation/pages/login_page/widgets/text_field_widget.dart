import 'package:borgo/core/utils/app_colors.dart';
import 'package:borgo/feature/presentation/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFieldWidget extends StatefulWidget {
  final String title;
  final bool isName;
  final bool isPhone;
  final bool isEmail;
  final bool isAddress;
  final bool isPassword;
  final TextEditingController? controller;
  final GetxController controllerH;
  final bool isRegion;

  const TextFieldWidget(
      {super.key,
      required this.title,
      required this.controller,
      this.isName = false,
      this.isPhone = false,
      this.isEmail = false,
      this.isAddress = false,
      this.isPassword = false,
      this.isRegion = false,
      required this.controllerH});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  String? errorMessage;
  bool _obscureText = true; // состояние скрытия пароля

  // Универсальная функция валидации
  String? validate(String value) {
    value = value.trim();

    if (widget.isName) {
      if (value.isEmpty) return 'Ismingizni kiriting';
      if (!RegExp(r'^[a-zA-Zа-яА-Я]+$').hasMatch(value)) {
        return 'Ismingizni to\'g\'ri kiriting';
      }
    }

    if (widget.isPhone) {
      final regex = RegExp(r'^\+?[1-9]\d{7,14}$'); // Исправил маску
      if (value.isEmpty) return 'Telefon raqamingizni kiriting';
      if (!regex.hasMatch(value)) {
        return 'Telefon raqamingizni to\'g\'ri kiriting';
      }
    }

    if (widget.isEmail) {
      if (value.isEmpty) return 'Pochtangizni kiriting';
      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
        return 'Mavjud poshtangizni kiriting';
      }
    }

    if (widget.isAddress) {
      if (value.isEmpty) return 'Manzil bo\'sh bolmasligi kerak';
    }

    if (widget.isPassword) {
      if (value.isEmpty) return 'Parolingizni kiriting';
      if (value.length < 6) {
        return 'Parol kamida 6 ta harfdan iborat bo\'ladi';
      }
    }

    return null; // Нет ошибок
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          enabled: !widget.isRegion,
          onTapOutside: (tab) => FocusScope.of(context).unfocus(),
          controller: widget.controller,
          obscureText: widget.isPassword
              ? _obscureText
              : false, // Управление скрытием пароля
          scrollPhysics: const BouncingScrollPhysics(),
          decoration: InputDecoration(
            hintText: widget.title,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: widget.isRegion
                  ? AppColors.black
                  : AppColors.black.withOpacity(0.4),
            ),
            errorText: errorMessage,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.black.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.black.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.btnColor.withOpacity(0.8),
                width: 1,
              ),
            ),
            // Добавляем иконку для пароля
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText; // Меняем состояние
                      });
                    },
                    child: SizedBox(
                      child: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : null,
          ),
          maxLines: 1,
          style: TextStyle(
            letterSpacing: 0,
            height: 1,
            decorationColor: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          onChanged: (value) {
            setState(() {
              errorMessage = validate(value);
              if (widget.controllerH is LoginController) {
                if ((widget.controllerH as LoginController).indexItem == 0) {
                  (widget.controllerH as LoginController).signInCheck();
                } else {
                  (widget.controllerH as LoginController).signUpCheck();
                }

                if (errorMessage == null) {
                  (widget.controllerH as LoginController).checkerValide(true);
                } else {
                  (widget.controllerH as LoginController).checkerValide(false);
                }
              }
            });
          },
        ),
      ],
    );
  }
}
