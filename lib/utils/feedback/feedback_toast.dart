import 'package:flutter_starter_kit/res/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message) {
  /// reference
  /// https://pub.dev/packages/fluttertoast
  ///
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: AppColors.toastBackground,
    textColor: AppColors.toastText,
    fontSize: 16.0,
  );
}
