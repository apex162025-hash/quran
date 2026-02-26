import 'package:intl/intl.dart';

extension TimeFormatter on String {
  String toFormattedTime() {
    try {
      DateTime dateTime = DateTime.parse(this);
      return DateFormat.jm().format(dateTime);
    } catch (e) {
      return "Invalid Date";
    }
  }
}

extension DateFormatter on String {
  String toFormattedDate() {
    try {
      DateTime dateTime = DateTime.parse(this);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return "Invalid Date";
    }
  }
}
