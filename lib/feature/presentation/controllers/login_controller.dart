import 'dart:developer';

import 'package:borgo/feature/data/datasources/db_service.dart';
import 'package:borgo/feature/domain/entities/user_entity.dart';
import 'package:borgo/feature/presentation/controllers/base_controller.dart';
import 'package:flutter/material.dart';

class LoginController extends BaseController {
  bool isValide = false;
  final surnameCtr = TextEditingController();
  final passwordCtr = TextEditingController();
  final nameCtr = TextEditingController();
  final emailCtr = TextEditingController();
  final phoneCtr = TextEditingController();
  bool canSignIn = false;
  bool canSignUp = false;

  @override
  void onInit() async {
    super.onInit();
    await deleteUser();
  }

  void signUpCheck() {
    if (passwordCtr.text.isNotEmpty &&
        nameCtr.text.isNotEmpty &&
        emailCtr.text.isNotEmpty &&
        phoneCtr.text.isNotEmpty &&
        surnameCtr.text.isNotEmpty) {
      canSignUp = true;
      update();
    } else {
      canSignUp = false;
      update();
    }
  }

  void signInCheck() {
    if (passwordCtr.text.isNotEmpty && phoneCtr.text.isNotEmpty) {
      canSignIn = true;
      update();
    } else {
      canSignIn = false;
      update();
    }
  }

  int indexItem = 0;

  void changerItem() {
    if (indexItem == 0) {
      indexItem = 1;
    } else {
      indexItem = 0;
    }
    changeError(false);
    canSignIn = false;
    canSignUp = false;
    update();
  }

  void checkerValide(bool isValidate) {
    isValide = isValidate;
    update();
  }

  Future<bool> onSignIn(
      {required String phone, required String password}) async {
    changeLoading(true);
    final res = await userRepo.signIn(phone: phone, password: password);
    return res.fold((error) {
      changeError(true, text: error);
      changeLoading(false);
      return false;
    }, (loginData) async {
      if ((loginData.accessToken).isNotEmpty &&
          (loginData.refreshToken).isNotEmpty) {
        await DBService.to.setAccessToken(loginData.accessToken);
        await DBService.to.setRefreshToken(loginData.refreshToken);
        final result = await userRepo.setUser(phone, password);
        result.fold((error) {
          log(error);
        }, (res) {
          log(res);
        });
      }
      changeError(false, text: null);
      changeLoading(false);
      return true;
    });
  }

  bool canSend() {
    if (indexItem == 0 && canSignIn && isValide) {
      return true;
    }
    if (indexItem == 1 && canSignUp && isValide) {
      return true;
    }
    return false;
  }

  Future<void> deleteUser() async {
    await DBService.to.deleteUser();
    await DBService.to.delAccessToken();
    await DBService.to.delRefreshToken();
  }

  Future<String> onSignUp({required UserEntity user}) async {
    changeLoading(true);
    final res = await userRepo.signUp(user: user);

    return res.fold((error) {
      changeLoading(false);
      return error;
    }, (message) {
      changeLoading(false);
      return message;
    });
  }

  @override
  void onClose() {
    super.onClose();
    surnameCtr.dispose();
    emailCtr.dispose();
    passwordCtr.dispose();
    phoneCtr.dispose();
    nameCtr.dispose();
  }
}
