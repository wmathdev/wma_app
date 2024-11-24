import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wma_app/view/report_list/dropdown_filter.dart';

import '../../Utils/month.dart';
import '../../widget/button_app.dart';
import '../../widget/dropdown/dropdown.dart';
import '../../widget/navigatebar.dart';
import '../../widget/text_widget.dart';

class ReprotListFilter extends StatefulWidget {
  const ReprotListFilter({super.key});

  @override
  State<ReprotListFilter> createState() => _ReprotListFilterState();
}

class _ReprotListFilterState extends State<ReprotListFilter> {
  var today = DateTime.now();
  var month;
  var year;

  var indexMonth = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indexMonth = Month.monthIndex(DateFormat('MM').format(today));
    month = Month.monthLabel(DateFormat('MM').format(today));
    year = '${int.parse(DateFormat('yyyy').format(today)) + 543}';
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
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('asset/images/waterbg.jpg'),
          fit: BoxFit.fill,
        ),
      ),
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
      height: 74,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
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
            ButtonApp.buttonSecondaryHalf(context, 'ยกเลิก', () {
              Get.back();
            }),
            ButtonApp.buttonMainhalf(context, 'นำไปใช้', () async {
              Navigator.pop(context,
                  '${Month.converseYear(year)}-${Month.monthList()[indexMonth]['code']}-01');
            }, true),
          ],
        ),
      ),
    );
  }
}
