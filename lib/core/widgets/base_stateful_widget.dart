import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/platform_manager.dart';
import 'package:flutter_starter_kit/core/screen_sizer.dart';
import 'package:flutter_starter_kit/core/themer.dart';
import 'package:flutter_starter_kit/core/translator.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({super.key});

  @override
  // ignore: no_logic_in_create_state
  BaseState createState() => baseCreateState();

  BaseState baseCreateState();
}

abstract class BaseState<W extends BaseStatefulWidget> extends State<W>
    with Translator, ScreenSizer, PlatformManager, Themer {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initTranslator(context);
    initScreenSizer(context);
    initThemer(context);
  }

  @override
  Widget build(BuildContext context) {
    return baseBuild(context);
  }

  Widget baseBuild(BuildContext context);
}
