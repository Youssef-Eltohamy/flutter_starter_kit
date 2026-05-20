import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/extensions/context_extensions.dart';
import 'package:flutter_starter_kit/utils/loaders/full_screen_loader_widget.dart';
import 'package:flutter_starter_kit/utils/locale/app_localization_keys.dart';
import 'package:flutter_starter_kit/utils/widgets/empty_widgets.dart';

/// Adds a full-screen loading overlay to a [State]. Call [showLoading] /
/// [hideLoading] (or the message variants) from the screen, and render
/// [loadingManagerWidget] in the widget tree.
mixin LoadingManager<T extends StatefulWidget> on State<T> {
  String? _message;
  bool _isLoading = false;
  bool _isLoadingWithMessage = false;

  void showLoading() {
    if (!_isLoading) setState(() => _isLoading = true);
  }

  void hideLoading() {
    if (_isLoading) setState(() => _isLoading = false);
  }

  void showMessageLoading({String? message}) {
    setState(() {
      _message = message ?? context.tr(LocalizationKeys.plzWait);
      _isLoadingWithMessage = true;
    });
  }

  void hideMessageLoading() {
    if (_isLoadingWithMessage) setState(() => _isLoadingWithMessage = false);
  }

  void hideAnyLoading() {
    hideLoading();
    hideMessageLoading();
  }

  Widget loadingManagerWidget() {
    if (_isLoading) return FullScreenLoaderWidget.onlyAnimation();
    if (_isLoadingWithMessage) {
      return FullScreenLoaderWidget.message(_message!);
    }
    return getEmptyWidget();
  }
}
