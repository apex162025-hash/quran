import 'package:flutter/material.dart';

mixin StylesHelper {
  BoxShadow appBoxShadow(BuildContext context) {
    return BoxShadow(
      color: const Color(0xffE8E8F7).withOpacity(.3),
      offset: const Offset(0, 3),
      // spreadRadius: 1.5,
      blurRadius: 14,
    );
  }

  List<BoxShadow> appElevation({double opacity = .07}) {
    return [
      BoxShadow(
        color: const Color(0xffEFA5AB).withOpacity(opacity),
        offset: const Offset(0, -3),
        blurRadius: 16,
      ),
    ];
  }

  List<Color> secondaryGradientColors2(BuildContext context) => [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.surface,
      ];
  LinearGradient appLinearGradient(
    BuildContext context, {
    double opacity = 1,
    Axis axis = Axis.vertical,
    List<Color>? colors,
  }) {
    List<Color>? c = colors;
    if (c != null) {
      c = c.map((e) => e.withOpacity(opacity)).toList();
    }
    return LinearGradient(
      begin: axis == Axis.vertical
          ? AlignmentDirectional.topCenter
          : AlignmentDirectional.centerEnd,
      end: axis == Axis.vertical
          ? AlignmentDirectional.bottomCenter
          : AlignmentDirectional.centerStart,
      colors: c ??
          [
            Theme.of(context).primaryColor.withOpacity(opacity),
            Theme.of(context).colorScheme.secondary.withOpacity(opacity),
          ],
    );
  }

  List<Color> get secondaryGradientColors => [
        const Color(0xffFDF3F6),
        const Color(0xffEEFBF5),
      ];

  Color convertHexadecimalStringToColor({required String hexadecimal}) {
    String newHexadecimal = hexadecimal.substring(1);
    int newIntHexadecimal = int.parse('0xff$newHexadecimal');
    Color colorToSend = Color(newIntHexadecimal);
    return colorToSend;
  }

  Color sessionDelayStatusColor(BuildContext context, String status) {
    switch (status) {
      case 'NEW':
        return Theme.of(context).canvasColor;
      case 'COMPLETED':
        return Theme.of(context).primaryColor;
      case 'CANCELED':
        return const Color(0xffCB3E1E);
    }

    return Colors.black;
  }
}
