import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test_project/screens/quran_screen.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();

    return Scaffold(
      appBar: AppBar(title: Text('hello'.tr)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('welcome'.tr, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                var current = Get.locale;
                if (current == const Locale('en', 'US')) {
                  Get.updateLocale(const Locale('ar', 'SA'));
                  box.write('lang_code', 'ar');
                  box.write('country_code', 'SA');
                } else {
                  Get.updateLocale(const Locale('en', 'US'));
                  box.write('lang_code', 'en');
                  box.write('country_code', 'US');
                }
              },
              child: Text('change_lang'.tr),
            ),

            const SizedBox(height: 20),
            const SizedBox(height: 20),
            GradientButton(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const QuranScreen());
              },
              child: const Text('Open Quran'),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  const GradientButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        // The gradient defines the background colors
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1442D3), // Start color
            Color(0xFF0A226D), // End color
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // This makes the corners rounded, creating a pill shape
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min, // Fit content size
        children: [
          Text(
            'المزيد',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.more_horiz, color: Colors.white),
        ],
      ),
    );
  }
}
