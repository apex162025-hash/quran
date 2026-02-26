import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tordoo_qr/core/constance/app_colors.dart';
import 'package:tordoo_qr/core/extensions/sized_box_extension.dart';
import 'package:tordoo_qr/core/helpers/image_helper.dart';

class AppConfirmationDialog extends StatelessWidget with ImageHelper {
  final String icon;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool showCloseButton;

  const AppConfirmationDialog({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.subtitle,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    this.onCancel,
    this.showCloseButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            if (showCloseButton)
              Align(
                alignment: AlignmentDirectional.topStart,
                child: GestureDetector(
                  onTap: onCancel ?? () => Get.back(),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey.shade500,
                    size: 22.sp,
                  ),
                ),
              ),

            // Icon
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              padding: EdgeInsets.all(18.w),
              child: appSvgImage(icon),
            ),
            SizedBox(height: 20.h),

            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),

            // Subtitle
            Text(
              subtitle,
              style: TextStyle(fontSize: 14.sp, color: AppColors.grayText),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ElevatedButton(
                      onPressed: onCancel ?? () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        cancelText,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                12.width,
                Expanded(
                  child: OutlinedButton(
                    onPressed: onConfirm,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      confirmText,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Show a delete account confirmation dialog
  static void showDeleteAccount({required VoidCallback onConfirm}) {
    Get.dialog(
      AppConfirmationDialog(
        icon: 'assets/icons/trash.svg',
        iconBackgroundColor: const Color(0xffF23F44).withOpacity(0.1),
        title: 'delete_account'.tr,
        subtitle: 'delete_account_confirm'.tr,
        confirmText: 'confirm_delete'.tr,
        cancelText: 'cancel'.tr,
        onConfirm: onConfirm,
      ),
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }

  /// Show a logout confirmation dialog
  static void showLogout({required VoidCallback onConfirm}) {
    Get.dialog(
      AppConfirmationDialog(
        icon: 'assets/icons/logout.svg',
        iconBackgroundColor: const Color(0xffF81140).withOpacity(0.1),
        title: 'logout'.tr,
        subtitle: 'logout_confirm'.tr,
        confirmText: 'yes'.tr,
        cancelText: 'cancel'.tr,
        showCloseButton: true,
        onConfirm: onConfirm,
      ),
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }
}
