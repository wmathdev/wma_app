import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wma_app/Utils/month.dart';
import 'package:wma_app/view/report_list/dropdown_filter.dart';
import 'package:wma_app/widget/button_app.dart';
import 'package:wma_app/widget/dropdown/dropdown.dart';
import 'package:wma_app/widget/navigatebar.dart';
import 'package:wma_app/widget/text_widget.dart';

class ReportDownloadFilter extends StatefulWidget {
  const ReportDownloadFilter({super.key});

  @override
  State<ReportDownloadFilter> createState() => _ReportDownloadFilterState();
}

class _ReportDownloadFilterState extends State<ReportDownloadFilter> {
  var today = DateTime.now();
  // var month;
  var year;

  var indexMonth = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // indexMonth = Month.monthIndex(DateFormat('MM').format(today));
    // month = Month.monthLabel(DateFormat('MM').format(today));
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
                          'ค้นหาปี ที่คุณต้องการดาวน์โหลดรายงานประจำเดือน'),
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
                        data: Month.yearForward(),
                        title: 'เลือก ปี พ.ศ.',
                      ));

                      setState(() {
                        year = Month.yearForward()[result];
                      });
                    }),
                    const SizedBox(
                      height: 10,
                    ),
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
              Navigator.pop(context,
                  Month.converseYear(year));
            }, true),
          ],
        ),
      ),
    );
  }
}
