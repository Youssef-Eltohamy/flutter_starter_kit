import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_starter_kit/core/widgets/base_stateless_widget.dart';
import 'package:flutter_starter_kit/utils/locale/app_localization_keys.dart';

// BaseStatelessWidget mixes in ScreenSizer/Themer/Translator, which cache
// layout state in non-final fields. Slated for a Phase 2 architecture refactor.
// ignore: must_be_immutable
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
        child: SizedBox(
            width: 90.h,
            height: 90.w,
            child: Text(translate(LocalizationKeys.account)!)),
      ),
    );
  }
}
