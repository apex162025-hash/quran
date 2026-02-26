import 'package:flutter/material.dart';
import 'package:quran_library/quran_library.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: QuranLibraryScreen(
        parentContext: context,
        withPageView: true,
        useDefaultAppBar: true,
        isShowAudioSlider: true,
        showAyahBookmarkedIcon: false,
        isDark: isDark,
        backgroundColor: Theme.of(context,).cardColor,
      ),
    );
  }
}
