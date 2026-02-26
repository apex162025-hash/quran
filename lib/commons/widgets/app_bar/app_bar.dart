import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constance/app_assets.dart';
import '../../../core/helpers/image_helper.dart';

class CustomAppBar extends StatelessWidget
    with ImageHelper
    implements PreferredSizeWidget {
  final String title;
  final Widget? trailingWidget;

  const CustomAppBar({super.key, required this.title, this.trailingWidget});

  @override
  Widget build(BuildContext context) {
    final bool isEnglish = Get.locale?.languageCode == 'en';
    final double appBarHeight = 56.h;

    return Container(
      color: Colors.white,
      padding: EdgeInsetsDirectional.only(
        start: 20.w,
        end: 20.w,
        top: MediaQuery.of(context).padding.top + 12.h,
      ),
      child: SizedBox(
        height: appBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // InkWell(
            //   onTap: () => Get.back(),
            //   child: Container(
            //     padding: EdgeInsets.all(4.r),
            //     child: Transform(
            //       alignment: Alignment.center,
            //       transform: isEnglish
            //           ? Matrix4.rotationY(math.pi)
            //           : Matrix4.identity(),
            //       child: appSvgImage(AppRes.backIcon, color: Colors.black),
            //     ),
            //   ),
            // ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            if (trailingWidget != null) trailingWidget!,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(56.h + MediaQuery.of(Get.context!).padding.top);
}
