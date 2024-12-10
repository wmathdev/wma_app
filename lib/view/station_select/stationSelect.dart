// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wma_app/Utils/Color.dart';
import 'package:wma_app/api/MapRequest.dart';
import 'package:wma_app/api/Notification.dart';

import 'package:wma_app/model/user.dart';
import 'package:wma_app/test.dart';
import 'package:wma_app/view/login/list_quality_station.dart';
import 'package:wma_app/view/news/news_list.dart';
import 'package:wma_app/view/notification/notificationlist.dart';
import 'package:wma_app/widget/gradient_text.dart';

import '../../api/DashboardRequest.dart';
import '../../widget/appbar.dart';
import '../../widget/list_item_widget.dart';
import '../../widget/navigatebar.dart';
import '../../widget/text_widget.dart';
import '../login/overview.dart';
import '../report_home/report_home_view.dart';
import '../statistic/statistic.dart';

class StationSelect extends StatefulWidget {
  dynamic news;
  StationSelect({
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  State<StationSelect> createState() => _StationSelectState();
}

class _StationSelectState extends State<StationSelect> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int _selectedIndex = 3;
  var accessToken = '';

  List<Station> stations = [];
  late var user;

  bool loading = true;

  late var resultTreatedWater;
  late var resultStatistic;
  List<FlSpot> dummyData1 = [];
  List<Color> gradientColors = [
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
  ];

  List<dynamic> news = [];
  int _current = 0;

  late dynamic treatedWater;
  var summary = '0';
  String total = '0';
  dynamic qualityOverview;
  var passed = '0';
  var failed = '0';
  var pending = '0';

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

  Future<void> _getAccessToken() async {
    final SharedPreferences prefs = await _prefs;
    accessToken = (prefs.getString('access_token') ?? '');
    print(accessToken);
  }

  Future<void> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedMap = prefs.getString('user');
    user = User.fromJson(encodedMap!, true);
    setState(() {
      stations = user.stations.stations;
    });

    if (stations.length == 1) {
      Get.to(ReportHome(
        station: user.stations.stations[0],
        isPassing: true,
        role: user.role.slug,
        news: widget.news,
      ));
    }
  }

  dynamic notifications;
  Future<void> _getNotificationList() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var auth = await prefs.getString('access_token');
    var res1 = await NotificationRequest.getNotificationList(auth!);
    print('object $res1');

    setState(() {
      notifications = res1['data'];
    });

    Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {
        loading = false;
      });
    });
  }

  Future<void> _getNews() async {
    setState(() {
      news = widget.news;
    });
  }

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
    _getNews();
    _getDashboard();
    getSharedPrefs();
    _getNotificationList();
  }

  @override
  Widget build(BuildContext context) {
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
                            : Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: ExactAssetImage(
                                        'asset/images/waterbg.jpg'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    loading
                                        ? Container()
                                        : MyAppBar(
                                            title: '',
                                            noti: notifications['unread'],
                                            onPress: () async {
                                              await Get.to(NotificationList());
                                              _getNotificationList();
                                            },
                                          ),
                                    loading ? Container() : contentView()
                                  ],
                                ),
                              ),
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

  Widget contentView() {
    return stations.length > 0
        ? Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.asset('asset/images/iconintro.png')),
                  TextWidget.textSubTitleBold('ศูนย์บริหารจัดการคุณภาพน้ำ')
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       width: MediaQuery.of(context).size.width * 0.3,
              //       padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              //       decoration: BoxDecoration(
              //           color: red_n,
              //           borderRadius:
              //               const BorderRadius.all(Radius.circular(15))),
              //       child: Column(
              //         children: [
              //           TextWidget.textSubTitleWithSizeColor(
              //               'รายงานล่าช้า', 10, Colors.white),
              //           TextWidget.textSubTitleWithSizeColor(
              //               '4', 20, Colors.white),
              //           TextWidget.textSubTitleWithSizeColor(
              //               'รายการ', 10, Colors.white),
              //         ],
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 10,
              //     ),
              //     Container(
              //       width: MediaQuery.of(context).size.width * 0.3,
              //       padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              //       decoration: BoxDecoration(
              //           color: yellow_n,
              //           borderRadius:
              //               const BorderRadius.all(Radius.circular(15))),
              //       child: Column(
              //         children: [
              //           TextWidget.textSubTitleWithSizeColor(
              //               'รอการตรวจสอบ', 10, Colors.white),
              //           TextWidget.textSubTitleWithSizeColor(
              //               '1', 20, Colors.white),
              //           TextWidget.textSubTitleWithSizeColor(
              //               'รายการ', 10, Colors.white),
              //         ],
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 10,
              //     ),
              //     Container(
              //       width: MediaQuery.of(context).size.width * 0.3,
              //       padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              //       decoration: BoxDecoration(
              //           color: blue_n,
              //           borderRadius:
              //               const BorderRadius.all(Radius.circular(15))),
              //       child: Column(
              //         children: [
              //           TextWidget.textSubTitleWithSizeColor(
              //               'ส่งรายงานสำเร็จ', 10, Colors.white),
              //           TextWidget.textSubTitleWithSizeColor(
              //               '123/365', 20, Colors.white),
              //           TextWidget.textSubTitleWithSizeColor(
              //               'รายการ', 10, Colors.white),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     TextWidget.textSubTitleWithSize(
              //         'จำนวนศูนย์ในการดูแลจำนวน 6 ศูนย์', 9)
              //   ],
              // ),
              SizedBox(
                // width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.65,
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: stations.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListItemWidget.cardListStation(
                          context, stations[index].lite_name, () {
                        Get.to(ReportHome(
                          station: stations[index],
                          isPassing: false,
                          role: user.role.slug,
                          news: widget.news,
                        ));
                      });
                    }),
              ),
            ],
          )
        : Text('No Station');
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
                                        const SizedBox(
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
                            const SizedBox(
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
                                    color: green_n,
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
                            itemCount: news.length,
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
              children: [
                TextWidget.textBigWithColor(
                  'สถิติ',
                  blue_navy_n,
                )
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
