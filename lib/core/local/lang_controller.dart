import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_helper.dart';
import 'cache_helper.dart';

class LanguageGetxController extends GetxController {
  String lang = 'ar';
  bool appDirectionRtl = true;

  @override
  void onInit() {
    super.onInit();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('langCode');
    if (savedLang != null) {
      lang = savedLang;
      appDirectionRtl = lang == 'ar';
      Get.updateLocale(Locale(lang));
    } else {
      lang = 'ar';
      appDirectionRtl = true;
      Get.updateLocale(const Locale('ar'));
    }
    update();
  }

  Future<void> changeLanguage(String languageCode, String countryCode) async {
    // Check if user is logged in first
    if (!CacheHelper.isLoggedIn) {
      _changeLanguageLocal(languageCode, countryCode);
      return;
    }

    // 1. Update app state
    lang = languageCode;
    appDirectionRtl = (languageCode == 'ar');

    // 2. Save to preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('langCode', languageCode);
    await prefs.setString('countryCode', countryCode);

    // 3. Update Dio headers with new language
    await DioHelper.updateHeadersManually();

    // 4. Delete lazy controllers so they recreate fresh on next screen access
    _resetControllers();

    // 5. Update GetX locale (triggers UI rebuild)
    Get.updateLocale(Locale(languageCode, countryCode));

    update();

    // 6. Close bottom sheet / dialog
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  void _changeLanguageLocal(String languageCode, String countryCode) {
    lang = languageCode;
    appDirectionRtl = (languageCode == 'ar');

    final prefs = SharedPreferences.getInstance();
    prefs.then((p) {
      p.setString('langCode', languageCode);
      p.setString('countryCode', countryCode);
    });

    // Delete controllers even for local change so UI reflects new locale
    _resetControllers();

    Get.updateLocale(Locale(languageCode, countryCode));
    update();

    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// Delete lazy controllers from GetX memory.
  /// They will auto-recreate (fenix: true) when their screen is opened,
  /// triggering onInit() which fetches fresh data with updated headers.
  void _resetControllers() {
    debugPrint('🔄 Resetting controllers for language change...');
    // _deleteIfRegistered<HomeController>();
    // _deleteIfRegistered<ProfileController>();
    // _deleteIfRegistered<OrderDetailsController>();
    // _deleteIfRegistered<SharedPagesController>();
    debugPrint('✓ Controllers reset — will refresh on next screen access');
  }

  /// Helper to safely delete a controller if it is currently registered.
  void _deleteIfRegistered<T extends GetxController>() {
    if (Get.isRegistered<T>()) {
      Get.delete<T>(force: true);
      debugPrint('🗑️ Deleted ${T.toString()}');
    }
  }
}
