// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wma_app/view/report_list/report_list_month_view.dart';
import 'package:wma_app/view/report_list/station_list_filter_view.dart';

import '../../Utils/Color.dart';
import '../../Utils/month.dart';
import '../../api/OfficerRequest.dart';
import '../../model/user.dart';
import '../../widget/dialog.dart';
import '../../widget/list_item_widget.dart';
import '../../widget/navigatebar.dart';
import '../../widget/text_widget.dart';

class StationListMonth extends StatefulWidget {
  String role;
  StationListMonth({
    Key? key,
    required this.role,
  }) : super(key: key);

  @override
  State<StationListMonth> createState() => _StationListMonthState();
}

class _StationListMonthState extends State<StationListMonth> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var accessToken = '';

  var today = DateTime.now();
  final outputFormat = DateFormat('yyyy-MM-dd');
  String formattedDate = '';

  late String month;
  late String year;

  var loading = true;

  List<dynamic> data = [];

  var workflow = '';
  var reportAt = '';

  Future<void> _getDocumentList(
    String peroid,
  ) async {
    final SharedPreferences prefs = await _prefs;
    accessToken = (prefs.getString('access_token') ?? '');
    var result;

    result = await OfficerRequest.getReportList(
        accessToken, 'MONTHLY', workflow, reportAt);

    if (result['success'] == false) {
      MyDialog.showAlertDialogOk(context, '${result['message']}', () {
        Get.back();
        Get.back();
      });
    } else {
      setState(() {
        data = result['data'];
        loading = false;
      });
      print(result['data']);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (loading) {
      _getDocumentList(
        '',
      );
      formattedDate = DateFormat('yyyy-MM-dd').format(today);
      setState(() {
        month = Month.getMonthFullLabel(formattedDate);
        year = formattedDate.substring(0, 4);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        color: Colors.white,
        child: loading
            ? Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'asset/lottie/Loading1.json',
                        width: 150,
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                      TextWidget.textGeneralWithColor(
                          'กรุณารอสักครู่...', blueSelected)
                    ],
                  ),
                ),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage('asset/images/waterbg.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: contentView()),
      ),
    ));
  }

  Widget contentView() {
    return RefreshIndicator(
      onRefresh: () => _getDocumentList(
        '',
      ),
      child: Column(
        children: [
          Container(
            height: 80,
            alignment: Alignment.topCenter,
            child: NavigateBar.NavBarWithNotification(
                context, 'รายงานประจำเดือนทั้งหมด', () {
              Get.back();
            }),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: SingleChildScrollView(
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
                          'สำรวจสถานะการดำเนินงาน ของศูนย์บริหารคุณภาพน้ำแต่ละพื้นที่'),
                    ),
                    filterMenu(),
                    listView()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterMenu() {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: TextButton(
                onPressed: null,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: blueButton,
                      border: Border.all(
                        color: blueButtonBorder,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: Center(
                      child:
                          TextWidget.textGeneralWithColor(month, Colors.black)),
                ))),
        Expanded(
            flex: 3,
            child: TextButton(
                onPressed: null,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: blueButton,
                      border: Border.all(
                        color: blueButtonBorder,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Center(
                      child: TextWidget.textGeneralWithColor(
                          '${int.parse(year) + 543}', Colors.black)),
                ))),
        Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  loading = true;
                });

                dynamic result = await Get.to(const StationListFilterView());
                print('object : $result');

                if (result != null) {
                  var res = await OfficerRequest.getReportList(accessToken,
                      'MONTHLY', result['workflow'], result['reportat']);
                  setState(() {
                    year = result['reportat'].substring(0, 4);
                    month = Month.getMonthFullLabel(result['reportat']);
                    data = res['data'];
                    loading = false;
                  });
                } else {
                  loading = false;
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Row(
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'asset/images/setting.png',
                      ),
                      onPressed: null,
                    ),
                  ],
                ),
              ),
            ))
      ],
    );
  }

  // Widget filterMenu() {
  //   return Row(
  //     children: [
  //       Expanded(
  //           flex: 1,
  //           child: TextButton(
  //               onPressed: null,
  //               child: Container(
  //                 margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
  //                 width: MediaQuery.of(context).size.width,
  //                 padding: const EdgeInsets.all(8.0),
  //                 decoration: BoxDecoration(
  //                     color: blueButton,
  //                     border: Border.all(
  //                       color: blueButtonBorder,
  //                     ),
  //                     borderRadius:
  //                         const BorderRadius.all(Radius.circular(10))),
  //                 child: Center(
  //                     child: TextWidget.textGeneralWithColor(
  //                         month, blueButtonText)),
  //               ))),
  //       Expanded(
  //           flex: 1,
  //           child: TextButton(
  //               onPressed: null,
  //               child: Container(
  //                 margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
  //                 width: MediaQuery.of(context).size.width,
  //                 padding: const EdgeInsets.all(8.0),
  //                 decoration: BoxDecoration(
  //                     color: blueButton,
  //                     border: Border.all(
  //                       color: blueButtonBorder,
  //                     ),
  //                     borderRadius:
  //                         const BorderRadius.all(Radius.circular(10))),
  //                 child: Center(
  //                     child: TextWidget.textGeneralWithColor(
  //                         '${int.parse(year) + 543}', blueButtonText)),
  //               ))),
  //       Expanded(
  //           flex: 1,
  //           child: GestureDetector(
  //             onTap: () async {
  //               setState(() {
  //                 loading = true;
  //               });

  //               dynamic result = await Get.to(const StationListFilterView());
  //               print('object : $result');

  //               if (result != null) {
  //                 var res = await OfficerRequest.getReportList(accessToken,
  //                     'MONTHLY', result['workflow'], result['reportat']);
  //                 setState(() {
  //                   year = result['reportat'].substring(0, 4);
  //                   month = Month.getMonthFullLabel(result['reportat']);
  //                   data = res['data'];
  //                   loading = false;
  //                 });
  //               }else{
  //                 loading = false;
  //               }
  //             },
  //             child: Row(
  //               children: [
  //                 IconButton(
  //                   icon: Image.asset(
  //                     'asset/images/bi_funnel.png',
  //                   ),
  //                   onPressed: () {},
  //                 ),
  //                 TextWidget.textGeneralWithColor('ตัวกรอง', blueButtonText)
  //               ],
  //             ),
  //           ))
  //     ],
  //   );
  // }

  Widget listView() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        // if (formattedDate == '${data[index]['date']}') {
        //   if (data[index]['document'] == null) {
        //     if (widget.role == 'MANAGER') {
        return ListItemWidget.reportListStation(
            context,
            '${data[index]['lite_name']}',
            '${data[index]['state']}',
            '${data[index]['date']}',
            '${data[index]['state_code']}', () async {
          print(data[index]);
          Station station = Station(
            id: data[index]['id'],
            name: data[index]['name'],
            lite_name: data[index]['lite_name'] != null
                ? data[index]['lite_name']
                : data[index]['name'],
            pivot: Pivot(stationId: data[index]['id'], userId: -1),
          );
          Get.to(ReportListMonthView(
            station: station,
            role: widget.role,
          ));
        });
      },
    );
  }
}
