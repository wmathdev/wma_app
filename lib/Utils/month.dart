import 'package:intl/intl.dart';

class Month {
  static String getMonthTitle(String date) {
    var dd = date.substring(0, 2);
    var mm = date.substring(3, 5);
    var yyyy = date.substring(5);
    var tempyear = int.parse(yyyy);
    yyyy = '${-(tempyear - 543)}';

    if (mm == '01') {
      return '$dd ม.ค. $yyyy';
    } else if (mm == '02') {
      return '$dd ก.พ. $yyyy';
    } else if (mm == '03') {
      return '$dd มี.ค. $yyyy';
    } else if (mm == '04') {
      return '$dd เม.ย. $yyyy';
    } else if (mm == '05') {
      return '$dd พ.ค. $yyyy';
    } else if (mm == '06') {
      return '$dd มิ.ย. $yyyy';
    } else if (mm == '07') {
      return '$dd ก.ค. $yyyy';
    } else if (mm == '08') {
      return '$dd ส.ค. $yyyy';
    } else if (mm == '09') {
      return '$dd ก.ย. $yyyy';
    } else if (mm == '10') {
      return '$dd ต.ค. $yyyy';
    } else if (mm == '11') {
      return '$dd พ.ย. $yyyy';
    } else if (mm == '12') {
      return '$dd ธ.ค. $yyyy';
    }
    return '';
  }

  static String getMonthTitleReverse(String date) {
    print(date);
    var dd = date.substring(8);
    var mm = date.substring(5, 7);
    var yyyy = date.substring(0, 4);
    var tempyear = int.parse(yyyy);
    yyyy = '${(tempyear + 543)}';

    print(mm);

    if (mm == '01') {
      return '$dd ม.ค. $yyyy';
    } else if (mm == '02') {
      return '$dd ก.พ. $yyyy';
    } else if (mm == '03') {
      return '$dd มี.ค. $yyyy';
    } else if (mm == '04') {
      return '$dd เม.ย. $yyyy';
    } else if (mm == '05') {
      return '$dd พ.ค. $yyyy';
    } else if (mm == '06') {
      return '$dd มิ.ย. $yyyy';
    } else if (mm == '07') {
      return '$dd ก.ค. $yyyy';
    } else if (mm == '08') {
      return '$dd ส.ค. $yyyy';
    } else if (mm == '09') {
      return '$dd ก.ย. $yyyy';
    } else if (mm == '10') {
      return '$dd ต.ค. $yyyy';
    } else if (mm == '11') {
      return '$dd พ.ย. $yyyy';
    } else if (mm == '12') {
      return '$dd ธ.ค. $yyyy';
    }
    return '';
  }

  static String getMonthLabel(String date) {
    var mm = date.substring(5, 7);

    if (mm == '01') {
      return 'ม.ค.';
    } else if (mm == '02') {
      return 'ก.พ.';
    } else if (mm == '03') {
      return 'มี.ค.';
    } else if (mm == '04') {
      return 'เม.ย.';
    } else if (mm == '05') {
      return 'พ.ค.';
    } else if (mm == '06') {
      return 'มิ.ย.';
    } else if (mm == '07') {
      return 'ก.ค.';
    } else if (mm == '08') {
      return 'ส.ค.';
    } else if (mm == '09') {
      return 'ก.ย.';
    } else if (mm == '10') {
      return 'ต.ค.';
    } else if (mm == '11') {
      return 'พ.ย.';
    } else if (mm == '12') {
      return 'ธ.ค.';
    }
    return '';
  }

  static String getMonthFullLabel(String date) {
    var mm = date.substring(5, 7);

    print('mm : $mm');

    if (mm == '01') {
      return 'มกราคม';
    } else if (mm == '02') {
      return 'กุมภาพันธ์';
    } else if (mm == '03') {
      return 'มีนาคม';
    } else if (mm == '04') {
      return 'เมษายน';
    } else if (mm == '05') {
      return 'พฤษภาคม';
    } else if (mm == '06') {
      return 'มิถุนายน';
    } else if (mm == '07') {
      return 'กรกฎาคม';
    } else if (mm == '08') {
      return 'สิงหาคม';
    } else if (mm == '09') {
      return 'กันยายน';
    } else if (mm == '10') {
      return 'ตุลาคม';
    } else if (mm == '11') {
      return 'พฤศจิกายน';
    } else if (mm == '12') {
      return 'ธันวาคม';
    }
    return '';
  }

  static String getNoteTime(String date) {
    String time = date.substring(11, 13);
    String day = date.substring(8, 10);
    String year = date.substring(0, 4);
    var tempyear = int.parse(year);
    year = '${-(tempyear - 543)}';

    var label = '$time น. $day ${getMonthLabel(date)} $year';

    return '';
  }

  static List<dynamic> monthList() {
    return [
      {'code': '01', 'label': 'มกราคม'},
      {'code': '02', 'label': 'กุมภาพันธ์'},
      {'code': '03', 'label': 'มีนาคม'},
      {'code': '04', 'label': 'เมษายน'},
      {'code': '05', 'label': 'พฤษภาคม'},
      {'code': '06', 'label': 'มิถุนายน'},
      {'code': '07', 'label': 'กรกฏาคม'},
      {'code': '08', 'label': 'สิงหาคม'},
      {'code': '09', 'label': 'กันยายน'},
      {'code': '10', 'label': 'ตุลาคม'},
      {'code': '11', 'label': 'พฤศจิกายน'},
      {'code': '12', 'label': 'ธันวาคม'},
    ];
  }

