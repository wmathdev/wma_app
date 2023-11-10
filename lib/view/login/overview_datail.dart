// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:wma_app/api/MapRequest.dart';

import '../../Utils/Color.dart';
import '../../widget/button_app.dart';
import '../../widget/text_widget.dart';
import '../graph/TempGraphMonth.dart';
import '../graph/doographmonth.dart';
import '../graph/doographquarter.dart';
import '../graph/doographweek.dart';
import '../graph/doographyear.dart';
import '../graph/linechart.dart';
import '../graph/phgraphmonth.dart';
import '../graph/phgraphquarter.dart';
import '../graph/phgraphweek.dart';
import '../graph/phgraphyear.dart';
import '../graph/tempgraphquarter.dart';
import '../graph/tempgraphweek.dart';
import '../graph/tempgraphyear.dart';
import 'vocab_detail.dart';

class OverviewDertail extends StatefulWidget {
  String stationId;
  bool isSubmited;
  bool isRule;
  OverviewDertail({
    Key? key,
    required this.stationId,
    required this.isSubmited,
    required this.isRule,
  }) : super(key: key);

  @override
  State<OverviewDertail> createState() => _OverviewDertailState();
}

class _OverviewDertailState extends State<OverviewDertail> {
  dynamic data;

  var loading = true;

  List<dynamic> listdata = [];
  List<bool> monthSelect = [];
  List<bool> daySelect = [];

  dynamic statisticDataDooWeek;
  dynamic statisticDataDooMonth;
  dynamic statisticDataDooQuater;
  dynamic statisticDataDooYear;

  dynamic statisticDataPHWeek;
  dynamic statisticDataPHMonth;
  dynamic statisticDataPHQuater;
  dynamic statisticDataPHYear;

  dynamic statisticDataTEMPWeek;
  dynamic statisticDataTEMPMonth;
  dynamic statisticDataTEMPQuater;
  dynamic statisticDataTEMPYear;

  List<bool> graphFilterIndex = [true, false, false, false];
  List<bool> graphHeaderIndex = [true, false, false];

