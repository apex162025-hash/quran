import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive helper for handling different screen sizes
/// Mobile: < 600dp
/// Tablet: 600dp - 1024dp
/// Desktop: > 1024dp
class ResponsiveHelper {
  // Screen type checks
  static bool isMobile(BuildContext context) => ScreenUtil().screenWidth < 600;

  static bool isTablet(BuildContext context) =>
      ScreenUtil().screenWidth >= 600 && ScreenUtil().screenWidth < 1024;

  static bool isDesktop(BuildContext context) =>
      ScreenUtil().screenWidth >= 1024;

  // Get responsive value based on screen size
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  // Responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: isMobile(context) ? 16.w : 32.w,
      vertical: isMobile(context) ? 14.h : 24.h,
    );
  }

  // Responsive horizontal padding only
  static EdgeInsets responsiveHorizontalPadding(BuildContext context) {
    return EdgeInsets.symmetric(horizontal: isMobile(context) ? 16.w : 32.w);
  }

  // Responsive grid columns
  static int gridColumns(
    BuildContext context, {
    int mobile = 2,
    int tablet = 3,
    int desktop = 4,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  // Responsive font size multiplier
  static double fontSizeMultiplier(BuildContext context) {
    if (isDesktop(context)) return 1.2;
    if (isTablet(context)) return 1.1;
    return 1.0;
  }

  // Responsive spacing
  static double spacing(BuildContext context, double mobileSpacing) {
    return isMobile(context) ? mobileSpacing : mobileSpacing * 1.5;
  }

  // Get max content width (useful for centering content on large screens)
  static double maxContentWidth(BuildContext context) {
    if (isDesktop(context)) return 1200;
    if (isTablet(context)) return 800;
    return double.infinity;
  }

  // Responsive dialog width
  static double dialogWidth(BuildContext context) {
    final screenWidth = ScreenUtil().screenWidth;
    if (isDesktop(context)) return screenWidth * 0.4;
    if (isTablet(context)) return screenWidth * 0.6;
    return screenWidth * 0.9;
  }

  // Check if landscape
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Get responsive bottom sheet height
  static double bottomSheetHeight(BuildContext context) {
    final screenHeight = ScreenUtil().screenHeight;
    if (isTablet(context)) return screenHeight * 0.7;
    return screenHeight * 0.9;
  }

  // Grid cross-axis count for lists
  static int listGridColumns(BuildContext context) {
    if (isDesktop(context)) return 3;
    if (isTablet(context)) return 2;
    return 1; // Mobile uses single column
  }

  // Card aspect ratio for grids
  static double cardAspectRatio(BuildContext context) {
    if (isTablet(context)) return 1.1;
    return 1.4;
  }

  // Form max width for centered layouts
  static double formMaxWidth(BuildContext context) {
    if (isDesktop(context)) return 600;
    if (isTablet(context)) return 500;
    return double.infinity;
  }

  // Get responsive value with custom mobile/tablet values
  static double responsiveValue(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  // Horizontal padding for content
  static double horizontalPadding(BuildContext context) {
    if (isDesktop(context)) return 48;
    if (isTablet(context)) return 32;
    return 20;
  }

  // Card padding
  static EdgeInsets cardPadding(BuildContext context) {
    if (isTablet(context)) {
      return EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h);
    }
    return EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h);
  }
}

/// Responsive widget wrapper for different layouts
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context) && desktop != null) {
      return desktop!;
    }
    if (ResponsiveHelper.isTablet(context) && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

/// Centered content container with max width for large screens
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContainer({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.maxContentWidth(context),
        ),
        padding: padding ?? ResponsiveHelper.responsivePadding(context),
        child: child,
      ),
    );
  }
}
