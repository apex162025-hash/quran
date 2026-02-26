
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tordoo_qr/core/extensions/sized_box_extension.dart';

import '../../../core/constance/app_colors.dart';

class CustomMonthPickerDialog extends StatelessWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const CustomMonthPickerDialog({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      MonthPickerController(initialDate: initialDate),
      tag: 'month_picker_${DateTime.now().millisecondsSinceEpoch}',
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
            // Header: Year Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 18),
                  onPressed: controller.decrementYear,
                  color: AppColors.blackText,
                ),
                Obx(
                  () => Text(
                    '${controller.selectedYear.value}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackText,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  onPressed: controller.incrementYear,
                  color: AppColors.blackText,
                ),
              ],
            ),
            20.height,
            // Months Grid
            Obx(() {
              final selectedMonth = controller.selectedMonth.value;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 12,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 1.8,
                ),
                itemBuilder: (context, index) {
                  final isSelected = selectedMonth == index + 1;
                  return GestureDetector(
                    onTap: () => controller.selectMonth(index + 1),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF86CDC9) // Light teal for selected
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        DateFormat.MMM(
                          Get.locale?.languageCode ?? 'ar',
                        ).dateSymbols.MONTHS[index],
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
                      final selectedDate = DateTime(
                        controller.selectedYear.value,
                        controller.selectedMonth.value,
                      );
                      onDateSelected(selectedDate);
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

class MonthPickerController extends GetxController {
  final DateTime initialDate;
  var selectedYear = 0.obs;
  var selectedMonth = 1.obs;

  MonthPickerController({required this.initialDate});

  @override
  void onInit() {
    super.onInit();
    selectedYear.value = initialDate.year;
    selectedMonth.value = initialDate.month;
  }

  void incrementYear() {
    selectedYear.value++;
  }

  void decrementYear() {
    selectedYear.value--;
  }

  void selectMonth(int month) {
    selectedMonth.value = month;
  }
}
