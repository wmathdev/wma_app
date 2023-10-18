// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wma_app/view/statistic/statistic.dart';

import '../../Utils/Color.dart';
import '../../Utils/month.dart';
import '../../api/DashboardRequest.dart';
import '../../api/OtherRequest.dart';
import '../../model/user.dart';
import '../../widget/appbar.dart';
import '../../widget/list_item_widget.dart';
import '../../widget/navigatebar.dart';
import '../../widget/text_widget.dart';
import '../login/overview.dart';
import '../telephone_list/telephone_list_view.dart';

class ReportHomeOfficer extends StatefulWidget {
  dynamic news;
  ReportHomeOfficer({
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  State<ReportHomeOfficer> createState() => _ReportHomeOfficerState();
}

class _ReportHomeOfficerState extends State<ReportHomeOfficer> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int _selectedIndex = 3;
  var accessToken = '';
  var userjson = '';
  late User user;

  List<dynamic> news = [];

  late Position position;

  Future<void> _getAccessToken() async {
    final SharedPreferences prefs = await _prefs;
    accessToken = await (prefs.getString('access_token') ?? '');
    print(accessToken);
  }

  bool loading = true;

  late var resultTreatedWater;
  late var resultStatistic;
  List<FlSpot> dummyData1 = [];
  List<Color> gradientColors = [
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
  ];

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

  Future<void> _getNews() async {
    setState(() {
      news = widget.news;
      loading = false;
    });
    print(news);
  }

  Future<void> _getUser() async {
    final SharedPreferences prefs = await _prefs;
    userjson = (prefs.getString('user') ?? '');
    user = User.fromJson(userjson, true);
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {});

    // print(accessToken);
  }

  var today = DateTime.now();
  String formattedDate = '';

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
    formattedDate = DateFormat('dd-MM-yyyy').format(today);
    _getUser();
    _getNews();
    _getDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: userjson == ''
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
              : loading
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
                              : Container(
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
                                      MyAppBar(title: 'เมนูสำหรับองค์กร'),
                                      contentView()
                                    ],
                                  ),
                                ),
        ),
        floatingActionButton: _selectedIndex == 3
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: greyTel,
                ),
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextButton(
                  onPressed: () async {
                    await _getAccessToken();
                    Get.to(const TelephoneList());
                  },
                  child: Row(
                    children: [
                      const ImageIcon(
                          AssetImage('asset/images/bi_journals.png')),
                      TextWidget.textTitle('ข้อมูลการติดต่อทั้งหมด'),
                    ],
                  ),
                ),
              )
            : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: blueSelected,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              this._selectedIndex = index;
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

  Widget contentView() {
    print('ROLE : ${user.role}');
    _getAccessToken();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: user.role.slug == 'ADMIN'
                  ? TextWidget.textSubTitle('เจ้าหน้าที่แอดมิน')
                  : TextWidget.textSubTitle('เจ้าหน้าที่ส่วนกลาง'),
            ),
          ),
          ListItemWidget.cardListDayOfficer(Month.getMonthTitle(formattedDate),
              '10.00', context, user.role.slug, accessToken),
          ListItemWidget.cardListMonthOfficer(
              Month.getMonthTitle(formattedDate),
              '10.00',
              context,
              user.role.slug,
              accessToken),
        ],
      ),
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
                          TextWidget.textSubTitleBold(
                              '-'),
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
                          TextWidget.textSubTitleBold(
                              '-'),
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
                          TextWidget.textSubTitleBold(
                              '-'),
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
}
