import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DBService {
  final GetStorage _box = GetStorage();

  static DBService get to => Get.find<DBService>();

  static Future<void> init() async {
    await Get.putAsync<DBService>(() async {
      final storageService = DBService();
      await GetStorage.init();
      return storageService;
    }, permanent: true);
  }

  Future<void> logOut() async {
    await _box.erase();
    await Get.deleteAll();
  }

  /// Refresh Token
  Future<void> setRefreshToken(String? value) async {
    await _box.write(_StorageKeys.refreshToken, value ?? '');
    final now = DateTime.now().toIso8601String();
    debugPrint('REFRESH TOKEN YOZILDI');
    await _box.write(_StorageKeys.tokenData, now);
  }

  Future<String> getLogin() async {
    if (!_box.hasData(_StorageKeys.login)) {
      await _box.write(_StorageKeys.login, '0');
    }
    return await _box.read(_StorageKeys.login);
  }

  Future<void> changeLogin(bool status) async {
    if (_box.hasData(_StorageKeys.login)) {
      _box.remove(_StorageKeys.login);
    }
    if (!status) {
      await delRefreshToken();
    }
    debugPrint('LOGIN XOLATI: ${status == true ? '1' : '0'}');
    _box.write(_StorageKeys.login, status == true ? '1' : '0');
  }

  String? getDataToken() {
    if (_box.hasData(_StorageKeys.tokenData)) {
      return _box.read(_StorageKeys.tokenData);
    } else {
      return null;
    }
  }

  Future<bool> isTokenExpired() async {
    final savedDate = _box.read(_StorageKeys.tokenData);
    if (savedDate == null) {
      return false;
    }

    // Преобразуем строку в дату
    final saveDateTime = DateTime.parse(savedDate);
    final now = DateTime.now();

    // Проверяем, прошло ли 48 часов (2 дня)
    final difference = now.difference(saveDateTime).inSeconds;
    debugPrint('TOKEN BAZADA: ${difference >= 1}');
    return difference >= 1;
  }

  String getRefreshToken() {
    debugPrint('REFRESH TOKEN OLINDI');
    return _box.read(_StorageKeys.refreshToken) ?? "";
  }

  Future<void> delRefreshToken() async {
    debugPrint('REFRESH TOKEN OCHIRILDI');
    await _box.remove(_StorageKeys.refreshToken);
  }
}

class _StorageKeys {
  static const tokenData = 'token_data';
  static const refreshToken = 'refresh_token';
  static const login = 'login';
}
