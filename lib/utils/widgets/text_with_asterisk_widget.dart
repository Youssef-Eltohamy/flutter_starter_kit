import 'package:flutter/material.dart';

class TextWithAsterisk extends RichText {
  final TextStyle style;
  final Color? asteriskColor;
  final String labelText;
  TextWithAsterisk({
    super.key,
    this.asteriskColor,
    required this.style,
    required this.labelText,
  }) : super(
          text: TextSpan(
              text: labelText,
              style: style,
              children: [asteriskText(style, asteriskColor)]),
        );

  static TextSpan asteriskText(TextStyle style, Color? asteriskColor) {
    return TextSpan(
        text: ' *', style: style.copyWith(color: asteriskColor ?? Colors.red));
  }
}
