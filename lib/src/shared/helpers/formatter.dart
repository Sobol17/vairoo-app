import 'package:ai_note/src/shared/constants/monts.dart';

class Formatter {
  String formatMonth(DateTime date) {
    return MONTH_NAMES[date.month - 1];
  }

  String formatMonthYear(DateTime date) {
    return '${MONTH_NAMES[date.month - 1]} ${date.year}';
  }

  String formatFullDate(DateTime date) {
    return '${MONTH_NAMES[date.month - 1]} ${date.day}, ${date.year}';
  }

  String applyPhoneMask(String digits) {
    if (digits.isEmpty) {
      return '';
    }
    var prepared = digits.replaceAll(RegExp(r'[^0-9]'), '');
    if (prepared.length > 11) {
      prepared = prepared.substring(0, 11);
    }
    if (prepared.length == 10) {
      prepared = '8$prepared';
    } else if (prepared.length == 11 && prepared.startsWith('7')) {
      prepared = '8${prepared.substring(1)}';
    }

    final buffer = StringBuffer();
    for (var i = 0; i < prepared.length; i++) {
      buffer.write(prepared[i]);
      if (i == 0 && prepared.length > 1) {
        buffer.write(' ');
      } else if (i == 3 && prepared.length > 4) {
        buffer.write(' ');
      } else if (i == 6 && prepared.length > 7) {
        buffer.write(' ');
      } else if (i == 8 && prepared.length > 9) {
        buffer.write('-');
      }
    }
    return buffer.toString();
  }

  String formatPhoneNumber(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return input;
    }
    final masked = applyPhoneMask(digits);
    return masked.isEmpty ? input : masked;
  }

  String formatCalendarDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }
}
