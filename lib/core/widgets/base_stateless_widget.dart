import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/platform_manager.dart';
import 'package:flutter_starter_kit/core/screen_sizer.dart';
import 'package:flutter_starter_kit/core/themer.dart';
import 'package:flutter_starter_kit/core/translator.dart';

// ignore: must_be_immutable
abstract class BaseStatelessWidget extends StatelessWidget
    with Translator, ScreenSizer, PlatformManager, Themer {
  BaseStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    initScreenSizer(context);
    initThemer(context);
    return baseBuild(context);
  }

  Widget baseBuild(BuildContext context);
}
