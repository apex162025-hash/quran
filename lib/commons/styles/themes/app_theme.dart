
import 'package:flutter/material.dart';
import 'package:test_project/commons/styles/themes/text_theme.dart';
import '../../../core/constance/app_colors.dart';

class MyAppTheme {
  MyAppTheme._();

  static ThemeData appTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'IBMPlexSansArabic',
    brightness: Brightness.light,
    textTheme: MyAppTextTheme.textTheme,
    primaryColor: AppColors.primary,
    secondaryHeaderColor:AppColors.secondary,
    hintColor: AppColors.hintGray,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    dividerColor: Colors.grey.shade300,
    scaffoldBackgroundColor: const Color(0xffF8F8F8),
    shadowColor: Colors.grey.shade200,
  );
}
