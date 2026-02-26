
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constance/app_assets.dart';
import '../../../core/constance/app_colors.dart';
import '../../../core/helpers/image_helper.dart';
import '../button/custom_filter_button.dart';

class SearchTextField extends StatelessWidget with ImageHelper {
  final TextEditingController controller;
  final String? hint;
  final Color? fillColor;
  final VoidCallback onFilterTap;
  final double? searchIconWidth;
  final double? searchIconHeight;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.onFilterTap,
    this.hint,
    this.fillColor,
    this.searchIconWidth,
    this.searchIconHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: fillColor ?? AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(fontSize: 14.sp, color: AppColors.blackText),
        decoration: InputDecoration(
          hintText: hint ?? 'search'.tr,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: AppColors.grayText.withOpacity(0.3),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 16.h,
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: (searchIconWidth ?? 22.r) + 26.w,
            minHeight: searchIconHeight ?? 22.r,
          ),
          prefixIcon: Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: appSvgImage(
              AppAssets.searchIcon,
              color: AppColors.grayText.withOpacity(0.3),
              height: searchIconHeight ?? 22.r,
              width: searchIconWidth ?? 22.r,
            ),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.all(6.sp),
            child: CustomFilterButton(onTap: onFilterTap),
          ),
        ),
      ),
    );
  }
}
