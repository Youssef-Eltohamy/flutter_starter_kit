import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/utils/loaders/square_circle_loading_widget.dart';

class FullScreenLoaderWidget extends StatelessWidget {
  final String? message;

  const FullScreenLoaderWidget({super.key, this.message});

  factory FullScreenLoaderWidget.onlyAnimation() {
    return const FullScreenLoaderWidget();
  }

  factory FullScreenLoaderWidget.message(String message) {
    return FullScreenLoaderWidget(message: message);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      color: theme.primaryColor.withValues(alpha: 0.86),
      child: Center(
        child: message != null
            ? txtWithLoading(theme.cardColor)
            : flashLoading(theme.cardColor),
      ),
    );
  }

  Widget flashLoading(Color color) => SquareCircleLoadingWidget(color: color);

  Widget txtWithLoading(Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        flashLoading(color),
        const SizedBox(width: 20),
        Text(message!, style: TextStyle(fontSize: 20, color: color)),
      ],
    );
  }
}
