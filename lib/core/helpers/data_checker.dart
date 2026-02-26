import 'package:get/get.dart';

import '../enums/enums.dart';
import '../utils/utils.dart';

mixin DataCheckerHelper {
  bool checkText({
    required String text,
    bool isEmpty = true,
    bool email = false,
    bool mobile = false,
    int? minLength,
    required String errorMessage,
    double? b,
  }) {
    if (text.isEmpty) {
      error(errorMessage.tr, b);
      return false;
    } else if (minLength != null && text.length < minLength) {
      error(errorMessage.tr, b);
      return false;
    } else if (email && !_checkEmail(text)) {
      error("email_invalid".tr, b);
      return false;
    } else if (mobile && (text.length < 6)) {
      error("phone_error_min_length".trParams({'min': '6'}), b);
      return false;
    }
    return true;
  }

  bool checkTextsMatch({
    required String text1,
    required String text2,
    required String errorMessage,
    double? b,
  }) {
    if (text1 == text2) {
      return true;
    } else {
      error(errorMessage.tr, b);
      return false;
    }
  }

  bool checkObject({
    required dynamic object,
    required String message,
    double? b,
  }) {
    if (object == null) {
      error(message.tr, b);
      return false;
    }

    return true;
  }

  bool checkBool({required bool item, required String message, double? b}) {
    if (!item) {
      error(message.tr, b);
      return false;
    }

    return true;
  }

  bool checkList({
    required List<dynamic> list,
    required String message,
    double? b,
  }) {
    if (list.isEmpty) {
      error(message.tr, b);
      return false;
    }

    return true;
  }

  bool _checkEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  bool otpChecker({required String text, int length = 4, double? b}) {
    if (text.length != length) {
      error("enter_otp_code".tr, b);
      return false;
    }

    return true;
  }

  void error(String errorMessage, double? bottom) {
    Utils.getSnakBar(message: errorMessage, type: TosterTypes.warning);
  }
}
