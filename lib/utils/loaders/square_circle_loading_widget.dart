import 'dart:math' as math;

import 'package:flutter/material.dart';

class SquareCircleLoadingWidget extends StatefulWidget {
  final Color color;
  final double size;
  final Duration duration;
  final AnimationController? controller;

  const SquareCircleLoadingWidget({
    Key? key,
    required this.color,
    this.size = 50.0,
    this.duration = const Duration(milliseconds: 500),
    this.controller,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SquareCircleLoadingWidgetState createState() =>
      _SquareCircleLoadingWidgetState();
}

class _SquareCircleLoadingWidgetState extends State<SquareCircleLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animationCurve;
  late Animation<double> animationSize;

  @override
  void initState() {
    super.initState();

    controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat(reverse: true);
    final animation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic);
    animationCurve = Tween(begin: 1.0, end: 0.0).animate(animation);
    animationSize = Tween(begin: 0.5, end: 1.0).animate(animation);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeValue = widget.size * animationSize.value;
    return Center(
      child: Transform(
        transform: Matrix4.identity()..rotateZ(animationCurve.value * math.pi),
        alignment: FractionalOffset.center,
        child: SizedBox.fromSize(
          size: Size.square(sizeValue),
          child: _buildCoreWidget(0, 0.5 * sizeValue * animationCurve.value),
        ),
      ),
    );
  }

  Widget _buildCoreWidget(int index, double curveValue) => DecoratedBox(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.all(Radius.circular(curveValue)),
        ),
      );
}
