import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_library/quran_library.dart';
import 'app_theme.dart';

class QuranStyles {
  static SurahNameStyle surahNameStyle(bool isDark) {
    return SurahNameStyle(
      surahNameColor: isDark ? AppTheme.secondaryLight : AppTheme.primaryLight,
      surahNameSize: 20.sp,
      // fontFamily: 'Amiri', // Not defined
    );
  }

  static SurahInfoStyle surahInfoStyle(bool isDark) {
    return SurahInfoStyle(
      backgroundColor: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
      textColor: Colors.white,
      // iconColor: AppTheme.secondaryLight, // Not defined
    );
  }

  static BasmalaStyle basmalaStyle(bool isDark) {
    return BasmalaStyle(
      basmalaColor: isDark ? AppTheme.secondaryLight : AppTheme.primaryLight,
    );
  }

  static BannerStyle bannerStyle(bool isDark) {
    return BannerStyle(
      // bannerSvgPath: '',
    );
  }


  static QuranTopBarStyle topBarStyle(bool isDark) {
    return QuranTopBarStyle(
      backgroundColor: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
      iconColor: Colors.white,
      textColor: Colors.white,
    );
  }

  static DownloadFontsDialogStyle downloadFontsDialogStyle(bool isDark) {
    return DownloadFontsDialogStyle(
      backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
    );
  }
}
