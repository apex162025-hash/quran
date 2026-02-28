import 'package:get/get.dart';

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    // #------------------------ English ------------------------# //
    'en_US': {
      'hello': 'Hello',
      'welcome': 'Welcome to our app!',
      'change_lang': 'Change Language',
      'app_name': 'Quran App',
      'splash_subtitle': 'Read & Listen to the Holy Quran',
      'Juz': 'Juz',
      'Sajda': 'Sajda',
      'Page': 'Page',
    },

    // #------------------------- Arabic -----------------------# //
    'ar_SA': {
      'hello': 'مرحبًا',
      'welcome': 'مرحبًا بك في تطبيقنا!',
      'change_lang': 'تغيير اللغة',
      'app_name': 'القرآن الكريم',
      'splash_subtitle': 'اقرأ واستمع إلى القرآن الكريم',
      'Juz': 'الجزء',
      'Sajda': 'سجدة',
      'Page': 'صفحة',
    },
  };
}
