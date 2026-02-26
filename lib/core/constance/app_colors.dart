
import 'package:flutter/material.dart';


class AppColors {
  // main colors
  static Color primary = Color(0xff543895);
  static Color secondary =  Color(0xffC238DC);

  // background and accents
  static Color bg = const Color(0xffF7F8FA);

  // text colors
  static Color blackText = const Color(0xff1B132A);
  static Color grayText = const Color(0xff6C6C89);
  static Color whiteText = const Color(0xffffffff);

  static Color hintGray = const Color(0xffA9A9A9);
  static Color ignoreColor = const Color(0xffEBEBEF);

  // snackbar colors
  static Color success = const Color(0xff1B8354);
  static Color error = const Color(0xffE53935);

  // gradients
  static LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );
  static LinearGradient disabledGradient = LinearGradient(
    colors: [primary.withOpacity(0.5), secondary.withOpacity(0.5)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );
}