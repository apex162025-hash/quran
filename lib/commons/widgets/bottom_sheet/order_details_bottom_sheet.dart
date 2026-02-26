import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:tordoo_qr/core/constance/app_assets.dart';
import 'package:tordoo_qr/core/constance/app_colors.dart';
import 'package:tordoo_qr/core/extensions/sized_box_extension.dart';
import 'package:tordoo_qr/core/helpers/image_helper.dart';
import 'package:tordoo_qr/commons/widgets/bottom_sheet/phone_call_bottom_sheet.dart';
import 'package:tordoo_qr/features/scanner/data/models/order_scan_response_model.dart';
import 'package:tordoo_qr/features/scanner/presentation/controllers/scanner_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsBottomSheet extends StatelessWidget with ImageHelper {
  final OrderScanResponseModel orderData;

  const OrderDetailsBottomSheet({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final scannerController = Get.find<ScannerController>();

    return SizedBox(
      height: Get.height * 0.82,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              16.height,
              Container(
                width: 50.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              12.height,
              // Close Button
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ),
              // Scrollable Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    bottom: 24.h,
                  ),
                  child: Column(
                    children: [
                      // Header
                      _buildOrderHeader(orderData.order),
                      30.height,

                      // Pickup Address Section
                      _buildPickedUpSection(
                        title: 'pickup_address'.tr,
                        name: orderData.order.pickupAddress.name,
                        address: orderData.order.pickupAddress.address,
                        mobile: orderData.order.pickupAddress.mobile,
                        whatsapp: orderData.order.pickupAddress.whatsappMobile,
                        mapUrl: orderData.order.pickupAddress.mapUrl,
                      ),
                      16.height,

                      // Delivery Address Section
                      _buildDropDownSection(
                        title: 'delivery_address'.tr,
                        name: orderData.order.deliveryAddress.name,
                        address: orderData.order.deliveryAddress.address,
                        mobile: orderData.order.deliveryAddress.mobile,
                        whatsapp:
                            orderData.order.deliveryAddress.whatsappMobile,
                        mapUrl: orderData.order.deliveryAddress.mapUrl,
                      ),
                      16.height,

                      // Total Amount Section
                      _buildTotalAmountSection(orderData.order.total),
                      16.height,

                      if (orderData.order.products.isNotEmpty) ...[
                        _buildProductsSection(orderData.order.products),
                        16.height,
                      ],

                      if (orderData.order.notes.isNotEmpty) ...[
                        _buildNotesSection(orderData.order.notes),
                        16.height,
                      ],

                      // Tracking Log
                      if (orderData.order.trackingLog.isNotEmpty)
                        _buildTrackingLog(orderData.order.trackingLog),

                      16.height,
                    ],
                  ),
                ),
              ),

              if (scannerController.userType.value == 'company' &&
                  orderData.canConfirmReceived == true)
                _buildConfirmButton(context),
              if (orderData.order.printParcelDefault.isNotEmpty &&
                  scannerController.userType.value == 'company' &&
                  orderData.canConfirmReceived == false)
                _buildPrintButton(orderData.order.printParcelDefault),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        bottom: 20.h,
        top: 10.h,
      ),
      child: InkWell(
        onTap: () {
          Get.find<ScannerController>().confirmOrder(orderData.order.id);
        },
        child: Container(
          width: double.infinity,
          height: 50.h,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'confirm_picked_up'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              8.width,
              appSvgImage(
                'assets/icons/circle-check.svg',
                color: Colors.white,
                height: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────── ORDER HEADER ────────────────────
  Widget _buildOrderHeader(OrderScanDetails order) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          // Order icon
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14.r),
            ),
            padding: EdgeInsets.all(12.w),
            child: appSvgImage(AppAssets.orderBox, height: 34.h, width: 34.w),
          ),
          10.height,
          // Order number
          Text(
            '${'order_number'.tr} #${order.orderNumber}',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.blackText,
            ),
          ),
          2.height,
          // Creation date
          Text(
            '${'creation_date'.tr}: ${order.createdAt}',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.grayText,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required String icon,
    required Color color,
    required Color bgColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.all(8.w),
        child: appSvgImage(icon, color: color, height: 16.h, width: 16.w),
      ),
    );
  }

  // ──────────────────── ADDRESS SECTION ────────────────────
  Widget _buildPickedUpSection({
    required String title,
    required String name,
    required String address,
    required String mobile,
    required String whatsapp,
    required String mapUrl,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Row(
                children: [
                  appSvgImage(AppAssets.location, height: 18.sp),
                  6.width,
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackText,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  _buildContactButton(
                    icon: AppAssets.phoneCall,
                    color: AppColors.primary,
                    bgColor: AppColors.primary.withOpacity(0.1),
                    onTap:
                        () => PhoneCallBottomSheet.show(
                          phoneNumbers: [mobile, whatsapp],
                        ),
                  ),
                  8.width,
                  _buildContactButton(
                    icon: AppAssets.whatsapp,
                    color: const Color(0xff25D366),
                    bgColor: const Color(0xff25D366).withOpacity(0.1),
                    onTap: () async {
                      final url = Uri.parse("https://wa.me/$whatsapp");
                      if (await canLaunchUrl(url)) {
                        launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                  ),
                  8.width,
                  _buildContactButton(
                    icon: AppAssets.location2,
                    color: const Color(0xffE53935),
                    bgColor: const Color(0xffE53935).withOpacity(0.1),
                    onTap: () async {
                      final url = Uri.parse(mapUrl);
                      if (await canLaunchUrl(url)) {
                        launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          8.height,
          Divider(color: Colors.grey.shade100),
          // Name row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appSvgImage(
                AppAssets.profile,
                color: AppColors.grayText.withOpacity(0.5),
                height: 18.sp,
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'the_name'.tr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.grayText,
                      ),
                    ),
                    4.height,
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.height,
          // Address row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appSvgImage(
                AppAssets.location2,
                color: AppColors.grayText.withOpacity(0.5),
                height: 16.sp,
              ),
              16.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'the_address'.tr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.grayText,
                      ),
                    ),
                    4.height,
                    Text(
                      address,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropDownSection({
    required String title,
    required String name,
    required String address,
    required String mobile,
    required String whatsapp,
    required String mapUrl,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Row(
                children: [
                  appSvgImage(AppAssets.location2, height: 18.sp),
                  6.width,
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackText,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  _buildContactButton(
                    icon: AppAssets.phoneCall,
                    color: AppColors.primary,
                    bgColor: AppColors.primary.withOpacity(0.1),
                    onTap:
                        () => PhoneCallBottomSheet.show(
                          phoneNumbers: [mobile, whatsapp],
                        ),
                  ),
                  8.width,
                  _buildContactButton(
                    icon: AppAssets.whatsapp,
                    color: const Color(0xff25D366),
                    bgColor: const Color(0xff25D366).withOpacity(0.1),
                    onTap: () async {
                      final url = Uri.parse("https://wa.me/$whatsapp");
                      if (await canLaunchUrl(url)) {
                        launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                  ),
                  8.width,
                  _buildContactButton(
                    icon: AppAssets.location2,
                    color: const Color(0xffE53935),
                    bgColor: const Color(0xffE53935).withOpacity(0.1),
                    onTap: () async {
                      final url = Uri.parse(mapUrl);
                      if (await canLaunchUrl(url)) {
                        launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          8.height,
          Divider(color: Colors.grey.shade100),
          // Name row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appSvgImage(
                AppAssets.profile,
                color: AppColors.grayText.withOpacity(0.5),
                height: 18.sp,
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'the_name'.tr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.grayText,
                      ),
                    ),
                    4.height,
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.height,
          // Address row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appSvgImage(
                AppAssets.location2,
                color: AppColors.grayText.withOpacity(0.5),
                height: 16.sp,
              ),
              16.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'the_address'.tr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.grayText,
                      ),
                    ),
                    4.height,
                    Text(
                      address,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ──────────────────── TOTAL AMOUNT ────────────────────
  Widget _buildTotalAmountSection(int total) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Row(
                children: [
                  appSvgImage(AppAssets.money, height: 18.sp),
                  8.width,
                  Text(
                    'total_amount'.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackText,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '$total',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              6.width,
              Text(
                '₪',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          14.height,
          // Collect from delivery button
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grayText.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                'collect_from_delivery'.tr,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────── PRODUCTS ────────────────────
  Widget _buildProductsSection(List<dynamic> products) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              appSvgImage(AppAssets.products, height: 20.sp),
              8.width,
              Text(
                'products'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackText,
                ),
              ),
            ],
          ),
          12.height,
          Divider(height: 1, color: Colors.grey.shade200),
          ...products
              .map(
                (p) => Column(
                  children: [
                    _buildProductItem(
                      p['product_name'] ?? 'product',
                      'x${p['quantity'] ?? 1}',
                    ),
                  ],
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildProductItem(String name, String quantity) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Color(0xffF9FAFB),
      ),
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            quantity,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.grayText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────── NOTES ────────────────────
  Widget _buildNotesSection(String notes) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              appSvgImage(
                AppAssets.products,
                height: 20.sp,
              ), // Need note icon asset if exists
              8.width,
              Text(
                'notes'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackText,
                ),
              ),
            ],
          ),
          12.height,
          Divider(height: 1, color: Colors.grey.shade200),
          12.height,
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              notes,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.blackText,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────── TRACKING LOG ────────────────────
  Widget _buildTrackingLog(List<TrackingLog> logs) {
    final controller = Get.find<ScannerController>();

    return Obx(() {
      final isExpanded = controller.isTrackingExpanded.value;

      return GestureDetector(
        onTap: () => controller.isTrackingExpanded.toggle(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.all(16.w),
          decoration: _cardDecoration(),
          child: Column(
            children: [
              // Header row
              Row(
                children: [
                  appSvgImage(AppAssets.tracking, height: 20.sp),
                  8.width,
                  Text(
                    'tracking_log'.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackText,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.grayText,
                      size: 22.sp,
                    ),
                  ),
                ],
              ),

              // Expanded timeline content
              if (isExpanded) ...[
                12.height,
                Divider(height: 1, color: Colors.grey.shade200),
                12.height,
                ...List.generate(logs.length, (index) {
                  final log = logs[index];
                  final isLast = index == logs.length - 1;

                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Timeline column (dot + line)
                        SizedBox(
                          width: 20.w,
                          child: Column(
                            children: [
                              Container(
                                width: 12.w,
                                height: 12.w,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 2.w,
                                    color: AppColors.primary.withOpacity(0.3),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        12.width,
                        // Content column
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  log.title,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackText,
                                  ),
                                ),
                                4.height,
                                Text(
                                  log.createdAt,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.grayText,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      );
    });
  }

  // ──────────────────── HELPERS ────────────────────
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildPrintButton(String printUrl) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        bottom: 20.h,
        top: 16.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 4,
            blurStyle: BlurStyle.normal,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Print button
          Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  if (printUrl.isNotEmpty) {
                    final url = Uri.parse(printUrl);
                    try {
                      await Printing.layoutPdf(
                        onLayout: (format) async {
                          final request = await HttpClient().getUrl(url);
                          final response = await request.close();
                          return await consolidateHttpClientResponseBytes(
                            response,
                          );
                        },
                      );
                    } catch (e) {
                      debugPrint('Error printing url: $e');
                    }
                  }
                },
                borderRadius: BorderRadius.circular(14.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    appSvgImage(
                      AppAssets.printIcon,
                      color: Colors.white,
                      height: 22.sp,
                    ),
                    10.width,
                    Text(
                      'print_policy'.tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          8.height,
          // Warning note
          Text(
            'note_warning'.tr,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.grayText,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
