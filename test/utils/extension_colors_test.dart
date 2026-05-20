import 'dart:ui';

import 'package:flutter_starter_kit/utils/extensions/extension_colors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HexColor', () {
    test('fromHex parses a 6-digit hex string', () {
      expect(HexColor.fromHex('#FF0000'), const Color(0xFFFF0000));
    });

    test('fromHex parses an 8-digit (with alpha) hex string', () {
      expect(HexColor.fromHex('80FF0000'), const Color(0x80FF0000));
    });

    test('toHex round-trips a color', () {
      const color = Color(0xFF1A2B3C);
      expect(color.toHex(), '#ff1a2b3c');
    });

    test('toHex can omit the leading hash sign', () {
      const color = Color(0xFF1A2B3C);
      expect(color.toHex(leadingHashSign: false), 'ff1a2b3c');
    });
  });
}
