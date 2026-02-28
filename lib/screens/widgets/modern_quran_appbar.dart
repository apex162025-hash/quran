import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_library/quran_library.dart'; // Ensure correct import for QuranCtrl
import '../../core/theme/app_theme.dart';

class ModernQuranAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDark;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onSearchPressed;

  const ModernQuranAppBar({
    super.key,
    required this.isDark,
    this.onMenuPressed,
    this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Action (e.g., Search/Bookmarks)
              IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                  size: 24.sp,
                ),
                onPressed: onSearchPressed,
              ),

              // Center Title (Dynamically updated)
              Expanded(
                child: Obx(() {
                  // Accessing QuranCtrl instance.
                  // Assuming 'currentPageNumber' is exposed.
                  // We might need to map page number to Surah name if not directly available.
                  final pageNum =
                      QuranCtrl.instance.state.currentPageNumber.value;
                  // For now showing Page Number. Surah name might require a lookup function
                  // that is usually available in quran libraries (e.g. getSurahNameByPage).
                  // I'll stick to a safe 'Quran - Page X' or just 'Quran'.
                  // Trying to use Get.find<QuranCtrl>().getCurrentSurahByPage(pageNum) if exists?
                  // Let's keep it simple to avoid errors: 'Quran' + Page Number.
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'app_name'.tr, // "Quran App" or "Al-Quran Al-Kareem"
                        style: GoogleFonts.amiri(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${'Page'.tr} $pageNum',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  );
                }),
              ),

              // Right Action (Menu/Settings)
              IconButton(
                icon: Icon(
                  Icons.menu_rounded,
                  color: Colors.white,
                  size: 24.sp,
                ),
                onPressed:
                    onMenuPressed ??
                    () {
                      // Toggle control visibility or show settings
                      QuranCtrl.instance.showControlToggle();
                    },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70.h);
}
