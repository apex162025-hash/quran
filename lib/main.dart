import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_library/quran_library.dart';
import 'home_page.dart';
import 'localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await QuranLibrary.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final savedLangCode = box.read('lang_code') ?? 'en';
    final savedCountryCode = box.read('country_code') ?? 'US';

    return GetMaterialApp(
      theme: ThemeData(useMaterial3: false),
      debugShowCheckedModeBanner: false,
      title: 'GetX Localization Demo',
      translations: MyTranslations(),
      locale: Locale(savedLangCode, savedCountryCode),
      fallbackLocale: const Locale('en', 'US'),
      home: const MyHomePage(),
    );
  }
}
