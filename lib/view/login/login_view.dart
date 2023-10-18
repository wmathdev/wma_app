// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'dart:math';

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
import 'package:ua_client_hints/ua_client_hints.dart';

import 'package:wma_app/api/OtherRequest.dart';
import 'package:wma_app/api/dashboardRequest.dart';
import 'package:wma_app/view/station_select/stationSelect.dart';

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

  var userjson;

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
    var res1 = await DashboardRequest.getTreatedWater();
    var res2 = await DashboardRequest.getStatistic();
    setState(() {
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
                'asset/lottie/animation_lk0uamsc.json',
                width: 200,
                height: 200,
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
            color: Colors.grey[60],
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
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: blueSelected,
          unselectedItemColor: Colors.black,
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
              icon: ImageIcon(AssetImage('asset/images/bi_newspaper.png')),
              label: 'ข่าวสาร',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('asset/images/bi_map.png')),
              label: 'ภาพรวม',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('asset/images/bi_bar-chart-line.png')),
              label: 'สถิติ',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('asset/images/bi_clipboard2.png')),
              label: 'รายงาน',
            ),
          ],
        ),
      ),
    );
  }

  Widget statisticTab() {
    List<dynamic> graph = resultStatistic['data'];
    return Container(
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
              children: [TextWidget.textBigWithColor('สถิติ', Colors.black)],
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
            children: [TextWidget.textBigWithColor('STATISTIC', Colors.blue)],
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
          child: Container(
            color: blueButton,
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
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                    child: TextWidget.textTitleWithColor(
                                        'WMA', blueSelected)),
                                SizedBox(
                                    child:
                                        TextWidget.textSubTitleBold('ข่าวสาร')),
                              ],
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Image.asset(
                                'asset/images/nak.png',
                              )),
                        ],
                      );
                    }

                    if (index == 1) {
                      return ListItemWidget.newsFirstCard(
                          context,
                          news[index - 1]['title']['rendered'],
                          news[index - 1]['jetpack_featured_media_url'],
                          news[index - 1],
                          showDate(news[index - 1]['date']));
                    }

                    return ListItemWidget.newsCard(
                        context,
                        news[index - 1]['title']['rendered'],
                        news[index - 1]['jetpack_featured_media_url'],
                        news[index - 1],
                        showDate(news[index - 1]['date']));
                  },
                ),
              ],
            ),
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
              TextWidget.textGeneral('ศูนย์บริหารจัดการคุณภาพน้ำ'),
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
                    // print(result);
                    // print(result['data']['access_token']);
                    prefs.setString('access_token',
                        '${result['data']['token_type']} ${result['data']['access_token']}');

                    //print(result['data']['user']);

                    User user = User.fromMap(result['data']['user'], false);
                    String encodedMap = user.toJson();
                    prefs.setString('user', encodedMap);

                    setState(() {
                      //   username.text = '';
                      //   password.text = '';
                      loading = false;
                    });

                    if (result['data']['user']['role']['slug'] == 'OFFICER' ||
                        result['data']['user']['role']['slug'] == 'ADMIN') {
                      Get.off(ReportHomeOfficer(
                        news: resultNews,
                      ));
                    } else {
                      Get.off(StationSelect(
                        news: resultNews,
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
            ],
          ),
        ),
      ],
    );
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
}
