
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tordoo_qr/core/extensions/sized_box_extension.dart';

import '../../../core/constance/app_colors.dart';

class CustomYearPickerDialog extends StatelessWidget {
  final int initialYear;
  final ValueChanged<int> onYearSelected;

  const CustomYearPickerDialog({
    super.key,
    required this.initialYear,
    required this.onYearSelected,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      YearPickerController(initialYear: initialYear),
      tag: 'year_picker_${DateTime.now().millisecondsSinceEpoch}',
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(20.r),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: Year Range Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 18),
                  onPressed: controller.decrementPage,
                  color: AppColors.blackText,
                ),
                Obx(
                  () => Text(
                    '${controller.displayedCenterYear.value}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackText,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  onPressed: controller.incrementPage,
                  color: AppColors.blackText,
                ),
              ],
            ),
            20.height,
            // Years Grid
            Obx(() {
              final centerYear = controller.displayedCenterYear.value;
              final selectedYear = controller.selectedYear.value;
              final minYear = centerYear - 4;
              final years = List.generate(9, (index) => minYear + index);

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 1.8,
                ),
                itemBuilder: (context, index) {
                  final year = years[index];
                  final isSelected = selectedYear == year;

                  return GestureDetector(
                    onTap: () => controller.selectYear(year),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF86CDC9) // Light teal for selected
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$year',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppColors.blackText,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
            30.height,
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF389B99)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      'cancel'.tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF389B99),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                16.width,
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onYearSelected(controller.selectedYear.value);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF389B99),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      'apply'.tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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
}

class YearPickerController extends GetxController {
  final int initialYear;
  var selectedYear = 0.obs;
  var displayedCenterYear = 0.obs;

  YearPickerController({required this.initialYear});

  @override
  void onInit() {
    super.onInit();
    selectedYear.value = initialYear;
    displayedCenterYear.value = initialYear;
  }

  void incrementPage() {
    displayedCenterYear.value += 9;
  }

  void decrementPage() {
    displayedCenterYear.value -= 9;
  }

  void selectYear(int year) {
    selectedYear.value = year;
  }
}
