import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nemo/core/widgets/base_stateless_widget.dart';
import 'package:nemo/res/app_colors.dart';
import 'package:nemo/utils/locale/app_localization_keys.dart';

class OnboardingScreen extends BaseStatelessWidget {
  OnboardingScreen({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(LocalizationKeys.languageValue)!),
        backgroundColor:
            themeData.textButtonTheme.style!.backgroundColor!.resolve({}),
      ),
      body: Center(
        child: Container(
            width: 90.h,
            height: 90.w,
            child: Text(translate(LocalizationKeys.account)!)),
      ),
    );
  }
}