  static List<String> month() {
    return [
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฏาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม',
    ];
  }

  static List<String> dayOfMonth(int year, int month) {
    var now = DateTime(year, month);

    // Getting the total number of days of the month
    var totalDays = daysInMonth(now);

    // Stroing all the dates till the last date
    // since we have found the last date using generate
    var listOfDates = List<int>.generate(totalDays, (i) => i + 1);
    print(listOfDates);
    List<String> data = [];
    for (var i = 0; i < listOfDates.length; i++) {
      data.add('${listOfDates[i]}');
    }
    return data;
  }

  static int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  static String monthLabel(String mm) {
    if (mm == '01') {
      return 'มกราคม';
    } else if (mm == '02') {
      return 'กุมภาพันธ์';
    } else if (mm == '03') {
      return 'มีนาคม';
    } else if (mm == '04') {
      return 'เมษายน';
    } else if (mm == '05') {
      return 'พฤษภาคม';
    } else if (mm == '06') {
      return 'มิถุนายน';
    } else if (mm == '07') {
      return 'กรกฏาคม';
    } else if (mm == '08') {
      return 'สิงหาคม';
    } else if (mm == '09') {
      return 'กันยายน';
    } else if (mm == '10') {
      return 'ตุลาคม';
    } else if (mm == '11') {
      return 'พฤศจิกายน';
    } else if (mm == '12') {
      return 'ธันวาคม';
    }
    return '';
  }

  static int monthIndex(String mm) {
    if (mm == '01') {
      return 0;
    } else if (mm == '02') {
      return 1;
    } else if (mm == '03') {
      return 2;
    } else if (mm == '04') {
      return 3;
    } else if (mm == '05') {
      return 4;
    } else if (mm == '06') {
      return 5;
    } else if (mm == '07') {
      return 6;
    } else if (mm == '08') {
      return 7;
    } else if (mm == '09') {
      return 8;
    } else if (mm == '10') {
      return 9;
    } else if (mm == '11') {
      return 10;
    } else if (mm == '12') {
      return 11;
    }
    return -1;
  }

  static List<String> year() {
    int currentYear = DateTime.now().year;
    int startingYear = 2020;
    List<String> yearList = List.generate((currentYear - startingYear) + 1,
        (index) => '${startingYear + index + 543}');
    List<String> reversedYear = yearList.reversed.toList();
    return reversedYear;
  }

   static List<String> yearForward() {
    int currentYear = DateTime.now().year;
    int startingYear = 2020;
    List<String> yearList = List.generate((currentYear - startingYear) + 1,
        (index) => '${startingYear + index + 544}');
    List<String> reversedYear = yearList.reversed.toList();
    return reversedYear;
  }

  static String converseYear(String yyyy) {
    int temp = int.parse(yyyy);
    temp = temp - 543;
    return '$temp';
  }

  static String getGraphDayMonth(String date) {
    var dd = date.substring(8);
    var mm = date.substring(5, 7);
    var yyyy = date.substring(0, 4);
    var tempyear = int.parse(yyyy);
    yyyy = '${(tempyear + 543)}';

    if (mm == '01') {
      return '$dd\nม.ค.';
    } else if (mm == '02') {
      return '$dd\nก.พ.';
    } else if (mm == '03') {
      return '$dd\nมี.ค.';
    } else if (mm == '04') {
      return '$dd\nเม.ย.';
    } else if (mm == '05') {
      return '$dd\nพ.ค.';
    } else if (mm == '06') {
      return '$dd\nมิ.ย.';
    } else if (mm == '07') {
      return '$dd\nก.ค.';
    } else if (mm == '08') {
      return '$dd\nส.ค.';
    } else if (mm == '09') {
      return '$dd\nก.ย.';
    } else if (mm == '10') {
      return '$dd\nต.ค.';
    } else if (mm == '11') {
      return '$dd\nพ.ย.';
    } else if (mm == '12') {
      return '$dd\nธ.ค.';
    }
    return '';
  }

  static String getGraphMonth(String date) {
    var dd = date.substring(8);
    var mm = date.substring(5, 7);
    var yyyy = date.substring(0, 4);
    var tempyear = int.parse(yyyy);
    yyyy = '${(tempyear + 543)}';

    return monthLabel(mm);
  }

  static String getGraphDay(String date) {
    var dd = date.substring(8);
    var mm = date.substring(5, 7);
    var yyyy = date.substring(0, 4);
    var tempyear = int.parse(yyyy);
    yyyy = '${(tempyear + 543)}';

    return dd;
  }

  static String getDatePOSO(String date) {
    var dd = date.substring(8);
    var mm = date.substring(5, 7);
    var yyyy = date.substring(0, 4);
    var tempyear = int.parse(yyyy);
    yyyy = '${(tempyear + 543)}';

    return '$dd ${monthLabel(mm)} $yyyy';
  }
}
