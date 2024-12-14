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
import 'package:wma_app/view/maintainance/type_eq_list.dart';
import 'package:wma_app/view/news/news_list.dart';
import 'package:wma_app/view/notification/notificationlist.dart';
import 'package:wma_app/view/report_download/report_download_list.dart';
import 'package:wma_app/view/scada/scada.dart';
import 'package:wma_app/widget/gradient_text.dart';

import '../../api/DashboardRequest.dart';
import '../../widget/appbar.dart';
import '../../widget/list_item_widget.dart';
import '../../widget/navigatebar.dart';
import '../../widget/text_widget.dart';
import '../login/overview.dart';
import '../report_home/report_home_view.dart';
import '../statistic/statistic.dart';

class StationOfficerMenu extends StatefulWidget {
  String menu;
  String role;

  List<dynamic> passphrases;
  StationOfficerMenu({
    Key? key,
    required this.menu,
    required this.role,
    required this.passphrases,
  }) : super(key: key);

  @override
  State<StationOfficerMenu> createState() => _StationOfficerMenuState();
}

class _StationOfficerMenuState extends State<StationOfficerMenu> {
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

  @override
  void initState() {
    super.initState();

    _getDashboard();
    getSharedPrefs();
    _getNotificationList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
              : Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('asset/images/waterbg.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    children: [
                      loading ? Container() : AppBar(),
                      loading ? Container() : contentView()
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
                  TextWidget.textSubTitleBoldMedium('ศูนย์บริหารจัดการคุณภาพน้ำ')
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                // width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.75,
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: stations.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListItemWidget.cardListStation(
                          context, stations[index].lite_name, () {
                        if (widget.menu == 'download') {
                          Get.to(ReportDownloadList(
                            station: stations[index],
                            role: widget.role,
                          ));
                        } else if (widget.menu == 'maintenance') {
                          Get.to(TypeEqList(
                            name: stations[index].name,
                            station: stations[index], role: widget.role,
                          ));
                        } else if (widget.menu == 'scada') {
                          Get.to(ScadaPage(
                            name: stations[index].name,
                            url: getURl(user, stations[index]),
                          ));
                        }
                      });
                    }),
              ),
            ],
          )
        : Text('No Station');
  }

  String getURl(User user, Station station) {
    for (var i = 0; i < widget.passphrases.length; i++) {
      if (widget.passphrases[i]['station_id'] == station.id) {
        return widget.passphrases[i]['url'];
      }
    }
    return 'https://wma.or.th/home-eng';
  }
}
