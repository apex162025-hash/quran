import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAppTextTheme {
  MyAppTextTheme._();

  static TextTheme textTheme = TextTheme(
      headlineLarge: TextStyle().copyWith(
          fontSize: 32.sp, fontWeight: FontWeight.bold, color: Colors.black),
      headlineMedium: TextStyle().copyWith(
          fontSize: 24.sp, fontWeight: FontWeight.w600, color: Colors.black),
      headlineSmall: TextStyle().copyWith(
          fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.black),

      titleLarge: TextStyle().copyWith(
          fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black),
      titleMedium: TextStyle().copyWith(
          fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black),
      titleSmall: TextStyle().copyWith(
          fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.black),

      bodyLarge: TextStyle().copyWith(
          fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black),
      bodyMedium: TextStyle().copyWith(
          fontSize: 14.sp, fontWeight: FontWeight.normal, color: Colors.black),
      bodySmall: TextStyle().copyWith(fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black.withOpacity(0.5)),

      labelLarge: TextStyle().copyWith(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),
      labelMedium: TextStyle().copyWith(fontSize: 14.sp,
          fontWeight: FontWeight.normal,
          color: Colors.black.withOpacity(0.5))
  );
}