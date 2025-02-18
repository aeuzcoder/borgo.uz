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
    await _box.write(_StorageKeys.refreshToken, value);
    final now = DateTime.now().toIso8601String();
    await _box.write(_StorageKeys.tokenData, now);
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

    // Преобразуем строку в дату
    final saveDateTime = DateTime.parse(savedDate);
    final now = DateTime.now();

    // Проверяем, прошло ли 48 часов (2 дня)
    final difference = now.difference(saveDateTime).inDays;
    return difference >= 3;
  }

  String getRefreshToken() {
    return _box.read(_StorageKeys.refreshToken) ?? "";
  }

  Future<void> delRefreshToken() async {
    await _box.remove(_StorageKeys.refreshToken);
  }
}

class _StorageKeys {
  static const tokenData = 'token_data';
  static const refreshToken = 'refresh_token';
}
