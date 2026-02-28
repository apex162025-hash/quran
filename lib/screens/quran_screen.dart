import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_library/quran_library.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/quran_styles.dart';
import 'widgets/modern_quran_appbar.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final _storage = GetStorage();
  RxList<int> ayahBookmarked = <int>[].obs;

  @override
  void initState() {
    super.initState();
    // Load bookmarks
    if (_storage.hasData('bookmarks')) {
      ayahBookmarked.value = List<int>.from(_storage.read('bookmarks'));
    }
  }

  void _toggleBookmark(int ayahId) {
    if (ayahBookmarked.contains(ayahId)) {
      ayahBookmarked.remove(ayahId);
    } else {
      ayahBookmarked.add(ayahId);
    }
    _storage.write('bookmarks', ayahBookmarked.toList());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => QuranLibraryScreen(
            parentContext: context,
            withPageView: true,
            useDefaultAppBar: true, // Changed to false to prevent overflow
            appBar: ModernQuranAppBar(isDark: isDark), // Using custom AppBar
            isShowAudioSlider: true,
            showAyahBookmarkedIcon: true,
            isDark: isDark,
            // Styling from QuranStyles
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surahNameStyle: QuranStyles.surahNameStyle(isDark),
            surahInfoStyle: QuranStyles.surahInfoStyle(isDark),
            basmalaStyle: QuranStyles.basmalaStyle(isDark),
            bannerStyle: QuranStyles.bannerStyle(isDark),
            topBarStyle: QuranStyles.topBarStyle(isDark),
            downloadFontsDialogStyle: QuranStyles.downloadFontsDialogStyle(
              isDark,
            ),

            // Colors
            ayahIconColor: AppTheme.secondaryLight,
            ayahSelectedBackgroundColor: AppTheme.primaryLight.withOpacity(0.3),
            ayahSelectedFontColor: isDark ? Colors.white : Colors.black,
            textColor: isDark ? Colors.white : Colors.black,


            juzName: 'Juz'.tr,
            sajdaName: 'Sajda'.tr,
            languageCode: Get.locale?.languageCode ?? 'ar',

            // Bookmarks
            ayahBookmarked: ayahBookmarked.toList(),
            onAyahLongPress: (details, ayah) {
              final dynamicAyah = ayah as dynamic;
              int uniqueId = 0;
              try {
                uniqueId = dynamicAyah.ayahUniqueId;
              } catch (e) {
                debugPrint('Error accessing ayahUniqueId: $e');
                return;
              }

              _toggleBookmark(uniqueId);
              Get.snackbar(
                'Bookmark',
                ayahBookmarked.contains(uniqueId)
                    ? 'Added to bookmarks'
                    : 'Removed from bookmarks',
                snackPosition: SnackPosition.BOTTOM,
                colorText: isDark ? Colors.white : Colors.black,
              );
            },
          ),
        ),
      ),
    );
  }
}
