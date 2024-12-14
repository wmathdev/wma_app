// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wma_app/api/MapRequest.dart';
import 'package:wma_app/api/Notification.dart';
import 'package:wma_app/view/login/list_quality_station.dart';
import 'package:wma_app/view/news/news_list.dart';
import 'package:wma_app/view/notification/notificationlist.dart';
import 'package:wma_app/view/statistic/statistic.dart';
import 'package:wma_app/widget/gradient_text.dart';

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
  String role;
  ReportHomeOfficer({
    Key? key,
    required this.news,
    required this.role
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

  late List<dynamic> passphrases;

  bool loading = true;
  int _current = 0;
  late var resultTreatedWater;
  late var resultStatistic;
  List<FlSpot> dummyData1 = [];
  List<Color> gradientColors = [
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
  ];

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

  Future<void> _getNews() async {
    setState(() {
      news = widget.news;
    });
    print(news);
  }

  Future<void> _getUser() async {
    final SharedPreferences prefs = await _prefs;
    userjson = (prefs.getString('user') ?? '');
    user = User.fromJson(userjson, true);
    passphrases = json.decode(prefs.getString('passphrase') ?? '');
    accessToken = (prefs.getString('access_token') ?? '');
    setState(() {});

    // print(accessToken);
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
      loading = false;
    });
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
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        blueGradientTop,
                                        blueGradientBottom,
                                      ],
                                    )),
                                    child: Container(
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
                                                  title: 'เมนูสำหรับองค์กร',
                                                  noti: notifications['unread'],
                                                  onPress: () async {
                                                    await Get.to(
                                                        NotificationList(role: widget.role,));
                                                    _getNotificationList();
                                                  },
                                                ),
                                          loading ? Container() : contentView()
                                        ],
                                      ),
                                    ),
                                  ),
          ),
        ),
        floatingActionButton: _selectedIndex == 3
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: greyTel,
                    ),
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextButton(
                      onPressed: () async {
                        await _getAccessToken();
                        Get.to(const TelephoneList());
                      },
                      child: TextWidget.textSubTitleWithSizeGradient(
                          'ดูข้อมูลการติดต่อ', 10, red_n),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  )
                ],
              )
            : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
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
    print('ROLE : ${user.role}');
    _getAccessToken();
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: SingleChildScrollView(
        child: Padding(
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextWidget.textTitleBold('รายงานประจำวัน'),
                ),
              ),
              ListItemWidget.cardListDayOfficer(
                  Month.getMonthTitle(formattedDate),
                  '10.00',
                  context,
                  user.role.slug,
                  accessToken),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextWidget.textTitleBold('รายงานประจำเดือน'),
                ),
              ),
              ListItemWidget.cardListMonthOfficer(
                  Month.getMonthTitle(formattedDate),
                  '10.00',
                  context,
                  user.role.slug,
                  accessToken),
              ListItemWidget.cardListMonthDownloadOfficer(
                  Month.getMonthTitle(formattedDate),
                  '10.00',
                  context,
                  user.role.slug,
                  accessToken),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextWidget.textTitleBold('เมนู'),
                ),
              ),
              ListItemWidget.cardListMaintenanceOfficer(
                  Month.getMonthTitle(formattedDate),
                  '10.00',
                  context,
                  user.role.slug,
                  accessToken),
              ListItemWidget.cardListScadaOfficer(
                  context, user, user.role.slug, accessToken, passphrases),
                  SizedBox(height: 100,)
            ],
          ),
        ),
      ),
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
                                      Text(
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
