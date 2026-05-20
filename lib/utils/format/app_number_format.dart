import 'package:intl/intl.dart';

class AppNumberFormat {
  static final NumberFormat formatter = NumberFormat('#,##,000');

  static String thousandsSeparators(num number) {
    return formatter.format(number);
  }
}
