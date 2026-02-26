import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tordoo_qr/core/extensions/sized_box_extension.dart';
import '../../../core/helpers/countries.dart';

class PhoneTextField extends StatefulWidget {
  final TextEditingController controller;
  final List<AppIntlCountry> countriesList;
  final Color? fillColor;
  final AppIntlCountry? initialCountry;
  final FormFieldValidator<String>? validator;
  final ValueChanged<AppIntlCountry>? onCountryChanged;

  const PhoneTextField({
    super.key,
    required this.controller,
    required this.countriesList,
    this.fillColor,
    this.initialCountry = const AppIntlCountry(
  name: "Palestine",
  nameAr: "فلسطين",
  flag: "🇵🇸",
  code: "PS",
  dialCode: "970",
  minLength: 9,
  maxLength: 9,
  ),
    this.validator,
    this.onCountryChanged,
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  late AppIntlCountry _selectedCountry;

  final TextEditingController searchEditingController = TextEditingController();
  List<AppIntlCountry> searchedCountries = [];

  // ✅ Track validation state
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _selectedCountry =
        widget.initialCountry ??
            (widget.countriesList.isNotEmpty
                ? const AppIntlCountry(
              name: "Palestine",
              nameAr: "فلسطين",
              flag: "🇵🇸",
              code: "PS",
              dialCode: "970",
              minLength: 9,
              maxLength: 9,
            )
                : const AppIntlCountry(
              name: "Palestine",
              nameAr: "فلسطين",
              flag: "🇵🇸",
              code: "PS",
              dialCode: "970",
              minLength: 9,
              maxLength: 9,
            ));

    _selectedCountry = widget.countriesList.firstWhere(
          (c) => c.dialCode == "970",
      orElse: () => widget.countriesList.isNotEmpty
          ? const AppIntlCountry(
        name: "Palestine",
        nameAr: "فلسطين",
        flag: "🇵🇸",
        code: "PS",
        dialCode: "970",
        minLength: 9,
        maxLength: 9,
      )
          : _selectedCountry,
    );

    searchedCountries = List.from(widget.countriesList);
  }

  /// ✅ UPDATED: Validation with minimum 7 digits requirement
  String? _defaultValidator(String? value) {
    final v = (value ?? '').replaceAll(RegExp(r'\s+'), '');

    if (v.isEmpty) {
      return 'phone_error_required'.tr;
    }

    if (!RegExp(r'^\d+$').hasMatch(v)) {
      return 'phone_error_digits_only'.tr;
    }

    // ✅ Minimum 7 digits requirement
    const int minRequired = 7;

    if (v.length < minRequired) {
      return 'phone_error_min_length'.trParams({'min': minRequired.toString()});
    }

    if (v.length > _selectedCountry.maxLength) {
      return 'phone_error_max_length'.trParams({
        'max': _selectedCountry.maxLength.toString(),
      });
    }

    return null;
  }

  Widget _flagImage(String code, {double width = 30}) {
    return Container(
      padding: EdgeInsets.zero,
      height: width.h,
      width: width.w,
      decoration: BoxDecoration(
        color: const Color(0xffF3F3F3),
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(
            'assets/flags/${code.toLowerCase()}.png',
            package: 'intl_phone_field',
          ),
          onError: (exception, stackTrace) {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double fieldHeight = 47.h;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: fieldHeight,
              decoration: BoxDecoration(
                color:  widget.fillColor ?? Colors.white ,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: _errorMessage != null
                      ? const Color(0xFFD32F2F)
                      : const Color(0xFFD1D1DB),
                  width: _errorMessage != null ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  // Country Code Selector
                  GestureDetector(
                    onTap: () => showCountries(context),
                    child: Container(
                      height: fieldHeight,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.0.w,
                        vertical: 8.0.h,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _flagImage(_selectedCountry.code, width: 24.w),
                          7.w.width,
                          Text(
                            "+${_selectedCountry.dialCode}",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff6C6C89),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ✅ UPDATED: Phone Number Input with improved styling
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.w),
                      child: TextFormField(
                        controller: widget.controller,
                        textInputAction: TextInputAction.done,
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        cursorColor: Theme.of(context).primaryColor,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xff1F2024),
                        ),
                        // ✅ UPDATED: Enhanced validator
                        validator: (value) {
                          final error = widget.validator != null
                              ? widget.validator!.call(value)
                              : _defaultValidator(value);

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() {
                                _errorMessage = error;
                              });
                            }
                          });

                          return error;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                        ],
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "555 621 526",
                          hintStyle: TextStyle(
                            color: const Color(0xff6C6C89),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          fillColor: widget.fillColor?? const Color(0xffEBEBEF),
                          // ✅ UPDATED: Matching _CustomTextFormField styling
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          // ✅ Hide default error text (we show it manually)
                          errorStyle: const TextStyle(height: 0, fontSize: 0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Error Message - Respects app language direction (RTL/LTR)
            if (_errorMessage != null)
              Directionality(
                textDirection: Directionality.of(context),
                child: Padding(
                  padding: EdgeInsets.only(top: 6.h, left: 12.w, right: 12.w),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFFD32F2F), // Material error red
                      height: 1.2,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showCountries(BuildContext context) {
    searchEditingController.clear();
    searchedCountries = List.from(widget.countriesList);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height - 130,
          child: StatefulBuilder(
            builder: (context, myState) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    15.height,
                    MySearchField(
                      controller: searchEditingController,
                      onChanged: (searchText) {
                        myState(() {
                          if (searchText.isEmpty) {
                            searchedCountries = List.from(widget.countriesList);
                          } else {
                            searchedCountries = widget.countriesList.where((
                                country,
                                ) {
                              return country.name.toLowerCase().contains(
                                searchText.toLowerCase(),
                              ) ||
                                  country.nameAr.contains(searchText) ||
                                  country.dialCode.contains(searchText);
                            }).toList();
                          }
                        });
                      },
                    ),
                    15.height,
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children: searchedCountries
                            .map(
                              (country_) => countryDetails(country_, myState),
                        )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget countryDetails(AppIntlCountry country, StateSetter myState) {
    final isEnglish = Get.locale?.languageCode == 'en';
    final countryName = isEnglish ? country.name : country.nameAr;

    return InkWell(
      onTap: () {
        setState(() => _selectedCountry = country);
        widget.onCountryChanged?.call(country);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5)),
        ),
        child: Row(
          children: [
            _flagImage(country.code, width: 36),
            const SizedBox(width: 12),
            Text(
              country.dialCode,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xff333333),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                countryName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff333333),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MySearchField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Color? fillColor;

  const MySearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.fillColor
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: "search".tr,
        hintStyle: const TextStyle(color: Color(0xff6C6C89)),
        prefixIcon: const Icon(Icons.search, color: Color(0xff6C6C89)),
        filled: true,
        fillColor: fillColor?? const Color(0xffF9F9F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: const Color(0xff5D5D5D).withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: const Color(0xff5D5D5D).withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor.withOpacity(0.6),
            width: 1.2,
          ),
        ),
      ),
    );
  }
}
