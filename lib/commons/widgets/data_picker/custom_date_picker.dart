// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:sekaa_owner_app/commons/extensions/sized_box_extension.dart';
// import 'package:sekaa_owner_app/core/constance/app_colors.dart';
// import '../../../core/enums/enums.dart';
// import '../../../core/utils/utils.dart';
// import '../../../features/property/presentation/controllers/customer_calender_controller.dart';
//
// class SelectDateBottomSheet extends StatelessWidget {
//   final DateTime initialDate;
//   final DateTime? firstDate;
//   final DateTime? lastDate;
//
//   const SelectDateBottomSheet({
//     super.key,
//     required this.initialDate,
//     this.firstDate,
//     this.lastDate,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(
//       CustomCalendarController(
//         initialDate: initialDate,
//         firstDate: firstDate,
//         lastDate: lastDate,
//       ),
//     );
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // --- Drag Handle ---
//           Container(
//             width: 87.w,
//             height: 6.h,
//             decoration: BoxDecoration(
//               color: Colors.grey.shade300,
//               borderRadius: BorderRadius.circular(2.r),
//             ),
//           ),
//           16.height,
//           // --- Title ---
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.arrow_back_ios, size: 20),
//                 onPressed: () => Get.back(result: null), // Close
//               ),
//               Text(
//                 'select_date'.tr,
//                 style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
//               ),
//               SizedBox(width: 40.w), // To balance the back arrow
//             ],
//           ),
//           16.height,
//           // --- Calendar View ---
//           _CustomCalendarView(), // The calendar logic
//           24.height,
//           // --- Submit Button ---
//           SizedBox(
//             width: double.infinity,
//             height: 52.h,
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF1442D3), Color(0xFF0A226D)],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ),
//                 borderRadius: BorderRadius.circular(30.r),
//               ),
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Validate if a date is selected
//                   if (controller.selectedDate.value == null) {
//                     Utils.getSnakBar(
//                       type: TosterTypes.warning,
//                       message: 'يجب اختيار تاريخ',
//                     );
//                     return;
//                   }
//                   // Return the selected date
//                   Get.back(result: controller.selectedDate.value);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                   shadowColor: Colors.transparent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                 ),
//                 child: Text(
//                   'choos'.tr,
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           20.height,
//         ],
//       ),
//     );
//   }
// }
//
// // This is the calendar widget, adapted from your helper code
// class _CustomCalendarView extends GetView<CustomCalendarController> {
//   const _CustomCalendarView();
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
//               // Hide default underline
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
//     // Order: Sat, Sun, Mon, Tue, Wed, Thu, Fri
//     final List<String> orderedWeekdays = [
//       weekdays[DateTime.saturday % 7], // Sat
//       weekdays[DateTime.sunday % 7], // Sun
//       weekdays[DateTime.monday % 7], // Mon
//       weekdays[DateTime.tuesday % 7], // Tue
//       weekdays[DateTime.wednesday % 7], // Wed
//       weekdays[DateTime.thursday % 7], // Thu
//       weekdays[DateTime.friday % 7], // Fri
//     ].where((day) => day.isNotEmpty).toList();
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: orderedWeekdays.map((day) {
//         return Text(
//           day,
//           style: TextStyle(
//             fontSize: 12.sp,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey.shade600,
//           ),
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildDaysGrid() {
//     final daysInMonth = DateUtils.getDaysInMonth(
//       controller.focusedDate.value.year,
//       controller.focusedDate.value.month,
//     );
//     final firstDayOfMonth = DateTime(
//       controller.focusedDate.value.year,
//       controller.focusedDate.value.month,
//       1,
//     );
//
//     // Calculate offset based on Saturday being the start (index 0)
//     int startOffset = (firstDayOfMonth.weekday % 7 + 1) % 7;
//     int emptyCells = startOffset;
//
//     final prevMonth = DateTime(
//       controller.focusedDate.value.year,
//       controller.focusedDate.value.month - 1,
//       1,
//     );
//     final daysInPrevMonth = DateUtils.getDaysInMonth(
//       prevMonth.year,
//       prevMonth.month,
//     );
//
//     int totalCells = emptyCells + daysInMonth;
//     if (totalCells % 7 != 0) {
//       totalCells += 7 - (totalCells % 7);
//     }
//
//     int nextMonthDay = 1;
//
//     return GridView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: totalCells,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 7,
//         crossAxisSpacing: 8.w,
//         mainAxisSpacing: 6.h,
//         mainAxisExtent: 40.h, // Adjusted height for a tighter grid
//       ),
//       itemBuilder: (context, index) {
//         final int dayNumber;
//         DateTime cellDate;
//         Color textColor = Colors.black;
//         bool isCurrentMonth = false;
//
//         if (index < emptyCells) {
//           // Previous month's days
//           dayNumber = daysInPrevMonth - emptyCells + index + 1;
//           textColor = Colors.grey.shade400;
//           cellDate = DateTime(prevMonth.year, prevMonth.month, dayNumber);
//         } else if (index < emptyCells + daysInMonth) {
//           // Current month's days
//           dayNumber = index - emptyCells + 1;
//           isCurrentMonth = true;
//           textColor = Colors.black;
//           cellDate = DateTime(
//             controller.focusedDate.value.year,
//             controller.focusedDate.value.month,
//             dayNumber,
//           );
//         } else {
//           // Next month's days
//           dayNumber = nextMonthDay++;
//           textColor = Colors.grey.shade400;
//           final nextMonth = DateTime(
//             controller.focusedDate.value.year,
//             controller.focusedDate.value.month + 1,
//             1,
//           );
//           cellDate = DateTime(nextMonth.year, nextMonth.month, dayNumber);
//         }
//
//         final bool isSelected =
//             controller.selectedDate.value != null &&
//             DateUtils.isSameDay(cellDate, controller.selectedDate.value);
//
//         final bool isToday = DateUtils.isSameDay(cellDate, DateTime.now());
//         final bool isDisabled = controller.isDayDisabled(cellDate);
//
//         // Determine text color for disabled dates
//         if (isDisabled) {
//           textColor = Colors.grey.shade300;
//         }
//
//         return GestureDetector(
//           onTap: isDisabled ? null : () => controller.onDaySelected(cellDate),
//           child: Container(
//             width: 38.w,
//             height: 38.h,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: isSelected ? const Color(0xFF1442D3) : Colors.transparent,
//               gradient: isSelected ? AppColors.primaryGradient : null,
//               shape: BoxShape.circle,
//               border: isToday && !isSelected
//                   ? Border.all(color: const Color(0xFF1442D3), width: 1.5)
//                   : null,
//             ),
//             child: Text(
//               '$dayNumber',
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
//                 color: isSelected
//                     ? Colors.white
//                     : isToday
//                     ? const Color(0xFF1442D3)
//                     : textColor,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
