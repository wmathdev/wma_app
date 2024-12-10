// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:wma_app/api/MapRequest.dart';
import 'package:wma_app/view/login/overview_graph.dart';
import 'package:wma_app/widget/gradient_text.dart';

import '../../Utils/Color.dart';
import '../../Utils/MapUtils.dart';
import '../../Utils/label.dart';
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
  LatLng latlng;
  OverviewDertail({
    Key? key,
    required this.stationId,
    required this.isSubmited,
    required this.isRule,
    required this.latlng,
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
    try {
      return Scaffold(
        body: SafeArea(
            child: loading
                ? Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage('asset/images/waterbg.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
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
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage('asset/images/waterbg.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              appbar(),
                              header(),
                              stationdetail(),
                              const SizedBox(
                                height: 10,
                              ),
                              widget.isSubmited ? waterDetail() : Container(),
                              const SizedBox(
                                height: 3,
                              ),
                              widget.isSubmited
                                  ? Center(
                                      child: TextWidget.textSubTitleWithSize(
                                          'อัพเดทล่าสุด ${data['data']['document']['published_at'] ?? ''}',
                                          13),
                                    )
                                  : Container(),

                              widget.isSubmited ? monthScroll() : Container(),
                              widget.isSubmited
                                  ? monthValueScroll()
                                  : Container(),
                              widget.isSubmited ? compare() : Container(),
                              // widget.isSubmited ? graphHeader() : Container(),
                              // widget.isSubmited ? graphSlider() : Container(),
                              // widget.isSubmited ? graphFilter() : Container(),
                              // widget.isSubmited
                              //     ? const SizedBox(
                              //         height: 10,
                              //       )
                              //     : Container(),
                              // widget.isSubmited ? colorInfo() : Container(),
                              //widget.isSubmited ? graph() : Container(),
                              Container(
                                  height: 70,
                                  child: ButtonApp.buttonSecondaryGradient2(
                                      context,
                                      'ดูข้อมูลสถิติ รายสัปดาห์ / รายเดือน / รายไตรมาส และรายปี',
                                      () async {
                                    Get.to(OverviewGraph(
                                      stationId: widget.stationId,
                                      isSubmited: widget.isSubmited,
                                      isRule: widget.isRule,
                                      latlng: widget.latlng,
                                    ));
                                  })),
                              const SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
      );
    } catch (e) {
      print('error');
    }

    return Scaffold(
      body: SafeArea(
          child: loading
              ? Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('asset/images/waterbg.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
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
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('asset/images/waterbg.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            appbar(),
                            header(),
                            stationdetail(),
                            const SizedBox(
                              height: 10,
                            ),
                            // widget.isSubmited ? waterDetail() : Container(),
                            const SizedBox(
                              height: 3,
                            ),
                            monthScroll(),
                            monthValueScroll(),

                            GestureDetector(
                              onTap: () {
                                Get.to(const VocabDetail());
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                // padding: EdgeInsets.all(10),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Center(
                                    child:
                                        TextWidget.textTitle('อ่านเพิ่มเติม')),
                              ),
                            ),
                            // compare(),
                            // Container(
                            //     height: 70,
                            //     child: ButtonApp.buttonSecondaryGradient2(
                            //         context,
                            //         'ดูข้อมูลสถิติ รายสัปดาห์ / รายเดือน / รายไตรมาส และรายปี',
                            //         () async {
                            //       Get.to(OverviewGraph(
                            //         stationId: widget.stationId,
                            //         isSubmited: widget.isSubmited,
                            //         isRule: widget.isRule,
                            //         latlng: widget.latlng,
                            //       ));
                            //     })),
                            // const SizedBox(
                            //   height: 30,
                            // )
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
    );
  }

  Widget appbar() {
    return Container(
      height: 60,
      color: Colors.transparent,
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
              child: Image.asset('asset/images/arrow_left_n.png')),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
          ),
          Image.asset('asset/images/wma_header.png'),
        ],
      ),
    );
  }

  Widget header() {
    bool _customTileExpanded = false;
    return Row(
      children: [
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: TextWidget.textTitleBold(data['data']['station']['name'])),
      ],
    );
  }

  Widget stationdetail() {
    bool _customTileExpanded = false;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        // controlAffinity: ListTileControlAffinity.trailing,
        iconColor: Colors.white,
        title: Container(
          transform: Matrix4.translationValues(40, 0, 0),
          child: Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(children: [
                      TextWidget.textSubTitleWithSizeGradient2(
                          'ข้อมูลเพิ่มเติม', 10, blueSelected),
                      SizedBox(
                        width: 5,
                      ),
                      Image.asset('asset/images/arrowdown.png')
                    ])),
              ]),
        ),
        trailing: const SizedBox(),
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            padding: EdgeInsets.all(3),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Row(children: [
              SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('asset/images/overviewmarker.png')),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                  child: GestureDetector(
                onTap: () async {
                  await MapUtils.openMap(
                      widget.latlng.latitude, widget.latlng.longitude);
                },
                child: TextWidget.textTitle(
                    data['data']['station']['address'] ?? '-'),
              )),
            ]),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            padding: EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(children: [
              SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('asset/images/overviewname.png')),
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
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(children: [
              SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('asset/images/overviewphone.png')),
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
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Row(children: [
              SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('asset/images/overviewemail.png')),
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
        Container(
          // height: MediaQuery.of(context).size.height / 6,
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.width * 0.25,
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Image.asset(
                          'asset/images/cloud.png',
                        )),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ปริมาณน้ำเสียที่ผ่านการบำบัดในวันนี้',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: blue_navy_n,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GradientText(
                              data['data']['document'] == null
                                  ? '-'
                                  : Label.commaFormat('${data['data']['document']['treated_water']}'),
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: blue_navy_n,
                              ),
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(255, 12, 53, 113),
                                Color.fromARGB(255, 130, 191, 240),
                              ]),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'ลบ.ม.',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: blue_navy_n,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      TextWidget.textSubTitleBoldWithSizeGradient(
                        data['data']['document'] == null
                            ? '-'
                            : '${data['data']['document']['treated_doo']}',
                        55,
                        blue_n,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget.textSubTitleWithSizeColor(
                              'mg/I', 15, Colors.black),
                          TextWidget.textSubTitleWithSizeColor(
                              'ค่ามาตรฐานออกซิเจนในน้ำ\nDissolved Oxygen (Do)',
                              10,
                              Colors.black26)
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: blue_navy_n,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget.textSubTitleWithSizeColor(
                              data['data']['document'] == null
                                  ? '-'
                                  : data['data']['document']['evaluate']
                                          ['result']
                                      ? 'ผ่าน'
                                      : 'ไม่ผ่าน',
                              15,
                              Colors.black),
                          TextWidget.textSubTitleWithSizeColor(
                              'คุณภาพ\n', 10, Colors.black26)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
        height: MediaQuery.of(context).size.height * 0.1,
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
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: ListView.builder(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          itemCount: data2.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: daySelect[index] ? greyBG : Colors.white,
              ),
              margin: EdgeInsets.all(3),
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Card(
                    color: daySelect[index] ? blue_n : Colors.white,
                    child: SizedBox(
                      width: 100,
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
                      width: 100,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: data2[index]['document'] != null
                          ? Column(
                              children: [
                                TextWidget.textSubTitleBoldWithSizeGradient(
                                    '${data2[index]['document']['treated_doo']}',
                                    25,
                                    blueGreen),
                                SizedBox(
                                  width: 10,
                                ),
                                TextWidget.textTitleBold(
                                  'mg/l',
                                ),
                              ],
                            )
                          : Center(
                              child: TextWidget.textTitleBoldWithColor(
                                  '-', blueGreen))),
                  Container(
                    width: 80,
                    height: 1,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 10,
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
                      TextWidget.textTitleWithColorSize('pH', Colors.black, 13)
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 80,
                    height: 1,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 5,
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
                      TextWidget.textTitleWithColorSize('°C', Colors.black, 13)
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
        Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    TextWidget.textSubTitleBold('เปรียบเทียบ'),
                  ]),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                          width: 70,
                          child: TextWidget.textTitleWithColorSize(
                              'ค่ามาตรฐาน', Colors.black, 10)),
                      Container(
                        width: 70,
                        height: 30,
                        decoration: BoxDecoration(
                          color: blue_n,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextWidget.textSubTitleWithSizeColor(
                                'วันที่ ${data2[defaultposition.toInt()]['date'].toString().substring(8)}',
                                10,
                                Colors.white),
                          ),
                        ),
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
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Column(
                            children: [
                              TextWidget.textTitleBoldWithColor(
                                  'ค่า DO', blue_n)
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                          width: 35,
                          child: data2[defaultposition.toInt()]['document'] !=
                                  null
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
                                  ? blue_n
                                  : red_n,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: EdgeInsets.all(5),
                          width: 40,
                          child: Center(
                              child: getResultDOO(data['data']['measure'])
                                  ? TextWidget.textTitleBoldWithColorCompare(
                                      'ผ่าน', Colors.white)
                                  : TextWidget.textTitleBoldWithColorCompare(
                                      'ไม่ผ่าน', Colors.white))),
                    ]),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Column(
                            children: [
                              TextWidget.textTitleBoldWithColor(
                                  'ค่า pH', blue_n)
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                          width: 35,
                          child: data2[defaultposition.toInt()]['document'] !=
                                  null
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
                                  ? blue_n
                                  : red_n,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: EdgeInsets.all(5),
                          width: 40,
                          child: Center(
                              child: getResultPH(data['data']['measure'])
                                  ? TextWidget.textTitleBoldWithColorCompare(
                                      'ผ่าน', Colors.white)
                                  : TextWidget.textTitleBoldWithColorCompare(
                                      'ไม่ผ่าน', Colors.white))),
                    ]),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Column(
                            children: [
                              TextWidget.textTitleBoldWithColor(
                                  'ค่า อุณหภูมิ', blue_n)
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                          width: 35,
                          child: data2[defaultposition.toInt()]['document'] !=
                                  null
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
                                  ? blue_n
                                  : red_n,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: EdgeInsets.all(5),
                          width: 40,
                          child: Center(
                              child: getResultTEMP(data['data']['measure'])
                                  ? TextWidget.textTitleBoldWithColorCompare(
                                      'ผ่าน', Colors.white)
                                  : TextWidget.textTitleBoldWithColorCompare(
                                      'ไม่ผ่าน', Colors.white))),
                    ]),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(const VocabDetail());
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  // padding: EdgeInsets.all(10),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(child: TextWidget.textTitle('อ่านเพิ่มเติม')),
                ),
              ),
            ],
          ),
        )
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
