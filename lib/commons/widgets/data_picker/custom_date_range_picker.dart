// import 'package:apex_hrm/core/extensions/sized_box_extension.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../core/constance/app_colors.dart';
//
// class CustomCalendarRangeController extends GetxController {
//   final DateTime? firstDate;
//   final DateTime? lastDate;
//
//   final Rx<DateTime> focusedDate = DateTime.now().obs;
//   final Rx<DateTime?> startDate = Rx<DateTime?>(null);
//   final Rx<DateTime?> endDate = Rx<DateTime?>(null);
//
//   late List<int> availableYears;
//
//   CustomCalendarRangeController({this.firstDate, this.lastDate}) {
//     _initializeYears();
//   }
//
//   void _initializeYears() {
//     final currentYear = DateTime.now().year;
//     // Dynamic years: 5 year past + current year + 5 years future = 11 years total
//     availableYears = List.generate(11, (index) => currentYear - 5 + index);
//   }
//
//   void goToPreviousMonth() {
//     focusedDate.value = DateTime(
//       focusedDate.value.year,
//       focusedDate.value.month - 1,
//     );
//     _ensureYearInList(focusedDate.value.year);
//   }
//
//   void goToNextMonth() {
//     focusedDate.value = DateTime(
//       focusedDate.value.year,
//       focusedDate.value.month + 1,
//     );
//     _ensureYearInList(focusedDate.value.year);
//   }
//
//   // Ensure the current focused year is in the available years list
//   void _ensureYearInList(int year) {
//     if (!availableYears.contains(year)) {
//       // Reconstruct list to include this year
//       final minYear = year < availableYears.first ? year : availableYears.first;
//       final maxYear = year > availableYears.last ? year : availableYears.last;
//       availableYears = List.generate(
//         maxYear - minYear + 1,
//         (index) => minYear + index,
//       );
//     }
//   }
//
//   void changeYear(int? year) {
//     if (year != null) {
//       focusedDate.value = DateTime(year, focusedDate.value.month);
//     }
//   }
//
//   void selectDate(DateTime date) {
//     if (startDate.value == null) {
//       startDate.value = date;
//     } else if (endDate.value == null) {
//       if (date.isBefore(startDate.value!)) {
//         endDate.value = startDate.value;
//         startDate.value = date;
//       } else {
//         endDate.value = date;
//       }
//     } else {
//       startDate.value = date;
//       endDate.value = null;
//     }
//   }
//
//   bool isDateInRange(DateTime date) {
//     if (startDate.value == null || endDate.value == null) {
//       return false;
//     }
//     return date.isAfter(startDate.value!) &&
//         date.isBefore(endDate.value!.add(Duration(days: 1)));
//   }
//
//   bool isStartDate(DateTime date) {
//     return startDate.value != null &&
//         date.year == startDate.value!.year &&
//         date.month == startDate.value!.month &&
//         date.day == startDate.value!.day;
//   }
//
//   bool isEndDate(DateTime date) {
//     return endDate.value != null &&
//         date.year == endDate.value!.year &&
//         date.month == endDate.value!.month &&
//         date.day == endDate.value!.day;
//   }
// }
//
// class SelectDateRangeBottomSheet extends StatelessWidget {
//   final DateTime? firstDate;
//   final DateTime? lastDate;
//
//   const SelectDateRangeBottomSheet({super.key, this.firstDate, this.lastDate});
//
//   @override
//   Widget build(BuildContext context) {
//     Get.delete<CustomCalendarRangeController>(force: true);
//     final controller = Get.put(
//       CustomCalendarRangeController(firstDate: firstDate, lastDate: lastDate),
//     );
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // --- Drag Handle ---
//             Container(
//               width: 87.w,
//               height: 6.h,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(2.r),
//               ),
//             ),
//
//             16.height,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back_ios, size: 20),
//                   onPressed: () => Get.back(result: null),
//                 ),
//                 Text(
//                   'select_date_range'.tr,
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(width: 40.w),
//               ],
//             ),
//             16.h.height,
//             // // --- Selected Dates Display ---
//             // Obx(
//             //   () => Container(
//             //     padding: EdgeInsets.all(12.w),
//             //     decoration: BoxDecoration(
//             //       color: Colors.grey.shade100,
//             //       borderRadius: BorderRadius.circular(10.r),
//             //     ),
//             //     child: Row(
//             //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //       children: [
//             //         Column(
//             //           crossAxisAlignment: CrossAxisAlignment.start,
//             //           children: [
//             //             Text(
//             //               'start_date'.tr,
//             //               style: TextStyle(
//             //                 fontSize: 12.sp,
//             //                 color: Colors.grey.shade600,
//             //               ),
//             //             ),
//             //             Text(
//             //               controller.startDate.value != null
//             //                   ? DateFormat(
//             //                       'dd/MM/yyyy',
//             //                     ).format(controller.startDate.value!)
//             //                   : 'Not selected',
//             //               style: TextStyle(
//             //                 fontSize: 14.sp,
//             //                 fontWeight: FontWeight.w600,
//             //               ),
//             //             ),
//             //           ],
//             //         ),
//             //         Icon(Icons.arrow_forward, color: Colors.grey.shade400),
//             //         Column(
//             //           crossAxisAlignment: CrossAxisAlignment.end,
//             //           children: [
//             //             Text(
//             //               'end_date'.tr,
//             //               style: TextStyle(
//             //                 fontSize: 12.sp,
//             //                 color: Colors.grey.shade600,
//             //               ),
//             //             ),
//             //             Text(
//             //               controller.endDate.value != null
//             //                   ? DateFormat(
//             //                       'dd/MM/yyyy',
//             //                     ).format(controller.endDate.value!)
//             //                   : 'Not selected',
//             //               style: TextStyle(
//             //                 fontSize: 14.sp,
//             //                 fontWeight: FontWeight.w600,
//             //               ),
//             //             ),
//             //           ],
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//             // --- Calendar View ---
//             _CustomCalendarRangeView(),
//             24.h.height,
//             SizedBox(
//               width: double.infinity,
//               height: 52.h,
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF1442D3), Color(0xFF0A226D)],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                   borderRadius: BorderRadius.circular(30.r),
//                 ),
//                 child: Obx(
//                   () => ElevatedButton(
//                     onPressed:
//                         controller.startDate.value == null ||
//                             controller.endDate.value == null
//                         ? null
//                         : () {
//                             Get.back(
//                               result: DateTimeRange(
//                                 start: controller.startDate.value!,
//                                 end: controller.endDate.value!,
//                               ),
//                             );
//                           },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.transparent,
//                       shadowColor: Colors.transparent,
//                       disabledBackgroundColor: Colors.grey.shade300,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                     ),
//                     child: Text(
//                       'choos'.tr,
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w700,
//                         color:
//                             controller.startDate.value == null ||
//                                 controller.endDate.value == null
//                             ? Colors.grey
//                             : Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             20.height,
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _CustomCalendarRangeView extends GetView<CustomCalendarRangeController> {
//   const _CustomCalendarRangeView();
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _buildHeader(),
//           16.height,
//           _buildWeekdaysHeader(),
//           12.height,
//           _buildDaysGrid(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     final locale = Get.locale?.languageCode ?? 'ar';
//     final monthNames = DateFormat.MMMM(locale).dateSymbols.MONTHS;
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(
//               monthNames[controller.focusedDate.value.month - 1],
//               style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
//             ),
//             SizedBox(width: 8.w),
//             DropdownButton<int>(
//               value: controller.focusedDate.value.year,
//               icon: const Icon(Icons.keyboard_arrow_down, size: 20),
//               underline: Container(),
//               items: controller.availableYears.map((year) {
//                 return DropdownMenuItem<int>(
//                   value: year,
//                   child: Text(
//                     year.toString(),
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 );
//               }).toList(),
//               onChanged: controller.changeYear,
//             ),
//           ],
//         ),
//         const Spacer(),
//         IconButton(
//           icon: const Icon(Icons.arrow_back, size: 18),
//           onPressed: controller.goToPreviousMonth,
//         ),
//         IconButton(
//           icon: const Icon(Icons.arrow_forward, size: 18),
//           onPressed: controller.goToNextMonth,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildWeekdaysHeader() {
//     final locale = Get.locale?.languageCode ?? 'ar';
//     final weekdays = DateFormat.E(locale).dateSymbols.SHORTWEEKDAYS;
//
//     final List<String> orderedWeekdays = [
//       weekdays[DateTime.saturday % 7],
//       weekdays[DateTime.sunday % 7],
//       weekdays[DateTime.monday % 7],
//       weekdays[DateTime.tuesday % 7],
//       weekdays[DateTime.wednesday % 7],
//       weekdays[DateTime.thursday % 7],
//       weekdays[DateTime.friday % 7],
//     ];
//
//     return Row(
//       children: orderedWeekdays.map((day) {
//         return Expanded(
//           child: Center(
//             child: Text(
//               day,
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildDaysGrid() {
//     return Obx(() {
//       // Access reactive values to ensure GetX tracks them
//       final focusedDate = controller.focusedDate.value;
//       final startDateValue = controller.startDate.value;
//       final endDateValue = controller.endDate.value;
//
//       final daysInMonth = DateUtils.getDaysInMonth(
//         focusedDate.year,
//         focusedDate.month,
//       );
//       final firstDayOfMonth = DateTime(focusedDate.year, focusedDate.month, 1);
//
//       int startOffset = (firstDayOfMonth.weekday % 7 + 1) % 7;
//       int emptyCells = startOffset;
//
//       final prevMonth = DateTime(focusedDate.year, focusedDate.month - 1, 1);
//       final daysInPrevMonth = DateUtils.getDaysInMonth(
//         prevMonth.year,
//         prevMonth.month,
//       );
//
//       int totalCells = emptyCells + daysInMonth;
//       if (totalCells % 7 != 0) {
//         totalCells += 7 - (totalCells % 7);
//       }
//
//       int nextMonthDay = 1;
//
//       return GridView.builder(
//         physics: const NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         itemCount: totalCells,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 7,
//           crossAxisSpacing: 8.w,
//           mainAxisSpacing: 6.h,
//           mainAxisExtent: 50.h,
//         ),
//         itemBuilder: (context, index) {
//           final int dayNumber;
//           final bool isCurrentMonth;
//           DateTime? cellDate;
//           Color textColor = Colors.black;
//
//           if (index < emptyCells) {
//             dayNumber = daysInPrevMonth - emptyCells + index + 1;
//             isCurrentMonth = false;
//             textColor = Colors.grey.shade400;
//             cellDate = DateTime(prevMonth.year, prevMonth.month, dayNumber);
//           } else if (index < emptyCells + daysInMonth) {
//             dayNumber = index - emptyCells + 1;
//             isCurrentMonth = true;
//             textColor = Colors.black;
//             cellDate = DateTime(
//               controller.focusedDate.value.year,
//               controller.focusedDate.value.month,
//               dayNumber,
//             );
//           } else {
//             dayNumber = nextMonthDay++;
//             isCurrentMonth = false;
//             textColor = Colors.grey.shade400;
//             final nextMonth = DateTime(
//               controller.focusedDate.value.year,
//               controller.focusedDate.value.month + 1,
//               1,
//             );
//             cellDate = DateTime(nextMonth.year, nextMonth.month, dayNumber);
//           }
//
//           // Check if day is in range
//           final bool isRangeStart =
//               startDateValue != null &&
//               isCurrentMonth &&
//               DateUtils.isSameDay(cellDate, startDateValue);
//
//           final bool isRangeEnd =
//               endDateValue != null &&
//               isCurrentMonth &&
//               DateUtils.isSameDay(cellDate, endDateValue);
//
//           final bool isInRange =
//               isCurrentMonth &&
//               startDateValue != null &&
//               endDateValue != null &&
//               cellDate.isAfter(startDateValue) &&
//               cellDate.isBefore(endDateValue);
//
//           final bool isToday =
//               isCurrentMonth && DateUtils.isSameDay(cellDate, DateTime.now());
//
//           return GestureDetector(
//             onTap: isCurrentMonth
//                 ? () => controller.selectDate(cellDate!)
//                 : null,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 // Background for range
//                 if (isInRange)
//                   Container(
//                     width: double.infinity,
//                     height: double.infinity,
//                     margin: EdgeInsets.symmetric(horizontal: 2.w),
//                     decoration: BoxDecoration(
//                       color: AppColors.primary.withOpacity(0.2),
//                     ),
//                   ),
//                 // Background for start/end of range
//                 if (isRangeStart || isRangeEnd)
//                   Container(
//                     width: 48.w,
//                     height: 48.h,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       gradient: AppColors.primaryGradient,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Text(
//                       '$dayNumber',
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                   )
//                 else
//                   Container(
//                     width: 48.w,
//                     height: 48.h,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: isToday && !isInRange
//                           ? Border.all(color: AppColors.primary, width: 2)
//                           : null,
//                     ),
//                     child: Text(
//                       '$dayNumber',
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
//                         color: isInRange
//                             ? AppColors.primary
//                             : isToday
//                             ? AppColors.primary
//                             : textColor,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       );
//     });
//   }
// }
