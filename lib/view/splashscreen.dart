import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wma_app/api/Authentication.dart';
import 'package:wma_app/view/report_home/report_home_officer_view.dart';
import 'package:wma_app/view/station_select/stationSelect.dart';
import 'package:wma_app/widget/dialog.dart';

import '../api/OtherRequest.dart';
import '../model/user.dart';
import 'login/login_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

enum PermissionGroup {
  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - Always
  locationAlways,

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - WhenInUse
  locationWhenInUse
}

class _SplashScreenState extends State<SplashScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late var resultNews;
  var userjson;
  var passphase;
  List<dynamic> news = [];
  late User user;

  Future<void> _getNews() async {
    var res = await Authentication.forceUpdate();
    print(res['data']['force']);
    if (res['data']['force']) {
      // ignore: use_build_context_synchronously
      MyDialog.showAlertDialogOk(
          context, 'กรุณาอัพเดทแอปพลิเคชันเป็นเวอร์ชันล่าสุด', () {
        exit(0);
      });
    } else {
      resultNews = await OtherRequest.news();

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        MyDialog.showPermissionDialogOk(context,
            'WMA Clear Water ต้องการเขาถึงตำแหน่งเบื้องหลังเพื่อการใช้ฟังก์ชันต่อไปนี้\n- แผนที่ศูนย์บำบัดน้ำ\n- Check-in ผู้รายงาน',
            () async {
          await Geolocator.requestPermission();
          final SharedPreferences prefs = await _prefs;
          userjson = (prefs.getString('user') ?? '');

          if (userjson != null && userjson != '') {
            user = User.fromJson(userjson, true);
            if (user.role.slug == 'OFFICER' || user.role.slug == 'ADMIN') {
              Get.to(ReportHomeOfficer(
                news: resultNews,
              ));
            } else {
              Get.to(StationSelect(
                news: resultNews,
              ));
            }
          } else {
            Get.to(Login(
              tab: 0,
            ));
          }
        }, () {
          exit(0);
        });
      } else {
        final SharedPreferences prefs = await _prefs;
        userjson = (prefs.getString('user') ?? '');

        if (userjson != null && userjson != '') {
          user = User.fromJson(userjson, true);
          if (user.role.slug == 'OFFICER' || user.role.slug == 'ADMIN') {
            Get.to(ReportHomeOfficer(
              news: resultNews,
            ));
          } else {
            Get.to(StationSelect(
              news: resultNews,
            ));
          }
        } else {
          Get.to(Login(
            tab: 0,
          ));
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('asset/images/waterbg.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
          child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.width * 0.4,
        child: Image.asset(
          'asset/images/appicon.png',
        ),
      )),
    );
  }
}
