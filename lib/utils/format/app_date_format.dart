import 'package:intl/intl.dart';

class AppDateFormat {
  static DateFormat appDateFormat(String local) {
    return DateFormat.yMMMMEEEEd(local);
  }

  static String formattingDate(DateTime date, String local) {
    return appDateFormat(local).format(date);
  }

  static String tryFormattingDate(DateTime? date, String local) {
    try {
      return appDateFormat(local).format(date!);
    } catch (e) {
      return "";
    }
  }

  static String formattingTime(DateTime date, String local) {
    return DateFormat.jm(local).format(date);
  }

  static String formattingDateTime(DateTime date, String local) {
    return appDateFormat(local).add_jm().format(date);
  }
}
