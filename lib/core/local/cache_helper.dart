import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/enums.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;
  static late FlutterSecureStorage _secureStorage;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage();
  }

  static Future<void> clearCache({required String key}) async {
    await sharedPreferences.remove(key);
    await _secureStorage.delete(key: key);
  }

  static Future<void> clearAll() async {
    //  Save language settings before clearing
    final savedLangCode = sharedPreferences.getString('langCode');
    final savedCountryCode = sharedPreferences.getString('countryCode');

    await sharedPreferences.clear();
    await _secureStorage.deleteAll();

    //  Restore language settings after clearing
    if (savedLangCode != null) {
      await sharedPreferences.setString('langCode', savedLangCode);
    }
    if (savedCountryCode != null) {
      await sharedPreferences.setString('countryCode', savedCountryCode);
    }
  }

  // ====================== SECURE DATA STORAGE (Encrypted) ======================

  static Future<void> assignSecureData({
    required String key,
    required String value,
  }) async {
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String?> safeRead({required String key}) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e, stacktrace) {
      debugPrint("Secure storage read error for key [$key]: $e");
      debugPrintStack(stackTrace: stacktrace);
      await _secureStorage.delete(key: key);
      return null;
    }
  }

  // ====================== STANDARD STORAGE (For Non-Sensitive Data) ======================

  static Future<bool> assignData({
    required String key,
    required String value,
  }) async {
    return await sharedPreferences.setString(key, value);
  }

  static Future<bool> assignIntegerData({
    required String key,
    required int value,
  }) async {
    return await sharedPreferences.setInt(key, value);
  }

  static Future<bool> assignBoolData({
    required String key,
    required bool value,
  }) async {
    return await sharedPreferences.setBool(key, value);
  }

  static dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  static String get currency {
    return CacheHelper.getData(key: CacheKeys.currency.name) ?? "ر.ع";
  }

  static bool get isLoggedIn {
    return sharedPreferences.getBool(CacheKeys.loggedIn.name) ?? false;
  }
}
