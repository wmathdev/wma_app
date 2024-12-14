// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ua_client_hints/ua_client_hints.dart';
import 'package:wma_app/api/MapRequest.dart';

import 'package:wma_app/api/OtherRequest.dart';
import 'package:wma_app/api/dashboardRequest.dart';
import 'package:wma_app/test.dart';
import 'package:wma_app/view/login/list_quality_station.dart';
import 'package:wma_app/view/news/news_list.dart';
import 'package:wma_app/view/station_select/stationSelect.dart';
import 'package:wma_app/widget/gradient_text.dart';

import '../../Utils/Color.dart';
import '../../api/Authentication.dart';
import '../../model/user.dart';
import '../../widget/button_app.dart';
import '../../widget/dialog.dart';
import '../../widget/edittext.dart';
import '../../widget/list_item_widget.dart';
import '../../widget/navigatebar.dart';
import '../../widget/text_widget.dart';
import '../news/news_detail.dart';
import '../report_home/report_home_officer_view.dart';
import '../report_home/report_home_view.dart';
import '../statistic/statistic.dart';
import 'overview.dart';

class Login extends StatefulWidget {
  int tab;
  Login({
    Key? key,
    required this.tab,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _selectedIndex = 0;

  bool loading = true;

  var username = TextEditingController();
  var password = TextEditingController();

  String? _deviceId;

  late var resultNews;
  late var resultTreatedWater;
  late var resultStatistic;

  late dynamic treatedWater;
  var summary = '0';
  String total = '0';
  dynamic qualityOverview;
  var passed = '0';
  var failed = '0';
  var pending = '0';

  var userjson;
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  late User user;
  List<FlSpot> dummyData1 = [];
  List<Color> gradientColors = [
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
  ];

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<dynamic> news = [];

  Future<void> _getNews() async {
    resultNews = await OtherRequest.news();
    setState(() {
      news = resultNews;
    });
  }

  Future<void> _getUser() async {
    final SharedPreferences prefs = await _prefs;
    userjson = (prefs.getString('user') ?? '');
    try {
      user = User.fromJson(userjson, true);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getDashboard() async {
    treatedWater = await MapRequest.getTreatedWater();
    qualityOverview = await MapRequest.getQualityOverview();
    var res1 = await DashboardRequest.getTreatedWater();
    var res2 = await DashboardRequest.getStatistic();
    setState(() {
      summary = treatedWater['data']['summary'];
      total = '${treatedWater['data']['total']}';
      passed = '${qualityOverview['data']['passed']}';
      failed = '${qualityOverview['data']['failed']}';
      pending = '${qualityOverview['data']['pending']}';
      resultTreatedWater = res1;
      resultStatistic = res2;
    });

    List<dynamic> temp = res2['data'];
    dummyData1 = List.generate(temp.length, (index) {
      return FlSpot(double.parse('${temp[index]['month']}'),
          double.parse('${temp[index]['statistic']}'));
    });
  }

  // Generate some dummy data for the cahrt
  // This will be used to draw the red line

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('ออกจาก WMA App'),
            content: new Text('คุณต้องการออกจากแอปพลิเคชัน'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('ไม่'),
              ),
              TextButton(
                onPressed: () => FlutterExitApp.exitApp(iosForceExit: true),
                child: new Text('ใช่'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    if (loading) {
      _getNews();
      _getDashboard();
      _getUser();

      setState(() {
        _selectedIndex = widget.tab;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
          body: SafeArea(
              child: Container(
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
              TextWidget.textGeneralWithColor('กรุณารอสักครู่...', blueSelected)
            ],
          ),
        ),
      )));
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('asset/images/waterbg.jpg'),
                fit: BoxFit.fill,
              ),
            ),
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
                : _selectedIndex == 0
                    ? Container(
                        child: newsTab(),
                      )
                    : _selectedIndex == 1
                        ? const Overview()
                        : _selectedIndex == 2
                            ? Statistic()
                            : contentView(),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(24),
              topLeft: Radius.circular(24),
            ),
            child: BottomNavigationBar(
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: bottomNav_blue,
              unselectedItemColor: Colors.black45,
              currentIndex: _selectedIndex,
              onTap: (int index) {
                print(index);
                setState(() {
                  _selectedIndex = index;
                });
              },
              selectedLabelStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('asset/images/ic_n_news.png')),
                  label: 'ข่าวสาร',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('asset/images/ic_n_overview.png')),
                  label: 'ภาพรวม',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('asset/images/ic_n_stat.png')),
                  label: 'สถิติ',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('asset/images/ic_n_report.png')),
                  label: 'รายงาน',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget statisticTab() {
    List<dynamic> graph = resultStatistic['data'];
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('asset/images/waterbg.jpg'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              blueGradientTop,
              blueGradientBottom,
            ],
          )),
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextWidget.textBigWithColor('สถิติ', Colors.black)
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget.textTitle('ปริมาณน้ำเสียที่ผ่านการบำบัด'),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Card(
                            color: blueButton,
                            child: Column(children: [
                              TextWidget.textGeneral('รายสัปดาห์'),
                              TextWidget.textSubTitleBold('-'),
                              TextWidget.textGeneral('ลบ.ม.'),
                            ]),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Card(
                            color: blueButton,
                            child: Column(children: [
                              TextWidget.textGeneral('รายเดือน'),
                              TextWidget.textSubTitleBold('-'),
                              TextWidget.textGeneral('ลบ.ม.'),
                            ]),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Card(
                            color: blueButton,
                            child: Column(children: [
                              TextWidget.textGeneral('รายปี'),
                              TextWidget.textSubTitleBold('-'),
                              TextWidget.textGeneral('ลบ.ม.'),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextWidget.textBigWithColor('STATISTIC', Colors.blue)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // Container(
              //   margin: const EdgeInsets.all(20),
              //   width:
              //       MediaQuery.of(context).size.width * (0.1 * dummyData1.length),
              //   height: MediaQuery.of(context).size.height * 0.3,
              //   child: LineChart(LineChartData(
              //     titlesData: FlTitlesData(
              //       leftTitles: AxisTitles(
              //           sideTitles: SideTitles(
              //               showTitles: true, getTitlesWidget: leftTitleWidgets)),
              //       bottomTitles: AxisTitles(
              //           sideTitles: SideTitles(
              //               showTitles: true, getTitlesWidget: bottomTitleWidgets)),
              //       rightTitles:
              //           const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              //       topTitles:
              //           const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              //     ),
              //     borderData: FlBorderData(
              //       show: false,
              //       border: Border.all(color: const Color(0xff37434d)),
              //     ),
              //     lineBarsData: [
              //       // The red line
              //       LineChartBarData(
              //         spots: dummyData1,
              //         isCurved: true,
              //         barWidth: 3,
              //         color: Colors.indigo,
              //         gradient: LinearGradient(
              //           colors: gradientColors,
              //         ),
              //         isStrokeCapRound: true,
              //         dotData: const FlDotData(
              //           show: false,
              //         ),
              //         belowBarData: BarAreaData(
              //           show: true,
              //           gradient: LinearGradient(
              //             colors: gradientColors
              //                 .map((color) => color.withOpacity(0.3))
              //                 .toList(),
              //           ),
              //         ),
              //       ),
              //     ],
              //   )),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle();
    String text = value.toString();
    switch (value.toInt()) {
      case 1:
        text = 'ม.ค.';
        break;
      case 2:
        text = 'ก.พ.';
        break;
      case 3:
        text = 'มี.ค.';
        break;
      case 4:
        text = 'เม.ย.';
        break;
      case 5:
        text = 'พ.ค.';
        break;
      case 6:
        text = 'มิ.ย.';
        break;
      case 7:
        text = 'ก.ค.';
        break;
      case 8:
        text = 'ส.ค.';
        break;
      case 9:
        text = 'ก.ย.';
        break;
      case 10:
        text = 'ต.ค.';
        break;
      case 11:
        text = 'พ.ย.';
        break;
      case 12:
        text = 'ธ.ค.';
        break;
    }

    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 30,
    );
    String text = value.toString();
    text = text;

    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }

  Widget newsTab() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              // TextWidget.textSubTitleBold('ข่าวสาร'),
              // Card(child: ,)
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: news.length +
                    1, // Replace with your actual number of news articles
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.07,
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                'asset/images/wma_header.png',
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  child: Image.asset(
                                    'asset/images/wma_n.png',
                                  )),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  child: Image.asset(
                                    'asset/images/welcome.png',
                                  )),
                            ],
                          ),
                        ],
                      ),
                    );
                  }

                  if (index == 1) {
                    return Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 6,
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: Image.asset(
                                      'asset/images/cloud.png',
                                    )),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ปริมาณน้ำเสียที่ผ่านการบำบัดสะสม',
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
                                          summary,
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: blue_navy_n,
                                          ),
                                          gradient:
                                              const LinearGradient(colors: [
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
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'สรุปภาพรวมคุณภาพน้ำ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: blue_navy_n,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'จากศูนย์บริหารจัดการคุณภาพน้ำ $total แห่งทั่วประเทศ',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                                color: blue_navy_n,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(ListQuality(
                                  title: '',
                                  status: 'PASSED',
                                ));
                              },
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  width:
                                      MediaQuery.of(context).size.width * 0.28,
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  decoration: BoxDecoration(
                                    color: blue_n,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'ผ่านเกณฑ์',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        passed,
                                        style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Text(
                                        'พื้นที่',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(ListQuality(
                                  title: '',
                                  status: 'FAILED',
                                ));
                              },
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  width:
                                      MediaQuery.of(context).size.width * 0.28,
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  decoration: BoxDecoration(
                                    color: yellow_n,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'เฝ้าระวัง',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        failed,
                                        style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Text(
                                        'พื้นที่',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(ListQuality(
                                  title: '',
                                  status: 'PENDING',
                                ));
                              },
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  width:
                                      MediaQuery.of(context).size.width * 0.28,
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  decoration: BoxDecoration(
                                    color: red_n,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'ต้องตรวจสอบ',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        pending,
                                        style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Text(
                                        'พื้นที่',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(NewsList(
                              news: news,
                            ));
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'ข่าวประชาสัมพันธ์',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: blue_navy_n,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'เพิ่มเติม',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: blue_navy_n,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'asset/images/arrow_n.png',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                    // return ListItemWidget.newsFirstCard(
                    //     context,
                    //     news[index - 1]['title']['rendered'],
                    //     news[index - 1]['jetpack_featured_media_url'],
                    //     news[index - 1],
                    //     showDate(news[index - 1]['date']));
                  }

                  if (index == 2) {
                    // return Expanded(
                    //   child: CarouselSlider(
                    //     items: imageSliders,
                    //     controller: _controller,
                    //     options: CarouselOptions(
                    //         autoPlay: true,
                    //         enlargeCenterPage: true,
                    //         aspectRatio: 2.0,
                    //         onPageChanged: (index, reason) {
                    //           setState(() {
                    //             _current = index;
                    //           });
                    //         }),
                    //   ),
                    // );

                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        CarouselSlider.builder(
                            itemCount: 5,
                            options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: true,
                              aspectRatio: 3.0,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              },
                            ),
                            itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) {
                              return ListItemWidget.newsCard_n(
                                  context,
                                  news[itemIndex]['title']['rendered'],
                                  news[itemIndex]['jetpack_featured_media_url'],
                                  news[itemIndex],
                                  showDate(news[itemIndex]['date']));
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        AnimatedSmoothIndicator(
                          activeIndex: _current,
                          count: news.length,
                          effect: const ScrollingDotsEffect(
                              spacing: 8.0,
                              // radius: 4.0,
                              dotWidth: 12.0,
                              dotHeight: 12.0,
                              paintStyle: PaintingStyle.fill,
                              strokeWidth: 1.5,
                              dotColor: Colors.black12,
                              activeDotColor: Colors.white),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    );
                  }

                  return Container();
                  // return ListItemWidget.newsCard(
                  //     context,
                  //     news[index]['title']['rendered'],
                  //     news[index]['jetpack_featured_media_url'],
                  //     news[index],
                  //     showDate(news[index]['date']));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  String showDate(String date) {
    final DateTime now = DateTime.parse(date);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(now);
    return formatted;
  }

  final textFieldFocusNode = FocusNode();
  bool _obscured = true;
  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  Widget contentView() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              TextWidget.textGeneral('ลงชื่อเข้าใช้งานระบบการรายงาน'),
              Edittext.edittextGeneral('บัญชีผู้ใช้', '', username),
              const SizedBox(
                height: 30,
              ),
              Edittext.edittextGeneralSecure(
                  'รหัสผ่าน', '', password, _obscured, _toggleObscured),
              ButtonApp.buttonMain(context, 'เข้าสู่ระบบ', () async {
                setState(() {
                  loading = true;
                });

                String? token = await FirebaseMessaging.instance.getToken();

                final uaData = await userAgentData();
                final header = await userAgentClientHintsHeader();
                print(
                    '{username : ${username.text} , password : ${password.text}, moti : $token, deviceToken : $_deviceId,');
                if (validate()) {
                  LocationPermission permission =
                      await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    await Geolocator.requestPermission();
                  }

                  var result = await Authentication.login(
                      username.text,
                      password.text,
                      token!,
                      token,
                      uaData.platform,
                      uaData.platformVersion,
                      uaData.package.appVersion,
                      header.toString());
                  final SharedPreferences prefs = await _prefs;
                  if (result['success']) {
                    // print(result['data']['access_token']);
                    prefs.setString('access_token',
                        '${result['data']['token_type']} ${result['data']['access_token']}');

                    //print(result['data']['user']);

                    User user = User.fromMap(result['data']['user'], false);

                    String passphrase =
                        json.encode(result['data']['passphrase']);

                    String encodedMap = user.toJson();

                    prefs.setString('user', encodedMap);
                    prefs.setString('passphrase', passphrase);

                    setState(() {
                      //   username.text = '';
                      //   password.text = '';
                      loading = false;
                    });

                    if (result['data']['user']['role']['slug'] == 'OFFICER' ||
                        result['data']['user']['role']['slug'] == 'ADMIN') {
                      Get.off(ReportHomeOfficer(
                        news: resultNews, role: result['data']['user']['role']['slug'] ,
                      ));
                    } else {
                      Get.off(StationSelect(
                        news: resultNews, role: result['data']['user']['role']['slug'] ,
                      ));
                    }
                  } else {
                    setState(() {
                      //   username.text = '';
                      //   password.text = '';
                      loading = false;
                    });
                    // ignore: use_build_context_synchronously
                    MyDialog.showAlertDialogOk(context, result['message'], () {
                      Get.back();
                    });
                  }

                  //Get.to(const ReportHome());
                } else {
                  setState(() {
                    loading = false;
                  });
                  MyDialog.showAlertDialogOk(
                      context, 'กรุณากรอกบัญชีผู้ใช้เเละรหัสผ่าน', () {
                    Get.back();
                  });
                }
              }, true),
              const SizedBox(
                height: 400,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  bool validate() {
    bool validate = true;
    if (username.text == '') {
      validate = false;
    }

    if (password.text == '') {
      validate = false;
    }

    return validate;
  }

  User setPassphase(User user, dynamic passphase) {
    User newuser = User(
      id: user.id,
      name: user.name,
      email: user.email,
      phoneNumber: user.phoneNumber,
      roleId: user.roleId,
      status: user.status,
      role: user.role,
      stations: user.stations,
      passphrases: Passphrases.fromMap(passphase),
    );
    return newuser;
  }
}
