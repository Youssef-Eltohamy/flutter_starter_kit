import 'package:flutter_starter_kit/core/masked_text_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getInitialFormattedNumber', () {
    test('returns empty string for empty input', () {
      expect(getInitialFormattedNumber('xxx-xxx', ''), '');
    });

    test('applies the mask separators between digits', () {
      expect(getInitialFormattedNumber('xx-xx', '1234'), '12-34');
    });

    test('strips trailing placeholders when input is shorter than the mask', () {
      expect(getInitialFormattedNumber('xxx', '12'), '12');
    });

    test('formats a typical phone number mask', () {
      expect(getInitialFormattedNumber('xxx xxx xxxx', '1234567890'),
          '123 456 7890');
    });
  });
}
