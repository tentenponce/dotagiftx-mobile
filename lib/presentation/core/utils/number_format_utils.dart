import 'package:intl/intl.dart';

abstract final class NumberFormatUtils {
  static String formatDecimal(
    double? d,
    int zeroCount, {
    bool isDecimalRequired = true,
  }) {
    final zeros = StringBuffer();

    for (var i = 0; i < zeroCount; i++) {
      zeros.write('0');
    }

    var pattern = '#,##0';

    if (zeros.isNotEmpty) {
      pattern += '.$zeros';
    }

    final numberFormat = NumberFormat(pattern);

    var formattedNumber =
        d != null ? numberFormat.format(d) : numberFormat.format(0);

    if (!isDecimalRequired) {
      final expectedNoDecimalLength = formattedNumber.length - zeroCount;
      for (var i = formattedNumber.length; i >= expectedNoDecimalLength; i--) {
        final number = formattedNumber[i - 1];

        if ((number == '0' || number == '.') && formattedNumber.contains('.')) {
          formattedNumber = formattedNumber.substring(
            0,
            formattedNumber.length - 1,
          );
        } else {
          break;
        }
      }
    }

    return formattedNumber;
  }
}
