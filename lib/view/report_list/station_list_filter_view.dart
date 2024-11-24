import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wma_app/Utils/status.dart';

import '../../Utils/month.dart';
import '../../widget/button_app.dart';
import '../../widget/dropdown/dropdown.dart';
import '../../widget/navigatebar.dart';
import '../../widget/text_widget.dart';
import 'dropdown_filter.dart';

class StationListFilterView extends StatefulWidget {
  const StationListFilterView({super.key});

  @override
  State<StationListFilterView> createState() => _StationListFilterViewState();
}

class _StationListFilterViewState extends State<StationListFilterView> {
  var today = DateTime.now();
  var month;
  var year;
  var day;

  var indexMonth = -1;
  var status = '';
  var statusIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indexMonth = Month.monthIndex(DateFormat('MM').format(today));
    month = Month.monthLabel(DateFormat('MM').format(today));
    year = '${int.parse(DateFormat('yyyy').format(today)) + 543}';
    day = DateFormat('dd').format(today);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        color: Colors.white,
        child: contentView(),
      ),
    ));
  }

  Widget contentView() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Stack(children: [
        SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                const SizedBox(
                  height: 80,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextWidget.textSubTitle(
                      'ค้นหาปีและเดือน ที่คุณต้องการดูรายงานคุณภาพน้ำที่ผ่านมา'),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextWidget.textTitle('ปี พ.ศ.'),
                ),
                const SizedBox(
                  height: 5,
                ),
                DropDown.dropdownButton(context, '$year', () async {
                  int result = await Get.to(DropDownSelect(
                    data: Month.year(),
                    title: 'เลือก ปี พ.ศ.',
                  ));

                  setState(() {
                    year = Month.year()[result];
                  });
                }),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextWidget.textTitle('เดือน'),
                ),
                const SizedBox(
                  height: 5,
                ),
                DropDown.dropdownButton(context, '$month', () async {
                  int result = await Get.to(DropDownSelect(
                    data: Month.month(),
                    title: 'เลือกเดือน',
                  ));

                  print('$result');
                  print(Month.month()[result]);
                  setState(() {
                    month = Month.month()[result];
                    indexMonth = result;
                  });
                }),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextWidget.textTitle('วัน'),
                ),
                const SizedBox(
                  height: 5,
                ),
                DropDown.dropdownButton(context, '$day', () async {
                  int result = await Get.to(DropDownSelect(
                    data: Month.dayOfMonth(int.parse(year), indexMonth + 1),
                    title: 'เลือกวันที่',
                  ));
                  setState(() {
                    day = Month.dayOfMonth(
                        int.parse(year), indexMonth + 1)[result];
                  });
                }),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextWidget.textTitle('สถานะการดำเนินการ'),
                ),
                const SizedBox(
                  height: 5,
                ),
                DropDown.dropdownButton(context, status, () async {
                  int result = await Get.to(DropDownSelect(
                    data: Status.statusLabel,
                    title: 'เลือกสถานะการดำเนินการ',
                  ));

                  print('$result');
                  print(Status.status[result]);
                  setState(() {
                    status = Status.statusLabel[result];
                    statusIndex = result;
                  });
                }),
                  ],
                ))),
        Container(
          height: 80,
          alignment: Alignment.topCenter,
          child: NavigateBar.NavBar(context, 'ตัวกรอง', () {
            Get.back();
          }),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.bottomCenter,
            child: footer())
      ]),
    );
  }

  Widget footer() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 25.0,
            spreadRadius: 5,
            offset: Offset(-5, 0), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ButtonApp.buttonSecondaryFix(context, 'ยกเลิก', () {
              Get.back();
            }, true),
            ButtonApp.buttonMainFixGradient(context, 'นำไปใช้', () async {
              var stt = '';
              if (statusIndex != -1) {
                stt = Status.status[statusIndex]['status'];
              }
              Navigator.pop(context, {
                'reportat':
                    '${Month.converseYear(year)}-${Month.monthList()[indexMonth]['code']}-$day',
                'workflow': stt
              });
            }, true),
          ],
        ),
      ),
    );
  }
}
