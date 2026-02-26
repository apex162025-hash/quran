import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:tordoo_qr/core/extensions/sized_box_extension.dart';

// Restoring the imports based on your project structure
import '../../../core/constance/app_assets.dart';
import '../../../core/helpers/image_helper.dart';

typedef CounterCallBack = Function(String _);

class MyTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? prefixIcon;
  final String? labelText;
  final Color? prefixIconColor;
  final Widget? suffixIcon;
  final TextInputType inputType;
  final double topPadding;
  final double bottomPadding;
  final double horizontalPadding;
  final String? hint;
  final TextInputAction? inputAction;
  final Function(String)? onSubmitted;
  final int maxLines;
  final Function(String)? onChanged;
  final bool allowLetters;
  final Color? fillColor;
  final bool dottedBorder;
  final TextAlign textAlign;
  final bool showFocusBorder;
  final bool? obscure;
  final double? radius;
  final double endSuffixPadding;
  final CounterCallBack? counterCallBack;
  final bool hasBorder;
  final int? minLines;
  final TextDirection? hintTextDirection;
  final bool? enabled;
  final Color? textcolor;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Color hintColor;

  const MyTextField({
    this.labelText = "",
    this.controller,
    this.prefixIcon,
    this.prefixIconColor,
    this.validator,
    this.suffixIcon,
    this.inputType = TextInputType.text,
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.horizontalPadding = 0,
    this.hint,
    this.hintColor = const Color(0xff6C6C89),
    this.hintTextDirection,
    this.inputAction,
    this.onSubmitted,
    this.maxLines = 1,
    this.onChanged,
    this.minLines,
    this.allowLetters = true,
    this.fillColor,
    this.dottedBorder = false,
    this.textAlign = TextAlign.start,
    this.showFocusBorder = true,
    this.obscure,
    this.radius,
    this.endSuffixPadding = 12,
    this.counterCallBack,
    this.hasBorder = true,
    super.key,
    this.enabled = true,
    this.textcolor,
    this.inputFormatters,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> with ImageHelper {
  final FocusNode _focus = FocusNode();

  bool get _noLong => widget.maxLines == 1;

  final Color _grey = const Color(0xffD1D1DB);
  final Color _errorColor = const Color(0xFFD32F2F);

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() => setState(() => focused = _focus.hasFocus);

  bool focused = false;

  late bool _obscure = widget.obscure ?? false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: widget.bottomPadding.h,
        top: widget.topPadding.h,
        right: widget.horizontalPadding.w,
        left: widget.horizontalPadding.w,
      ),
      child:
      widget.dottedBorder
          ? DottedBorder(
        dashPattern: const [6, 4],
        borderType: BorderType.RRect,
        color: focused ? Theme.of(context).primaryColor : _grey,
        strokeWidth: 1.w,
        radius: Radius.circular(8.r),
        padding: EdgeInsets.zero,
        child: _body,
      )
          : _body,
    );
  }

  Widget get _body => Container(
    padding: EdgeInsets.zero,
    margin: EdgeInsets.zero,
    // Removed fixed height to allow error message expansion
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: TextFormField(
            validator: widget.validator,
            enabled: widget.enabled ?? true,
            scrollPadding: EdgeInsets.zero,
            controller: widget.controller,
            focusNode: _focus,
            obscureText: _obscure,
            onChanged: widget.onChanged,
            cursorColor: Theme.of(context).primaryColor,
            cursorHeight: _noLong ? null : 0,
            textInputAction: widget.inputAction,
            onFieldSubmitted: widget.onSubmitted,
            style: TextStyle(
              fontSize: 14.sp,
              color: widget.textcolor,
              letterSpacing: _obscure ? 2 : null,
            ),
            keyboardType: widget.inputType,
            maxLines: widget.maxLines,
            minLines: widget.minLines ?? 1,
            textDirection: widget.hintTextDirection,
            inputFormatters:
            widget.inputFormatters ??
                (widget.allowLetters
                    ? []
                    : [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'(^\d*\.?\d{0,2})'),
                  ),
                ]),
            textAlign: widget.textAlign,
            decoration: InputDecoration(
              filled: widget.fillColor != null,
              fillColor: widget.fillColor ?? Colors.white,
              hintText: widget.hint,
              hintTextDirection: widget.hintTextDirection,
              hintStyle: TextStyle(
                color: widget.hintColor,
                fontSize: 14.sp,
                letterSpacing: _obscure ? 2 : null,
              ),
              prefixIconConstraints:
              widget.prefixIcon != null ? null : const BoxConstraints(),
              suffixIconConstraints: const BoxConstraints(),
              suffixIcon: Padding(
                padding: EdgeInsetsDirectional.only(
                  end: widget.endSuffixPadding.w,
                ),
                child:
                widget.obscure != null
                    ? _obscureSwitch
                    : _countChanger ?? widget.suffixIcon,
              ),
              suffixIconColor: WidgetStateColor.resolveWith(
                    (states) =>
                states.contains(WidgetState.focused)
                    ? Theme.of(context).primaryColor
                    : const Color(0xffC9C9C9),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 12.h,
              ),
              // Use the unified border builder with specific colors for each state
              enabledBorder: _buildOutlineInputBorder(color: _grey),
              focusedBorder: _buildOutlineInputBorder(
                color: Theme.of(context).primaryColor,
              ),
              errorBorder: _buildOutlineInputBorder(color: _errorColor),
              focusedErrorBorder: _buildOutlineInputBorder(color: _errorColor),
            ),
          ),
        ),
      ],
    ),
  );

  Widget get _obscureSwitch {
    return InkWell(
      onTap: () => setState(() => _obscure = !_obscure),
      child: appSvgImage(
        AppAssets.eyeIcon,
        color:
        !_obscure
            ? Theme.of(context).primaryColor
            : const Color(0xffC9C9C9),
      ),
    );
  }

  // Helper method to create a consistent border style with variable color
  OutlineInputBorder _buildOutlineInputBorder({required Color color}) {
    // Increased default radius to 12.r to match the softer look in the image
    final double radius = widget.radius ?? 12.r;

    if (!widget.hasBorder || widget.dottedBorder) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide.none,
      );
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(
        color: color,
        width: 1.0.w, // Keep width consistent
      ),
    );
  }

  Widget? get _countChanger {
    if (widget.counterCallBack == null) return null;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_counterButton(true), 3.height, _counterButton(false)],
    );
  }

  Widget _counterButton(bool plus) {
    if (widget.controller == null) return empty;

    return InkWell(
      onTap: () {
        setState(() {
          int count = int.parse(widget.controller!.text);

          if (plus) {
            String s = (++count).toString();
            widget.counterCallBack!(s);
          } else {
            if (count > 1) {
              String m = (--count).toString();
              widget.counterCallBack!(m);
            }
          }
        });
      },
      child: Container(
        width: 18.w,
        height: 12.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(.5),
          borderRadius: BorderRadius.circular(2.r),
        ),
        child: Icon(
          plus ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          size: 14.w,
          color: Colors.black,
        ),
      ),
    );
  }
}