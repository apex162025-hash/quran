import 'package:get/get.dart';

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {

    // #------------------------ English ------------------------# //
    'en_US': {
      'hello': 'Hello',
      'welcome': 'Welcome to our app!',
      'change_lang': 'Change Language',
    },

    // #------------------------- Arabic -----------------------# //
    'ar_SA': {
      'hello': 'مرحبًا',
      'welcome': 'مرحبًا بك في تطبيقنا!',
      'change_lang': 'تغيير اللغة',
    },
  };
}
