import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nemo/core/loading_manager.dart';
import 'package:nemo/core/widgets/base_stateful_widget.dart';
import 'package:nemo/utils/connectivity/connectivity_listener_widget.dart';

abstract class BaseStatefulScreenWidget extends BaseStatefulWidget {
  const BaseStatefulScreenWidget({Key? key}) : super(key: key);

  @override
  BaseScreenState baseCreateState() => baseScreenCreateState();

  BaseScreenState baseScreenCreateState();
}

abstract class BaseScreenState<W extends BaseStatefulScreenWidget>
    extends BaseState<W>
    with LoadingManager {
  @override
  Widget baseBuild(BuildContext context) {
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          baseScreenBuild(context),
          loadingManagerWidget(),
          _positionConnectivityWidget(),
        ],
      ),
    );
  }

  void changeState() {
    setState(() {});
  }

  @override
  void runChangeState() {
    changeState();
  }

  @override
  BaseScreenState provideTranslate() {
    return this;
  }

  Widget baseScreenBuild(BuildContext context);

  double? connectivityStartPadding = 20.w;
  double? connectivityEndPadding = 20.w;
  double? connectivityTopPadding;
  double? connectivityBottomPadding = 100.h;

  Widget _positionConnectivityWidget() {
    return PositionedDirectional(
      start: connectivityStartPadding,
      end: connectivityEndPadding,
      top: connectivityTopPadding,
      bottom: connectivityBottomPadding,
      child: ConnectivityListenerWidget(
        connectedBackCallBack: connectedBackCallBack,
        disConnectedCallBack: disConnectedCallBack,
      ),
    );
  }

  void connectedBackCallBack() {}
  void disConnectedCallBack() {}
}
