
import 'package:flutter/material.dart';


class RoundedContainer extends StatelessWidget {
  const RoundedContainer({
    super.key,
    this.width,
    this.height,
    this.radius = 8,
    this.child,
    this.showBorder = false,
    this.borderColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.margin,
    this.padding,
  });

  final double? width, height;
  final double radius;
  final Widget? child;
  final bool showBorder;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius),
          border: showBorder? Border.all(color: borderColor):null
      ),
      child: child,
    );
  }
}