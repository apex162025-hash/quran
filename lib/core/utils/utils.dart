import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:test_project/core/extensions/sized_box_extension.dart';
import '../enums/enums.dart';

class Utils {
  static void getSnakBar(
      {DioException? e,
        String? message,
        Color? color,
        required TosterTypes? type}) {
    Get.showSnackbar(
      GetSnackBar(
          padding: EdgeInsets.zero,
          borderRadius: 16.r,
          margin: const EdgeInsets.all(16),
          animationDuration: const Duration(seconds: 1),
          duration: const Duration(seconds: 2),
          backgroundColor: type == TosterTypes.failed
              ? const Color(0xffF3164E)
              : type == TosterTypes.sucsses
              ? const Color(0xff1B8354)
              : type == TosterTypes.warning
              ? const Color(0xffF9943B)
              : const Color(0xffF63E50),
          messageText: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 12.r,
                        backgroundColor: Colors.white,
                        child: Icon(
                          size: 20,
                          type == TosterTypes.failed
                              ? Icons.close
                              : type == TosterTypes.sucsses
                              ? Icons.check
                              : type == TosterTypes.warning
                              ? Icons.error_outline
                              : Icons.close,
                          color: type == TosterTypes.failed
                              ? const Color(0xffF63E50)
                              : type == TosterTypes.sucsses
                              ? const Color(0xff1B8354)
                              : type == TosterTypes.warning
                              ? const Color(0xffF9943B)
                              : const Color(0xffF63E50),
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: Text(
                          message ?? '',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
                // Progress Bar
                SizedBox(
                  height: 4.h,
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(seconds: 2),
                    tween: Tween(begin: 1.0, end: 0.0),
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          type == TosterTypes.failed
                              ? const Color(0xffF76489)
                              : type == TosterTypes.sucsses
                              ? const Color(0xff2FCE8E)
                              : type == TosterTypes.warning
                              ? const Color(0xffB15500)
                              : const Color(0xff99004D),
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.r),
                          bottomRight: Radius.circular(16.r),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  static Future<dynamic> openAlertDialog({
    required BuildContext context,
    required String assetPath,
    required String description,
    required Function() yesOnTap,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 350.w, // Adjust the width as needed
            height: 250.h, // Adjust the height as needed
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SvgPicture.asset(
                  assetPath,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 5.h),
                // If you want to include a title, uncomment the lines below
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: yesOnTap,
                          child: Text(
                            "Yes".tr,
                            style:
                                TextStyle(color: Theme.of(context).hintColor),
                          )),
                      TextButton(
                        child: Text("No".tr,
                            style: const TextStyle(color: Colors.black)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String formatCurrency(double amount, String currencySymbol) {
    return '$currencySymbol${formatPrice(amount)}';
  }
  static String formatPrice(double price) {
    if (price >= 1e9) {
      return '${(price / 1e9).toStringAsFixed(1)}B';
    } else if (price >= 1e6) {
      return '${(price / 1e6).toStringAsFixed(1)}M';
    } else if (price >= 1e3) {
      return '${(price / 1e3).toStringAsFixed(1)}K';
    } else {
      return price.toStringAsFixed(2);
    }
  }
}
