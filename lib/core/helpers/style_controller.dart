
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../enums/enums.dart';
import '../local/cache_controller.dart';


Color mainTextBlackColor_ = const Color(0xff10275A);
Color mainTextGreyColor_ = const Color(0xffA0A0A0);
Color mainBackgroundColor_ = const Color(0xffC3C8DF);

class StyleGetxController extends GetxController {
  /// Main Screen Index
  int _mainIndex = 0;

  int get index => _mainIndex;

  set index(int i) => [_mainIndex = i, update()];

  /// App Font Family
  String get appFontFamily => 'DIN';

  /// Theme
  int theme_ = CacheController().getter(key: CacheKeys.theme) ?? -1;

  Future<void> changeTheme_() async {
    theme_ = theme_ == 1 ? 0 : 1;
    initColors();
    update();
  }

  void initColors() {
    mainTextBlackColor = theme_ == 1 ? mainTextBlackColor_ : Colors.white;
    mainTextWhiteColor = theme_ == 1 ? Colors.white : mainTextBlackColor_;
    mainTextGreyColor = theme_ == 1 ? mainTextGreyColor_ : Colors.white;
    mainBackgroundColor = theme_ == 1 ? Colors.white : mainBackgroundColor_;
  }

  late Color mainTextBlackColor;
  late Color mainTextWhiteColor;
  late Color mainTextGreyColor;
  late Color mainBackgroundColor;
}
