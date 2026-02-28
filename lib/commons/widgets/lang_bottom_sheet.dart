import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test_project/core/extensions/sized_box_extension.dart';
import '../../core/constance/app_assets.dart';
import '../../core/constance/app_colors.dart';
import '../../core/helpers/image_helper.dart';
import '../../core/local/lang_controller.dart';

class LanguageBottomSheet extends StatelessWidget with ImageHelper {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 264.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Wrap(
        children: [
          Center(
            child: Container(
              width: 87.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Align(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: Text(
                        'theLanguage'.tr,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                16.height,
              ],
            ),
          ),
          24.height,

          GetBuilder<LanguageGetxController>(
            builder: (controller) {
              return Column(
                children: [
                  _buildLanguageOption(
                    title: 'theArabic'.tr,
                    flagAsset: AppAssets.arabicIcon,
                    isSelected: controller.lang == 'ar',
                    onTap: () async {
                      await controller.changeLanguage('ar', 'Ps');
                      Get.back();
                    },
                  ),
                  16.height,
                  _buildLanguageOption(
                    title: 'theEnglish'.tr,
                    flagAsset: AppAssets.englishIcon,
                    isSelected: controller.lang == 'en',
                    onTap: () async {
                      await controller.changeLanguage('en', 'US');
                      Get.back();
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required String title,
    required String flagAsset,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFDADADA),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: appSvgImage(
                    flagAsset,
                    width: 32.w,
                    height: 32.h,
                    fit: BoxFit.cover,
                  ),
                ),
                12.width,
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