  Future<void> _getData() async {
    var res = await MapRequest.getMapStation(widget.stationId);
    setState(() {
      data = res;
      listdata = data['data']['report'];
    });
    if (!widget.isSubmited) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _getDataStatisticDoo() async {
    var res =
        await MapRequest.getStationStatistic(widget.stationId, 'DOO', 'WEEK');
    var res2 =
        await MapRequest.getStationStatistic(widget.stationId, 'DOO', 'MONTH');
    var res3 = await MapRequest.getStationStatistic(
        widget.stationId, 'DOO', 'QUARTER');
    var res4 =
        await MapRequest.getStationStatistic(widget.stationId, 'DOO', 'YEAR');
    setState(() {
      statisticDataDooWeek = res;
      statisticDataDooMonth = res2;
      statisticDataDooQuater = res3;
      statisticDataDooYear = res4;
    });
    _getDataStatisticPH();
  }

  Future<void> _getDataStatisticPH() async {
    var res =
        await MapRequest.getStationStatistic(widget.stationId, 'PH', 'WEEK');
    var res2 =
        await MapRequest.getStationStatistic(widget.stationId, 'PH', 'MONTH');
    var res3 =
        await MapRequest.getStationStatistic(widget.stationId, 'PH', 'QUARTER');
    var res4 =
        await MapRequest.getStationStatistic(widget.stationId, 'PH', 'YEAR');
    setState(() {
      statisticDataPHWeek = res;
      statisticDataPHMonth = res2;
      statisticDataPHQuater = res3;
      statisticDataPHYear = res4;
    });
    _getDataStatisticTEMP();
  }

  Future<void> _getDataStatisticTEMP() async {
    var res =
        await MapRequest.getStationStatistic(widget.stationId, 'TEMP', 'WEEK');
    var res2 =
        await MapRequest.getStationStatistic(widget.stationId, 'TEMP', 'MONTH');
    var res3 = await MapRequest.getStationStatistic(
        widget.stationId, 'TEMP', 'QUARTER');
    var res4 =
        await MapRequest.getStationStatistic(widget.stationId, 'TEMP', 'YEAR');
    setState(() {
      statisticDataTEMPWeek = res;
      statisticDataTEMPMonth = res2;
      statisticDataTEMPQuater = res3;
      statisticDataTEMPYear = res4;
      loading = false;
    });
  }

  var outputDate = '';

  late ScrollController _controller;

  var defaultposition = 0.0;

  var graphSliderIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();

    _getDataStatisticDoo();

    var today = DateTime.now();
    final outputFormat = DateFormat('yyyy-MM-dd');

    outputDate = outputFormat.format(today);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                          'asset/lottie/animation_lk0uamsc.json',
                          width: 200,
                          height: 200,
                          fit: BoxFit.fill,
                        ),
                        TextWidget.textGeneralWithColor(
                            'กรุณารอสักครู่...', blueSelected)
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      appbar(),
                      header(),
                      stationdetail(),
                      const SizedBox(
                        height: 10,
                      ),
                      widget.isSubmited ? waterDetail() : Container(),
                      monthScroll(),
                      monthValueScroll(),
                      widget.isSubmited ? compare() : Container(),
                      widget.isSubmited ? graphHeader() : Container(),
                      widget.isSubmited ? graphSlider() : Container(),
                      widget.isSubmited ? graphFilter() : Container(),
                      widget.isSubmited
                          ? const SizedBox(
                              height: 10,
                            )
                          : Container(),
                      widget.isSubmited ? colorInfo() : Container(),
                      widget.isSubmited ? graph() : Container(),
                    ],
                  ),
                )),
    );
  }

  Widget appbar() {
    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Image.asset('asset/images/back.png')),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
          ),
          Image.asset('asset/images/baricon.png'),
        ],
      ),
    );
  }

  Widget header() {
    bool _customTileExpanded = false;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.18,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: Stack(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset('asset/images/detailbg.png',
                        fit: BoxFit.fitWidth)),
                Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Center(
                        child: TextWidget.textTitleBoldCenter(
                            data['data']['station']['name']),
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget stationdetail() {
    bool _customTileExpanded = false;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        controlAffinity: ListTileControlAffinity.trailing,
        iconColor: Colors.white,
        title: Center(
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              TextWidget.textGeneralWithColor('ข้อมูลเพิ่มเติม', blueSelected),
              const SizedBox(
                width: 10,
              ),
              Image.asset('asset/images/bi_chevron-rightblue.png')
            ])),
        trailing: const Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                border: Border.all(color: greyBorder),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Row(children: [
              SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('asset/images/carbon_location.png')),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                  child: TextWidget.textTitle(
                      data['data']['station']['address'] ?? '-')),
            ]),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                border: Border.all(color: greyBorder),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0), topRight: Radius.circular(0))),
            child: Row(children: [
              SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('asset/images/carbon_identification.png')),
              const SizedBox(
                width: 5,
              ),
              TextWidget.textTitle(
                  data['data']['station']['manager']['name'] ?? '-'),
            ]),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                border: Border.all(color: greyBorder),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0), topRight: Radius.circular(0))),
            child: Row(children: [
              SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('asset/images/carbon_phone.png')),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                  onTap: () {
                    if (data['data']['station']['manager']['phone_number'] !=
                        null) {
                      final Uri _url = Uri.parse(
                          "tel://${data['data']['station']['manager']['phone_number']}");
                      _launch(_url);
                    }
                  },
                  child: TextWidget.textTitleWithColor(
                      data['data']['station']['manager']['phone_number'] ?? '-',
                      blueSelected)),
            ]),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                border: Border.all(color: greyBorder),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Row(children: [
              SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('asset/images/carbon_email.png')),
              const SizedBox(
                width: 5,
              ),
              TextWidget.textTitle(
                  data['data']['station']['manager']['email'] ?? '-'),
            ]),
          ),
        ],
        onExpansionChanged: (bool expanded) {
          setState(() {
            _customTileExpanded = expanded;
          });
        },
      ),
    );
  }

  Future<void> _launch(Uri url) async {
    await canLaunchUrl(url) ? await launchUrl(url) : _showSnackBar();
  }

  _showSnackBar() {
    const snackBar = SnackBar(
      content: Text('เกิดข้อผิดพลาด'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget waterDetail() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Image.asset('asset/images/wave2.png', fit: BoxFit.fitHeight),
        ),
        Center(
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  blueGreen2,
                  Colors.white,
                ],
              )),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 80,
                              height: 80,
                              child: Image.asset(
                                'asset/images/water2.png',
                              )),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget.textTitle(
                                  'ปริมาณน้ำเสียที่ผ่านการบำบัดในวันนี้'),
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextWidget.textBigWithColor(
                                        data['data']['document']
                                                    ['treated_water'] !=
                                                null
                                            ? '${data['data']['document']['treated_water']}'
                                            : '-',
                                        blueSelected),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    TextWidget.textSubTitleWithSizeColor(
                                        'ลบ.ม.', 20, Colors.grey),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height * 0.15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: widget.isRule
                                ? blueGreenlight
                                : Color.fromARGB(255, 255, 246, 174)),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                            color: widget.isRule
                                                ? blueGreen
                                                : Color.fromARGB(
                                                    255, 255, 209, 102)),
                                      ),
                                      Container(
                                          padding: const EdgeInsets.all(10),
                                          child: widget.isRule
                                              ? Image.asset(
                                                  'asset/images/circlewater.png')
                                              : Image.asset(
                                                  'asset/images/circlewateryellow.png')),
                                      TextWidget.textTitleBoldWithColor(
                                          data['data']['document'] == null
                                              ? '-'
                                              : '${data['data']['document']['treated_doo']}',
                                          Colors.white)
                                    ])),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextWidget.textBigWithColor(
                                          data['data']['document'] == null
                                              ? '- mg/l'
                                              : '${data['data']['document']['treated_doo']} mg/l',
                                          widget.isRule
                                              ? blueGreen
                                              : Color.fromARGB(
                                                  255, 255, 209, 102)),
                                      TextWidget.textSubTitleWithSizeColor(
                                          'ค่ามาตรฐานออกซิเจนในน้ำ\nDissolved oxygen (Do)',
                                          8,
                                          widget.isRule
                                              ? blueGreen
                                              : Color.fromARGB(
                                                  255, 255, 209, 102))
                                    ],
                                  ),
                                )),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextWidget.textBigWithColor(
                                          data['data']['document'] == null
                                              ? '-'
                                              : data['data']['document']
                                                      ['evaluate']['result']
                                                  ? 'ผ่าน'
                                                  : 'ไม่ผ่าน',
                                          widget.isRule
                                              ? blueGreen
                                              : Color.fromARGB(
                                                  255, 255, 209, 102)),
                                      TextWidget.textSubTitleWithSizeColor(
                                          'คุณภาพ',
                                          8,
                                          widget.isRule
                                              ? blueGreen
                                              : Color.fromARGB(
                                                  255, 255, 209, 102))
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ],
    );
  }

  Widget monthScroll() {
    for (var i = 0; i < listdata.length; i++) {
      if (i == listdata.length - 1) {
        monthSelect.add(true);
      } else {
        monthSelect.add(false);
      }
    }
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: listdata.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: 50,
                child: ButtonApp.buttonTab(
                    context, listdata[index]['date']['month'], () {
                  monthSelect.clear();
                  for (var i = 0; i < listdata.length; i++) {
                    if (i == index) {
                      monthSelect.add(true);
                    } else {
                      monthSelect.add(false);
                    }
                  }
                  setState(() {});
                }, monthSelect[index]),
              ),
            );
          },
        ));
  }

  Widget monthValueScroll() {
    var index = 0;
    for (var i = 0; i < listdata.length; i++) {
      if (monthSelect[i]) {
        index = i;
      }
    }
    List<dynamic> data2 = listdata[index]['documents'];

    var today = DateTime.now();
    final outputFormat = DateFormat('yyyy-MM-dd');
    outputDate = outputFormat.format(today);

    daySelect.clear();

    for (var i = 0; i < data2.length; i++) {
      if (outputDate == '${data2[i]['date']}') {
        daySelect.add(true);
        defaultposition = i.toDouble();
      } else {
        daySelect.add(false);
      }
    }

    final ScrollController _controller =
        ScrollController(initialScrollOffset: defaultposition);

    return Container(
        height: MediaQuery.of(context).size.height * 0.45,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: ListView.builder(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          itemCount: data2.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(5),
              color: daySelect[index] ? greyBG : Colors.white,
              child: Column(
                children: [
                  Card(
                    color: daySelect[index] ? blueSelected : Colors.white,
                    child: SizedBox(
                      width: 80,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: TextWidget.textTitleBoldWithColor(
                              'วันที่ ${data2[index]['date'].toString().substring(8)}',
                              daySelect[index] ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                      width: 80,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffe2f8f9)),
                      child: data2[index]['document'] != null
                          ? Center(
                              child: TextWidget.textTitleBoldWithColor(
                                  'DO\n${data2[index]['document']['treated_doo']}\nmg/l',
                                  blueGreen),
                            )
                          : Center(
                              child: TextWidget.textTitleBoldWithColor(
                                  '-', blueGreen))),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset('asset/images/ph.png'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      data2[index]['document'] != null
                          ? TextWidget.textSubTitleBoldPh(
                              '${data2[index]['document']['treated_ph']}')
                          : TextWidget.textSubTitleBold('-'),
                      const SizedBox(
                        width: 5,
                      ),
                      TextWidget.textTitleWithColorSize('pH', Colors.grey, 13)
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset('asset/images/temp.png'),
                  ),
                  Row(
                    children: [
                      data2[index]['document'] != null
                          ? TextWidget.textSubTitleBoldPh(
                              '${data2[index]['document']['treated_temp']}')
                          : TextWidget.textSubTitleBold('-'),
                      const SizedBox(
                        width: 5,
                      ),
                      TextWidget.textTitleWithColorSize('°C', Colors.grey, 13)
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }

  Widget compare() {
    var index = 0;
    for (var i = 0; i < listdata.length; i++) {
      if (monthSelect[i]) {
        index = i;
      }
    }
    List<dynamic> data2 = listdata[index]['documents'];
    return Column(
      children: [
        Center(
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white,
                  blueGreen2,
                ],
              )),
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget.textSubTitleWithSizeColor(
                              'เปรียบเทียบ', 20, Colors.black),
                        ]),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: greyBorder),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                                width: 100,
                                child: TextWidget.textTitleWithColorSize(
                                    'ค่ามาตรฐาน', Colors.black, 10)),
                            SizedBox(
                              width: 40,
                              child: TextWidget.textSubTitleWithSizeColor(
                                  'วันที่ ${data2[defaultposition.toInt()]['date'].toString().substring(8)}',
                                  10,
                                  blueSelected),
                            ),
                            SizedBox(
                                width: 60,
                                child: TextWidget.textTitleWithColorSize(
                                    'เกณฑ์มาตรฐาน', Colors.black, 10)),
                            SizedBox(
                                width: 35,
                                child: TextWidget.textTitleWithColorSize(
                                    'สรุปผล', Colors.black, 10))
                          ]),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: greyBorder),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset(
                                            'asset/images/docompare.png')),
                                    TextWidget.textTitleBoldWithColor(
                                        'ค่า DO', blueSelected)
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                                width: 35,
                                child: data2[index]['document'] != null
                                    ? TextWidget.textTitleWithColorSize(
                                        '${data2[defaultposition.toInt()]['document']['treated_doo']} mg/l',
                                        Colors.black,
                                        10)
                                    : TextWidget.textTitleWithColorSize(
                                        '-', Colors.black, 10)),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                                width: 60,
                                child: TextWidget.textTitleWithColorSize(
                                    '${getRuleDOO(data['data']['measure'])} mg/l',
                                    Colors.black,
                                    10)),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: getResultDOO(data['data']['measure'])
                                        ? blueGreen3
                                        : red_range,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                padding: EdgeInsets.all(5),
                                width: 40,
                                child: Center(
                                    child: getResultDOO(data['data']['measure'])
                                        ? TextWidget
                                            .textTitleBoldWithColorCompare(
                                                'ผ่าน', blueGreen2)
                                        : TextWidget
                                            .textTitleBoldWithColorCompare(
                                                'ไม่ผ่าน',
                                                const Color.fromARGB(
                                                    255, 241, 188, 184)))),
                          ]),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: greyBorder),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset(
                                            'asset/images/phcompare.png')),
                                    TextWidget.textTitleBoldWithColor(
                                        'ค่า pH', blueSelected)
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                                width: 35,
                                child: data2[index]['document'] != null
                                    ? TextWidget.textTitleWithColorSize(
                                        '${data2[defaultposition.toInt()]['document']['treated_ph']} pH',
                                        Colors.black,
                                        10)
                                    : TextWidget.textTitleWithColorSize(
                                        '-', Colors.black, 10)),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                                width: 60,
                                child: TextWidget.textTitleWithColorSize(
                                    '${getRulePH(data['data']['measure'])} pH',
                                    Colors.black,
                                    10)),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: getResultPH(data['data']['measure'])
                                        ? blueGreen3
                                        : red_range,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                padding: EdgeInsets.all(5),
                                width: 40,
                                child: Center(
                                    child: getResultPH(data['data']['measure'])
                                        ? TextWidget
                                            .textTitleBoldWithColorCompare(
                                                'ผ่าน', blueGreen2)
                                        : TextWidget
                                            .textTitleBoldWithColorCompare(
                                                'ไม่ผ่าน',
                                                const Color.fromARGB(
                                                    255, 241, 188, 184)))),
                          ]),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: greyBorder),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset(
                                            'asset/images/tempcompare.png')),
                                    TextWidget.textTitleBoldWithColor(
                                        'ค่า อุณหภูมิ', blueSelected)
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                                width: 35,
                                child: data2[index]['document'] != null
                                    ? TextWidget.textTitleWithColorSize(
                                        '${data2[defaultposition.toInt()]['document']['treated_temp']} °C',
                                        Colors.black,
                                        10)
                                    : TextWidget.textTitleWithColorSize(
                                        '-', Colors.black, 10)),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                                width: 60,
                                child: TextWidget.textTitleWithColorSize(
                                    '${getRuleTEMP(data['data']['measure'])} °C',
                                    Colors.black,
                                    10)),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: getResultTEMP(data['data']['measure'])
                                        ? blueGreen3
                                        : red_range,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                padding: EdgeInsets.all(5),
                                width: 40,
                                child: Center(
                                    child:
                                        getResultTEMP(data['data']['measure'])
                                            ? TextWidget
                                                .textTitleBoldWithColorCompare(
                                                    'ผ่าน', blueGreen2)
                                            : TextWidget
                                                .textTitleBoldWithColorCompare(
                                                    'ไม่ผ่าน',
                                                    const Color.fromARGB(
                                                        255, 241, 188, 184)))),
                          ]),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(const VocabDetail());
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        // padding: EdgeInsets.all(10),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child:
                            Center(child: TextWidget.textTitle('อ่านเพิ่มเติม')),
                      ),
                    ),
                  ],
                ),
              )),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Image.asset('asset/images/wave3.png', fit: BoxFit.fitHeight),
        ),
      ],
    );
  }

  Widget graphHeader() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            TextWidget.textSubTitle('สถิติ')
          ],
        )
      ],
    );
  }

  Widget graphSlider() {
    return Stack(
      children: [
        Container(
          height: 100,
          margin: const EdgeInsets.all(30),
          child: Card(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Row(
                children: [
                  graphHeaderIndex[0]
                      ? Image.asset('asset/images/mdi_water-check-outline.png')
                      : graphHeaderIndex[1]
                          ? Image.asset(
                              'asset/images/mdi_water-check-outline2.png')
                          : Image.asset(
                              'asset/images/mdi_water-check-outline3.png'),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      graphHeaderIndex[0]
                          ? TextWidget.textSubTitleBold('Do')
                          : graphHeaderIndex[1]
                              ? TextWidget.textSubTitleBold('pH')
                              : TextWidget.textSubTitleBold('Temp'),
                      graphHeaderIndex[0]
                          ? TextWidget.textTitleBold('Dissolved oxygen')
                          : TextWidget.textTitleBold(''),
                      graphHeaderIndex[0]
                          ? TextWidget.textTitleBoldWithColor(
                              'ค่าออกซิเจนละลายในน้ำ', Colors.grey)
                          : graphHeaderIndex[1]
                              ? TextWidget.textTitleBoldWithColor(
                                  'ค่าความเป็นกรด-ด่าง', Colors.grey)
                              : TextWidget.textTitleBoldWithColor(
                                  'ค่าอุณหภูมิ', Colors.grey),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                print('object');
                setState(() {
                  loading = true;
                });

                if (graphHeaderIndex[0]) {
                  graphHeaderIndex = [false, false, true];
                  setState(() {
                    loading = false;
                  });
                } else if (graphHeaderIndex[1]) {
                  graphHeaderIndex = [true, false, false];
                  setState(() {
                    loading = false;
                  });
                } else {
                  graphHeaderIndex = [false, true, false];
                  setState(() {
                    loading = false;
                  });
                }
              },
              child: SizedBox(
                height: 150,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('asset/images/bi_chevron-rightbtn.png')
                    ]),
              ),
            ),
            GestureDetector(
              onTap: () {
                print('object');
                setState(() {
                  loading = true;
                });

                if (graphHeaderIndex[0]) {
                  graphHeaderIndex = [false, true, false];
                  setState(() {
                    loading = false;
                  });
                } else if (graphHeaderIndex[1]) {
                  graphHeaderIndex = [false, false, true];
                  setState(() {
                    loading = false;
                  });
                } else {
                  graphHeaderIndex = [true, false, false];
                  setState(() {
                    loading = false;
                  });
                }
              },
              child: SizedBox(
                height: 150,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('asset/images/bi_chevron-rightbtn2.png')
                    ]),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget graphFilter() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ButtonApp.buttonGraphFilter(context, '1 สัปดาห์', () {
          graphFilterIndex = [true, false, false, false];
          setState(() {});
        }, graphFilterIndex[0]),
        ButtonApp.buttonGraphFilter(context, '1 เดือน', () {
          graphFilterIndex = [false, true, false, false];
          setState(() {});
        }, graphFilterIndex[1]),
        ButtonApp.buttonGraphFilter(context, '3 เดือน', () {
          graphFilterIndex = [false, false, true, false];
          setState(() {});
        }, graphFilterIndex[2]),
        ButtonApp.buttonGraphFilter(context, '1 ปี', () {
          graphFilterIndex = [false, false, false, true];
          setState(() {});
        }, graphFilterIndex[3])
      ],
    );
  }

  Widget colorInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          child: Row(
            children: [
              Image.asset('asset/images/yellowcir.png'),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  TextWidget.textGeneralWithColor('คุณภาพน้ำ', Colors.grey),
                  TextWidget.textGeneral('ก่อนบำบัด'),
                ],
              )
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              Image.asset('asset/images/bluecir.png'),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  TextWidget.textGeneralWithColor('คุณภาพน้ำ', Colors.grey),
                  TextWidget.textGeneral('หลังบำบัด'),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  String getRuleDOO(List<dynamic> measure) {
    for (int i = 0; i < measure.length; i++) {
      if (measure[i]['measure'] == 'treated_doo') {
        return '${ruleLabel(measure[i]['rule']['operator'])}${measure[i]['rule']['value']}';
      }
    }
    return '';
  }

  String getRuleDOOValue(List<dynamic> measure) {
    for (int i = 0; i < measure.length; i++) {
      if (measure[i]['measure'] == 'treated_doo') {
        return '${measure[i]['rule']['value']}';
      }
    }
    return '';
  }

  bool getResultDOO(List<dynamic> measure) {
    for (var i = 0; i < measure.length; i++) {
      if (measure[i]['measure'] == 'treated_doo') {
        return measure[i]['result'];
      }
    }
    return true;
  }

  String getRulePH(List<dynamic> measure) {
    for (int i = 0; i < measure.length; i++) {
      if (measure[i]['measure'] == 'treated_ph') {
        return '${ruleLabel(measure[i]['rule']['operator'])}${measure[i]['rule']['value']}';
      }
    }
    return '';
  }

  String getRulePHValue(List<dynamic> measure) {
    for (int i = 0; i < measure.length; i++) {
      if (measure[i]['measure'] == 'treated_ph') {
        return '${measure[i]['rule']['value']}';
      }
    }
    return '';
  }

  bool getResultPH(List<dynamic> measure) {
    for (var i = 0; i < measure.length; i++) {
      if (measure[i]['measure'] == 'treated_ph') {
        return measure[i]['result'];
      }
    }
    return true;
  }

  String getRuleTEMP(List<dynamic> measure) {
    for (int i = 0; i < measure.length; i++) {
      if (measure[i]['measure'] == 'treated_temp') {
        return '${ruleLabel(measure[i]['rule']['operator'])}${measure[i]['rule']['value']}';
      }
    }
    return '';
  }

  String getRuleTEMPValue(List<dynamic> measure) {
    for (int i = 0; i < measure.length; i++) {
      if (measure[i]['measure'] == 'treated_temp') {
        return '${measure[i]['rule']['value']}';
      }
    }
    return '';
  }

  bool getResultTEMP(List<dynamic> measure) {
    for (var i = 0; i < measure.length; i++) {
      if (measure[i]['measure'] == 'treated_temp') {
        return measure[i]['result'];
      }
    }
    return true;
  }

  String ruleLabel(String rule) {
    if (rule == 'gt') {
      return '>';
    } else if (rule == 'lt') {
      return '<';
    }
    return '';
  }

  Widget graph() {
    if (graphHeaderIndex[0]) {
      print('object 0');
      if (graphFilterIndex[0]) {
        return dooWEEKgraph();
      } else if (graphFilterIndex[1]) {
        return dooMONTHgraph();
      } else if (graphFilterIndex[2]) {
        return dooQuartergraph();
      } else if (graphFilterIndex[3]) {
        return dooYeargraph();
      }
    } else if (graphHeaderIndex[1]) {
      print('object 1');
      if (graphFilterIndex[0]) {
        return phWEEKgraph();
      } else if (graphFilterIndex[1]) {
        return phMONTHgraph();
      } else if (graphFilterIndex[2]) {
        return phQuartergraph();
      } else if (graphFilterIndex[3]) {
        return phYeargraph();
      }
    } else if (graphHeaderIndex[2]) {
      print('object 2');
      if (graphFilterIndex[0]) {
        return tempWEEKgraph();
      } else if (graphFilterIndex[1]) {
        return tempMONTHgraph();
      } else if (graphFilterIndex[2]) {
        return tempQuartergraph();
      } else if (graphFilterIndex[3]) {
        return tempYeargraph();
      }
    }

    return defaultGraph();
  }

  Widget dooYeargraph() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      DooYearGraph(
                        data: statisticDataDooYear['data']['report'],
                        rule: getRuleDOOValue(data['data']['measure']),
                      ),
                    ]),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      DooYearGraph(
                        data: statisticDataDooYear['data']['report'],
                        rule: getRuleDOOValue(data['data']['measure']),
                      ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget dooQuartergraph() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      DooGraphQuarter(
                        data: statisticDataDooQuater['data']['report'],
                        rule: getRuleDOOValue(data['data']['measure']),
                      ),
                    ]),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      DooGraphQuarter(
                        data: statisticDataDooQuater['data']['report'],
                        rule: getRuleDOOValue(data['data']['measure']),
                      ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget dooMONTHgraph() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      DooGraphMonth(
                        data: statisticDataDooMonth['data']['report'],
                        rule: getRuleDOOValue(data['data']['measure']),
                      ),
                    ]),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      DooGraphMonth(
                        data: statisticDataDooMonth['data']['report'],
                        rule: getRuleDOOValue(data['data']['measure']),
                      ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget dooWEEKgraph() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      DooGraphWeek(
                        data: statisticDataDooWeek['data']['report'],
                        rule: getRuleDOOValue(data['data']['measure']),
                      ),
                    ]),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      DooGraphWeek(
                        data: statisticDataDooWeek['data']['report'],
                        rule: getRuleDOOValue(data['data']['measure']),
                      ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget defaultGraph() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      LineChartSample2(
                        data: data['data']['graph'],
                        rule: data['data']['document']['evaluate']['rule']
                            ['value'],
                      ),
                    ]),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.5,
                    color: Colors.white,
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      LineChartSample2(
                        data: data['data']['graph'],
                        rule: data['data']['document']['evaluate']['rule']
                            ['value'],
                      ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget phYeargraph() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      PhGraphYear(
                        data: statisticDataPHYear['data']['report'],
                        rule: getRulePHValue(data['data']['measure']),
                      ),
                    ]),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      PhGraphYear(
                        data: statisticDataPHYear['data']['report'],
                        rule: getRulePHValue(data['data']['measure']),
                      ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget phQuartergraph() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      PhGraphQuarter(
                        data: statisticDataPHQuater['data']['report'],
                        rule: getRulePHValue(data['data']['measure']),
                      ),
                    ]),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      PhGraphQuarter(
                        data: statisticDataPHQuater['data']['report'],
                        rule: getRulePHValue(data['data']['measure']),
                      ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget phMONTHgraph() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      PhGraphMonth(
                        data: statisticDataPHMonth['data']['report'],
                        rule: getRulePHValue(data['data']['measure']),
                      ),
                    ]),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      PhGraphMonth(
                        data: statisticDataPHMonth['data']['report'],
                        rule: getRulePHValue(data['data']['measure']),
                      ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget phWEEKgraph() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      PhGraphWeek(
                        data: statisticDataPHWeek['data']['report'],
                        rule: getRulePHValue(data['data']['measure']),
                      ),
                    ]),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      PhGraphWeek(
                        data: statisticDataPHWeek['data']['report'],
                        rule: getRulePHValue(data['data']['measure']),
                      ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget tempYeargraph() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      TempGraphYear(
                        data: statisticDataTEMPYear['data']['report'],
                        rule: getRuleTEMPValue(data['data']['measure']),
                      ),
                    ]),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      TempGraphYear(
                        data: statisticDataTEMPYear['data']['report'],
                        rule: getRuleTEMPValue(data['data']['measure']),
                      ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget tempQuartergraph() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      TempGraphQuarter(
                        data: statisticDataTEMPQuater['data']['report'],
                        rule: getRuleTEMPValue(data['data']['measure']),
                      ),
                    ]),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      TempGraphQuarter(
                        data: statisticDataTEMPQuater['data']['report'],
                        rule: getRuleTEMPValue(data['data']['measure']),
                      ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget tempMONTHgraph() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      TempGraphMonth(
                        data: statisticDataTEMPMonth['data']['report'],
                        rule: getRuleTEMPValue(data['data']['measure']),
                      ),
                    ]),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      TempGraphMonth(
                        data: statisticDataTEMPMonth['data']['report'],
                        rule: getRuleTEMPValue(data['data']['measure']),
                      ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget tempWEEKgraph() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      TempGraphWeek(
                        data: statisticDataTEMPWeek['data']['report'],
                        rule: getRuleTEMPValue(data['data']['measure']),
                      ),
                    ]),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.white,
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      TempGraphWeek(
                        data: statisticDataPHWeek['data']['report'],
                        rule: getRuleTEMPValue(data['data']['measure']),
                      ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
