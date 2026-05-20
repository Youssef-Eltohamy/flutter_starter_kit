import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/extensions/context_extensions.dart';
import 'package:flutter_starter_kit/res/app_colors.dart';
import 'package:flutter_starter_kit/res/app_icons.dart';
import 'package:flutter_starter_kit/utils/connectivity/connectivity_data.dart';
import 'package:flutter_starter_kit/utils/connectivity/connectivity_type.dart';
import 'package:flutter_starter_kit/utils/developer.dart';
import 'package:flutter_starter_kit/utils/locale/app_localization_keys.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

const double _connectivityWidgetHeight = 50;

class ConnectivityListenerWidget extends StatefulWidget {
  final String? connectedMessage;
  final String? notConnectedMessage;
  final VoidCallback? disConnectedCallBack;
  final VoidCallback? connectedBackCallBack;

  const ConnectivityListenerWidget({
    this.connectedMessage,
    this.notConnectedMessage,
    super.key,
    this.disConnectedCallBack,
    this.connectedBackCallBack,
  });

  @override
  State<ConnectivityListenerWidget> createState() =>
      _ConnectivityListenerWidgetState();
}

class _ConnectivityListenerWidgetState extends State<ConnectivityListenerWidget>
    with SingleTickerProviderStateMixin {
  /// we used GetIt to store the data in one class and only one instance.
  /// if we not use any way to provide us with the previous connection state.
  /// the view will always appear, when there is no change in the connection
  /// because the stream will notify us with only changes.
  ConnectivityData connectivityData = GetIt.I<ConnectivityData>();

  late StreamSubscription<InternetConnectionStatus> _internetConnectionStream;
  late StreamSubscription<List<ConnectivityResult>> _connectivityStream;

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
    _isConnectedToInternet()
        ? _controller.reverse().then((value) => changeVisible(false))
        : _controller.forward().then((value) => changeVisible(true));
    return Visibility(
      visible: visible,
      child: FadeTransition(
        opacity: _animation,
        child: Container(
          decoration: BoxDecoration(
            color: _isConnectedToInternet()
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
                  color: _isConnectedToInternet()
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
                    color: _isConnectedToInternet()
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
    final connectivity = Connectivity();
    _connectivityStream = connectivity.onConnectivityChanged.listen((results) {
      final result = results.isEmpty ? ConnectivityResult.none : results.first;
      switch (result) {
        case ConnectivityResult.wifi:
          Developer.developerLog('connected through wifi');
          connectivityData.connectivityType =
              ConnectivityType.connectedThrowWifi;
        case ConnectivityResult.mobile:
          Developer.developerLog('connected through mobile');
          connectivityData.connectivityType =
              ConnectivityType.connectedThrowMobile;
        default:
          Developer.developerLog('not connected');
          connectivityData.connectivityType = ConnectivityType.notConnected;
      }
    });
  }

  void _stopConnectivityListener() {
    _connectivityStream.cancel();
  }

  void _startInternetConnectionListener() {
    final internetConnectivityChecker = InternetConnectionChecker.instance;
    _internetConnectionStream =
        internetConnectivityChecker.onStatusChange.listen((event) {
      if (event == InternetConnectionStatus.connected) {
        Developer.developerLog('connected to internet');

        _changeInternetConnectionState(true);
        if (widget.connectedBackCallBack != null) {
          widget.connectedBackCallBack!();
        }
      } else {
        Developer.developerLog('not connected to internet');
        _changeInternetConnectionState(false);
        if (widget.disConnectedCallBack != null) {
          widget.disConnectedCallBack!();
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
      context.tr(LocalizationKeys.noInternetConnection);

  String _connectedMsg() =>
      widget.connectedMessage ??
      context.tr(LocalizationKeys.connectionRestored);

  bool _isConnectedToInternet() => connectivityData.isConnectedToInternet;
}
