import 'package:flutter/material.dart';

class SuccessSnackContent extends StatelessWidget {
  final String text;
  const SuccessSnackContent({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    const Color green = Color(0xFF2E8B57);
    const Color greenDark = Color(0xFF25714A);

    return Container(
      decoration: BoxDecoration(
        color: green,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 18,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),

          Positioned(
            right: 10,
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: greenDark,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
