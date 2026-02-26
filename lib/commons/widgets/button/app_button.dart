import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constance/app_colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final Color? textColor;
  final Color? backgroundColor;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;
  final VoidCallback onPressed;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.fontSize,
    this.textColor,
    this.backgroundColor,
    this.fontWeight,
    this.borderRadius,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(50.r);

    return Container(
      width: width ?? double.infinity,
      height: height ?? 50.h,
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary,
        borderRadius: effectiveBorderRadius,
        gradient: isLoading
            ? AppColors.disabledGradient
            : AppColors.primaryGradient,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
          padding: padding ?? EdgeInsets.symmetric(vertical: 10.h),
        ),
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? AppColors.whiteText,
                  ),
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: fontSize ?? 16.sp,
                  color: textColor ?? AppColors.whiteText,
                  fontWeight: fontWeight ?? FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
