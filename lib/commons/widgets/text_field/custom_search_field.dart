import 'package:flutter/material.dart';
import 'package:test_project/commons/widgets/text_field/search_text_field.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilterTap;
  final String? hint;

  final Color? fillColor;
  final double? searchIconWidth;
  final double? searchIconHeight;

  const CustomSearchField({
    super.key,
    required this.controller,
    required this.onFilterTap,
    this.hint,
    this.fillColor,
    this.searchIconWidth,
    this.searchIconHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchTextField(
            controller: controller,
            hint: hint,
            fillColor: fillColor,
            searchIconWidth: searchIconWidth,
            searchIconHeight: searchIconHeight,
            onFilterTap: onFilterTap,
          ),
        ),
      ],
    );
  }
}
