import 'package:intl/intl.dart';

class Label {
  static String nemerricFormat(double number) {
    NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    // var formatter = NumberFormat('###,###,###,##0');
    return formatter.format(number);
  }

  static String commaFormat(String number) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String Function(Match) mathFunc = (Match match) => '${match[1]},';
    String result = number.replaceAllMapped(reg, mathFunc);
    return result;
  }
}
