
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constance/app_colors.dart';
import '../../../core/helpers/image_helper.dart';

class CustomFilterButton extends StatelessWidget with ImageHelper {
  final VoidCallback onTap;

  const CustomFilterButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12.r),
        ),
      //  child: appSvgImage(AppRes.filterIcon, color: Colors.white),
      ),
    );
  }
}
