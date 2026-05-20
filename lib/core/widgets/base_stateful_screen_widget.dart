import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/loading_manager.dart';
import 'package:flutter_starter_kit/utils/connectivity/connectivity_listener_widget.dart';

/// Base for full screens. Stacks the screen content with a loading overlay
/// (via [LoadingManager]) and an offline/connectivity banner — so every screen
/// gets these for free. Implement [baseScreenBuild] in the state subclass.
abstract class BaseStatefulScreenWidget extends StatefulWidget {
  const BaseStatefulScreenWidget({super.key});
}

abstract class BaseScreenState<W extends BaseStatefulScreenWidget>
    extends State<W> with LoadingManager<W> {
  Widget baseScreenBuild(BuildContext context);

  double? get connectivityStart => 20;
  double? get connectivityEnd => 20;
  double? get connectivityTop => null;
  double? get connectivityBottom => 100;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          baseScreenBuild(context),
          loadingManagerWidget(),
          PositionedDirectional(
            start: connectivityStart,
            end: connectivityEnd,
            top: connectivityTop,
            bottom: connectivityBottom,
            child: const ConnectivityListenerWidget(),
          ),
        ],
      ),
    );
  }
}
