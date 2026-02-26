import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../extensions/sized_box_extension.dart';
import 'image_helper.dart';

mixin AlertDialogsHelper on ImageHelper {
  void appAlertDialog(
    BuildContext context, {
    required String title,
    bool barrierDismissible = true,
    bool showClose = true,
    String? filledText,
    Widget? up,
    Widget? down,
    bool? loading,
    required Function() filledAction,
    String? unfilledText,
    required Function() unfilledAction,
    bool reversed = false,
  }) {
    List<Widget> list = [
      MyAlertButton(
        text: "تأكيد",
        filled: true,
        action: filledAction,
        loading: loading ?? false,
      ),
      SizedBox(width: 20.w),
      MyAlertButton(
        text: "لا",
        filled: false,
        action: unfilledAction,
      ),
    ];

    if (reversed) {
      list = list.reversed.toList();
    }
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: Column(
                          children: [
                            showClose
                                ? Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [_close(context)],
                                      ),
                                      10.height,
                                    ],
                                  )
                                : empty,
                            up ?? empty,
                            Text(
                              title,
                              style: TextStyle(
                                color: const Color(0xff303030),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            down ?? 30.height,
                            Row(children: list),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void alertDialogTemplate(
    BuildContext context, {
    required Widget body,
    Clip clip = Clip.antiAlias,
    bool barrierDismissible = true,
    bool showClose = true,
    Color? backgroundColor,
    Function()? close,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          clipBehavior: clip,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: backgroundColor ??
                    Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Column(
                      children: [
                        showClose
                            ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [_close(context, close: close)],
                                  ),
                                  10.height,
                                ],
                              )
                            : empty,
                        body,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void statusAlertDialog(
    BuildContext context, {
    required String title,
    required String subtitle,
    bool status = true,
    Widget? image,
    dynamic Function()? close,
  }) {
    alertDialogTemplate(
      close: close,
      context,
      body: Column(
        children: [
          image ?? appSvgImage('icons/status_true_icon', height: 60.h),
          20.height,
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          13.height,
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> modalSheetTemplate(
    BuildContext context, {
    required Widget body,
    double topPadding = 15,
    double bottomPadding = 30,
    double hPadding = 20,
    bool expanded = true,
    bool scrollControlled = false,
    bool full = false,
    double radius = 25,
    bool notch = true,
    bool showClose = true,
    Function()? close,
  }) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: scrollControlled,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius.r),
          topRight: Radius.circular(radius.r),
        ),
        side: BorderSide.none,
      ),
      builder: (context) {
        return SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: scrollControlled && !full
              ? (MediaQuery.sizeOf(context).height / 1.5)
              : null,
          child: Padding(
            padding: EdgeInsets.only(
              top: topPadding.h,
              bottom: bottomPadding.h,
              right: hPadding.w,
              left: hPadding.w,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                showClose
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [_close(context, close: close)],
                          ),
                          5.height,
                        ],
                      )
                    : empty,
                notch
                    ? Column(
                        children: [
                          Container(
                            height: 6.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              color: const Color(0xffECECEC),
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                          ),
                          10.height,
                        ],
                      )
                    : empty,
                expanded ? Expanded(child: body) : body,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _close(BuildContext context, {Function()? close}) => InkWell(
        onTap: close ?? () => Navigator.pop(context),
        child: CircleAvatar(
          radius: 13.h,
          backgroundColor: const Color(0xffF8F8F8),
          child: Icon(
            Icons.close,
            color: const Color(0xff515251),
            size: 18.h,
          ),
        ),
      );
}


class MyAlertButton extends StatelessWidget  {
  final String text;
  final bool filled;
  final Function() action;
  final double height;
  final bool loading;

  const MyAlertButton({
    required this.text,
    required this.filled,
    required this.action,
    this.height = 45,
    this.loading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: action,
        child: Container(
          height: height.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: filled
                ? Theme.of(context).primaryColor
                : const Color(0xffF7F7F7),
            borderRadius: BorderRadius.circular(50.r),

          ),
          child: !loading
              ? Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              color:
              filled ? Colors.white : null,
              fontWeight: FontWeight.w500,
              height: 1.h,
            ),
          )
              : CircularProgressIndicator(
              color:
              filled ? Colors.white : Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
