import 'package:intl/intl.dart';

class Label {
  static String nemerricFormat(int number) {
    var formatter = NumberFormat('###,###,###,##0');
    return formatter.format(number);
  }
}