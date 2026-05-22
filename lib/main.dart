import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_library/quran_library.dart';
import 'package:test_project/screens/map_screen.dart';
import 'core/theme/app_theme.dart';
import 'localization.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  try {
    await QuranLibrary.init();
  } catch (e) {
    debugPrint('Failed to initialize QuranLibrary: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final savedLangCode = box.read('lang_code') ?? 'ar';
    final savedCountryCode = box.read('country_code') ?? 'SA';

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          title: 'Quran App',
          translations: MyTranslations(),
          locale: Locale(savedLangCode, savedCountryCode),
          fallbackLocale: const Locale('ar', 'SA'),
          home: MapScreen(),
        );
      },
    );
  }
}
