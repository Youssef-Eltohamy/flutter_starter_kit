import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_starter_kit/core/extensions/context_extensions.dart';
import 'package:flutter_starter_kit/utils/locale/app_localization_keys.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr(LocalizationKeys.languageValue)),
        backgroundColor:
            context.theme.textButtonTheme.style?.backgroundColor?.resolve({}),
      ),
      body: Center(
        child: SizedBox(
          width: 90.h,
          height: 90.w,
          child: Text(context.tr(LocalizationKeys.account)),
        ),
      ),
    );
  }
}
