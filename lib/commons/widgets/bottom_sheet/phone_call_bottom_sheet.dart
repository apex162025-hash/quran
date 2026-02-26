import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tordoo_qr/core/constance/app_assets.dart';
import 'package:tordoo_qr/core/constance/app_colors.dart';
import 'package:tordoo_qr/core/extensions/sized_box_extension.dart';
import 'package:tordoo_qr/core/helpers/image_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneCallBottomSheet extends StatelessWidget with ImageHelper {
  final List<String> phoneNumbers;

  const PhoneCallBottomSheet({super.key, required this.phoneNumbers});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.close,
                color: Colors.grey.shade500,
                size: 22.sp,
              ),
            ),
          ),
          8.height,

          // Title
          Text(
            'call_via'.tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          20.height,

          // Phone number buttons
          ...phoneNumbers.map(
            (phone) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildPhoneButton(phone),
            ),
          ),
          8.height,
        ],
      ),
    );
  }

  Widget _buildPhoneButton(String phoneNumber) {
    return InkWell(
      onTap: () async {
        final uri = Uri(scheme: 'tel', path: phoneNumber);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              phoneNumber,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
              textDirection: TextDirection.ltr,
            ),
            10.width,
            appSvgImage(
              AppAssets.mobile2,
              color: Colors.white,
              height: 18.sp,
            ),

          ],
        ),
      ),
    );
  }

  /// Show the phone call bottom sheet
  static void show({required List<String> phoneNumbers}) {
    Get.bottomSheet(
      PhoneCallBottomSheet(phoneNumbers: phoneNumbers),
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
    );
  }
}
