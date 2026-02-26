import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


mixin ImageHelper {
  Widget imageBox({
    required double size,
    BoxShape shape = BoxShape.circle,
    required Widget child,
  }) {
    return Container(
      height: size.h,
      width: size.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: shape,
      ),
      child: child,
    );
  }

  Widget appSvgImage(
    String path, {
    Color? color,
    double? width,
    double? height,
    bool fullPath = false,
    BoxFit fit = BoxFit.contain,
    Widget? placeholderBuilder,
    bool network = false,
    double opacity = 1,
  }) {
    /// Path => folder/name
    return Opacity(
      opacity: opacity,
      child: !network
          ? SvgPicture.asset(
              path,
              width: width,
              height: height,
              // ignore: deprecated_member_use
              color: color,
              // colorFilter: color != null
              //     ? ColorFilter.mode(
              //         color,
              //         BlendMode.srcIn,
              //       )
              //     : null,
              fit: fit,
              // placeholderBuilder: (context) => placeholderBuilder ?? errorImageBuilder,
            )
          : SvgPicture.network(
              path,
              width: width,
              height: height,
              // ignore: deprecated_member_use
              color: color,
              fit: fit,
            ),
    );
  }

  Widget appCachedImage(
    String? image, {
    double? width = double.infinity,
    BoxFit? fit = BoxFit.contain,
    double? height,
    Color? color,
    Alignment? alignment = Alignment.topRight,
  }) {
    return CachedNetworkImage(
      alignment: alignment ?? Alignment.topRight,
      imageUrl: image ?? '',
      width: width,
      fit: fit,
      height: height,
      color: color,
      errorWidget: (context, url, error) => errorImageBuilder,
    );
  }

  Widget get errorImageBuilder {
    return Padding(
      padding: EdgeInsets.all(6.h),
      child: appSvgImage(appLogo(),
          fit: BoxFit.contain,
          fullPath: true,
          color: Colors.grey.shade200,
          height: 40,
          width: 40),
    );
  }

  String appLogo() => 'assets/icons/default_icon.svg';
}
