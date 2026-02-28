
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_project/core/extensions/sized_box_extension.dart';
import '../../../core/constance/app_colors.dart';

class CustomEmptyState extends StatelessWidget {
  final String imagePath;
  final String text;
  final double? imageWidth;
  final double? imageHeight;

  const CustomEmptyState({
    super.key,
    required this.imagePath,
    required this.text,
    this.imageWidth,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: imageWidth ?? 110.w,
          height: imageHeight ?? 100.h,
        ),
        12.height,
        Text(
          text,
          style: TextStyle(
            color: AppColors.grayText,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
