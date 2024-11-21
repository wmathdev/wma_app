// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:wma_app/Utils/Color.dart';
import 'package:wma_app/api/MapRequest.dart';
import 'package:wma_app/view/graph/doographmonth.dart';
import 'package:wma_app/view/graph/doographquarter.dart';
import 'package:wma_app/view/graph/doographweek.dart';
import 'package:wma_app/view/graph/doographyear.dart';
import 'package:wma_app/view/graph/phgraphmonth.dart';
import 'package:wma_app/view/graph/phgraphquarter.dart';
import 'package:wma_app/view/graph/phgraphweek.dart';
import 'package:wma_app/view/graph/phgraphyear.dart';
import 'package:wma_app/view/graph/tempgraphmonth.dart';
import 'package:wma_app/view/graph/tempgraphquarter.dart';
import 'package:wma_app/view/graph/tempgraphweek.dart';
import 'package:wma_app/view/graph/tempgraphyear.dart';
import 'package:wma_app/widget/button_app.dart';
import 'package:wma_app/widget/gradient_text.dart';
import 'package:wma_app/widget/text_widget.dart';

class OverviewGraph extends StatefulWidget {
  String stationId;
  bool isSubmited;
  bool isRule;
  LatLng latlng;
  OverviewGraph({
    Key? key,
    required this.stationId,
    required this.isSubmited,
    required this.isRule,
    required this.latlng,
  }) : super(key: key);

  @override
  State<OverviewGraph> createState() => _OverviewGraphState();
}

class _OverviewGraphState extends State<OverviewGraph> {
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
                      child: Stack(children: [
                    Column(children: [
                      appbar(),
                      header(),
                      const SizedBox(
                        height: 10,
                      ),
                      // widget.isSubmited ? waterDetail() : Container(),
                      const SizedBox(
                        height: 3,
                      ),
                      // widget.isSubmited
                      //     ? Center(
                      //         child: TextWidget.textSubTitleWithSize(
                      //             'อัพเดทล่าสุด ${data['data']['document']['published_at']  ?? ''}',
                      //             13),
                      //       )
                      //     : Container(),
                      menu(),
                      graphFilter(),
                      graph()
                    ])
                  ])))),
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

  Widget graph() {
    if (graphHeaderIndex[0]) {
      print('object 0');
      if (graphFilterIndex[0]) {
        return DooGraphWeek(
            data: statisticDataDooWeek['data']['report'],
            rule: getRuleDOOValue(data['data']['measure']));
      } else if (graphFilterIndex[1]) {
        // return dooMONTHgraph();
        return DooGraphMonth(
          data: statisticDataDooMonth['data']['report'],
          rule: getRuleDOOValue(data['data']['measure']),
        );
      } else if (graphFilterIndex[2]) {
        // return dooQuartergraph();
        return DooGraphQuarter(
            data: statisticDataDooQuater['data']['report'],
            rule: getRuleDOOValue(data['data']['measure']));
      } else if (graphFilterIndex[3]) {
        return DooYearGraph(
            data: statisticDataDooYear['data']['report'],
            rule: getRuleDOOValue(data['data']['measure']));
      }
    } else if (graphHeaderIndex[1]) {
      print('object 1');
      if (graphFilterIndex[0]) {
        // return phWEEKgraph();
        return PhGraphWeek(
            data: statisticDataPHWeek['data']['report'],
            rule: getRulePHValue(data['data']['measure']));
      } else if (graphFilterIndex[1]) {
        // return phMONTHgraph();
        return PhGraphMonth(
            data: statisticDataPHMonth['data']['report'],
            rule: getRulePHValue(data['data']['measure']));
      } else if (graphFilterIndex[2]) {
        // return phQuartergraph();
        return PhGraphQuarter(
            data: statisticDataPHQuater['data']['report'],
            rule: getRulePHValue(data['data']['measure']));
      } else if (graphFilterIndex[3]) {
        // return phYeargraph();
        return PhGraphYear(
            data: statisticDataPHYear['data']['report'],
            rule: getRulePHValue(data['data']['measure']));
      }
    } else if (graphHeaderIndex[2]) {
      print('object 2');
      if (graphFilterIndex[0]) {
        return TempGraphWeek(
            data: statisticDataTEMPWeek['data']['report'],
            rule: getRuleTEMPValue(data['data']['measure']));
      } else if (graphFilterIndex[1]) {
        return TempGraphMonth(
            data: statisticDataTEMPMonth['data']['report'],
            rule: getRuleTEMPValue(data['data']['measure']));
      } else if (graphFilterIndex[2]) {
        // return tempQuartergraph();
        return TempGraphQuarter(
            data: statisticDataTEMPQuater['data']['report'],
            rule: getRuleTEMPValue(data['data']['measure']));
      } else if (graphFilterIndex[3]) {
        // return tempYeargraph();
        return TempGraphYear(
            data: statisticDataTEMPYear['data']['report'],
            rule: getRuleTEMPValue(data['data']['measure']));
      }
    }

    return Container();
  }

  int _current = 0;
  Widget menu() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        CarouselSlider.builder(
            itemCount: 3,
            options: CarouselOptions(
              enlargeCenterPage: true,
              aspectRatio: 5.0,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  loading = true;
                });

                if (_current == 0) {
                  graphHeaderIndex = [false, true, false];
                  setState(() {
                    _current = index;
                    loading = false;
                  });
                } else if (_current == 1) {
                  graphHeaderIndex = [false, false, true];
                  setState(() {
                    _current = index;
                    loading = false;
                  });
                } else {
                  graphHeaderIndex = [true, false, false];
                  setState(() {
                    _current = index;
                    loading = false;
                  });
                }
              },
            ),
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      TextWidget.textSubTitleBoldWithSizeGradient(
                          itemIndex == 0
                              ? 'DO'
                              : itemIndex == 1
                                  ? 'pH'
                                  : 'Temperature',
                          30,
                          Colors.white),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget.textTitleBold(
                              itemIndex == 1 ? 'Dissolved oxygen' : ''),
                          TextWidget.textTitleBold(itemIndex == 1
                              ? 'ค่ามาตรฐานออกซิเจนในน้ำ'
                              : itemIndex == 2
                                  ? 'ค่าความเป็นกรด-ด่าง'
                                  : 'ค่าอุณหภูมิ')
                        ],
                      )
                    ],
                  ),
                ),
              );

              //  ListItemWidget.newsCard_n(
              //     context,
              //     news[itemIndex]['title']['rendered'],
              //     news[itemIndex]['jetpack_featured_media_url'],
              //     news[itemIndex],
              //     showDate(news[itemIndex]['date']));
            }),
        const SizedBox(
          height: 10,
        ),
      ],
    );
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.width * 0.3,
                        width: MediaQuery.of(context).size.width * 0.3,
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
                                  : '${data['data']['document']['treated_doo']}',
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
}
