// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wma_app/Utils/Color.dart';
import 'package:wma_app/api/Notification.dart';
import 'package:wma_app/model/user.dart';
import 'package:wma_app/view/maintainance/maintianance.dart';
import 'package:wma_app/widget/button_app.dart';
import 'package:wma_app/widget/text_widget.dart';

class NotificationDetail extends StatefulWidget {
  String id;
  NotificationDetail({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<NotificationDetail> createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  bool loading = true;
  dynamic notification;

  Future<void> _getNotification() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var auth = await prefs.getString('access_token');
    var res1 =
        await NotificationRequest.getNotificationDetial(auth!, widget.id);
    print('object $res1');

    setState(() {
      notification = res1['data'];
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
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
                  TextWidget.textGeneralWithColor(
                      'กรุณารอสักครู่...', blueSelected)
                ],
              ),
            ),
          )))
        : Scaffold(
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
                        child: contentView()),
              ),
            ),
          );
  }

  Widget contentView() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(children: [
        appbar(),
        TextWidget.textBig(notification['title']),
        const SizedBox(
          height: 10,
        ),
        TextWidget.textTitleHTMLBold(notification['body']),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            TextWidget.textSubTitleWithSize(notification['created_at'], 8),
          ],
        ),
        notification['type'] == 'MAINTENANCE'
            ? ButtonApp.buttonMainGradient(context, 'ส่งรายงาน', () async {
                Get.to(Maintainance(station: Station(id: notification['morph']['id'], name: notification['morph']['station_name'], pivot: Pivot(userId: 0, stationId: notification['morph']['id']), lite_name: ''), data: notification['morph'],));
              }, true)
            : Container(),
      ]),
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
            width: MediaQuery.of(context).size.width * 0.35,
          ),
          TextWidget.textTitle('การเเจ้งเตือน')
        ],
      ),
    );
  }
}
