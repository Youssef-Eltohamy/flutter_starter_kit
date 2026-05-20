import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nemo/core/translator.dart';
import 'package:nemo/res/app_colors.dart';
import 'package:nemo/res/app_icons.dart';
import 'package:nemo/utils/connectivity/connectivity_data.dart';
import 'package:nemo/utils/connectivity/connectivity_type.dart';
import 'package:nemo/utils/developer.dart';
import 'package:nemo/utils/locale/app_localization_keys.dart';

const double _connectivityWidgetHeight = 50;

class ConnectivityListenerWidget extends StatefulWidget {
  final String? connectedMessage;
  final String? notConnectedMessage;
  final VoidCallback? disConnectedCallBack;
  final VoidCallback? connectedBackCallBack;

  const ConnectivityListenerWidget({
    this.connectedMessage,
    this.notConnectedMessage,
    Key? key,
    this.disConnectedCallBack,
    this.connectedBackCallBack,
  }) : super(key: key);

  @override
  State<ConnectivityListenerWidget> createState() =>
      _ConnectivityListenerWidgetState();
}

class _ConnectivityListenerWidgetState extends State<ConnectivityListenerWidget>
    with Translator, SingleTickerProviderStateMixin {
  /// we used GetIt to store the data in one class and only one instance.
  /// if we not use any way to provide us with the previous connection state.
  /// the view will always appear, when there is no change in the connection
  /// because the stream will notify us with only changes.
  ConnectivityData connectivityData = GetIt.I<ConnectivityData>();

  late StreamSubscription<InternetConnectionStatus> _internetConnectionStream;
  late StreamSubscription<ConnectivityResult> _connectivityStream;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _setupAnimation();
    _startConnectivityListener();
    _startInternetConnectionListener();
    super.initState();
  }

  @override
  void dispose() {
    _stopAnimation();
    _stopConnectivityListener();
    _stopInternetConnectionListener();
    super.dispose();
  }

  bool visible = false;

  void changeVisible(bool value) {
    setState(() {
      visible = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    _isConnectedToInternet()
        ? _controller.reverse().then((value) => changeVisible(false))
        : _controller.forward().then((value) => changeVisible(true));
    return Visibility(
      visible: visible,
      child: FadeTransition(
        opacity: _animation,
        child: Container(
          decoration: BoxDecoration(
            color:
                _isConnectedToInternet()
                    ? AppColors.connectedToInternetBackground
                    : AppColors.notConnectedToInternetBackground,
            borderRadius: BorderRadius.circular(5),
          ),
          height: _connectivityWidgetHeight,
          child: Center(
            child: Row(
              children: [
                const SizedBox(width: 20),
                Icon(
                  _isConnectedToInternet()
                      ? AppIcons.wifiOnIcon
                      : AppIcons.wifiOffIcon,
                  color:
                      _isConnectedToInternet()
                          ? AppColors.connectedToInternetIcon
                          : AppColors.notConnectedToInternetIcon,
                ),
                const SizedBox(width: 20),
                Text(
                  _isConnectedToInternet()
                      ? _connectedMsg()
                      : _notConnectedMsg(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color:
                        _isConnectedToInternet()
                            ? AppColors.connectedToInternetText
                            : AppColors.notConnectedToInternetText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startConnectivityListener() {
    var connectivity = Connectivity();
    _connectivityStream =
        connectivity.onConnectivityChanged.listen(
              (ConnectivityResult result) async {
                    switch (result) {
                      case ConnectivityResult.wifi:
                        Developer.developerLog("connected throw wifi");
                        connectivityData.connectivityType =
                            ConnectivityType.connectedThrowWifi;
                        break;
                      case ConnectivityResult.mobile:
                        Developer.developerLog("connected throw mobile");
                        connectivityData.connectivityType =
                            ConnectivityType.connectedThrowMobile;
                        break;
                      case ConnectivityResult.none:
                        Developer.developerLog("not connected");
                        connectivityData.connectivityType =
                            ConnectivityType.notConnected;
                        break;
                      default:
                        Developer.developerLog("not connected default case");
                        connectivityData.connectivityType =
                            ConnectivityType.notConnected;
                        break;
                    }
                  }
                  as void Function(List<ConnectivityResult> event)?,
            )
            as StreamSubscription<ConnectivityResult>;
  }

  void _stopConnectivityListener() {
    _connectivityStream.cancel();
  }

  void _startInternetConnectionListener() {
    var internetConnectivityChecker = InternetConnectionChecker.instance;
    _internetConnectionStream = internetConnectivityChecker.onStatusChange
        .listen((event) {
          if (event == InternetConnectionStatus.connected) {
            Developer.developerLog("connected to internet");

            _changeInternetConnectionState(true);
            if (widget.disConnectedCallBack != null) {
              widget.disConnectedCallBack!();
            }
          } else {
            Developer.developerLog("not connected to internet");
            _changeInternetConnectionState(false);
            if (widget.connectedBackCallBack != null) {
              widget.connectedBackCallBack!();
            }
          }
        });
  }

  void _stopInternetConnectionListener() {
    _internetConnectionStream.cancel();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  void _stopAnimation() {
    _controller.dispose();
  }

  void _changeInternetConnectionState(bool isConnected) {
    setState(() {
      connectivityData.isConnectedToInternet = isConnected;
    });
  }

  String _notConnectedMsg() =>
      widget.notConnectedMessage ??
      translate(LocalizationKeys.noInternetConnection)!;

  String _connectedMsg() =>
      widget.connectedMessage ??
      translate(LocalizationKeys.connectionRestored)!;

  bool _isConnectedToInternet() => connectivityData.isConnectedToInternet;
}
