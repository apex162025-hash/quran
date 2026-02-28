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

  // Styles commented out due to 'Undefined class' error in linter.
  // It seems these classes are not exported by the package main file.
  /*
  static AyahAudioStyle ayahAudioStyle(bool isDark) {
    return AyahAudioStyle(
      backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      playIconColor: AppTheme.secondaryLight,
      pauseIconColor: AppTheme.secondaryLight,
      nextIconColor: isDark ? Colors.white70 : Colors.black54,
      previousIconColor: isDark ? Colors.white70 : Colors.black54,
      sliderActiveColor: AppTheme.secondaryLight,
      sliderInactiveColor: isDark ? Colors.grey[700] : Colors.grey[300]!,
      textColor: isDark ? Colors.white : Colors.black,
    );
  }

  static SurahAudioStyle surahAudioStyle(bool isDark) {
    return SurahAudioStyle(
      backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      playIconColor: AppTheme.secondaryLight,
      pauseIconColor: AppTheme.secondaryLight,
      borderColor: AppTheme.secondaryLight,
    );
  }
  */

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
      // textColor: isDark ? Colors.white : Colors.black, // Not defined
      // buttonBackgroundColor: AppTheme.primaryLight, // Not defined
      // buttonTextColor: Colors.white, // Not defined
    );
  }
}
