// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wma_app/Utils/Color.dart';
import 'package:wma_app/api/Notification.dart';
import 'package:wma_app/view/notification/notificationDetail.dart';
import 'package:wma_app/widget/list_item_widget.dart';
import 'package:wma_app/widget/text_widget.dart';

class NotificationList extends StatefulWidget {
  NotificationList({
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  bool loading = true;
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

  @override
  void initState() {
    super.initState();
    _getNotificationList();
  }

  @override
  Widget build(BuildContext context) {
    // print('object2 ${notifications['notifications'][0]}');

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
    return RefreshIndicator(
      onRefresh: () => _getNotificationList(),
      child: Column(
        children: [
          appbar(),
          Expanded(
            child: ListView.builder(
                // physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: notifications['notifications']
                    .length, // Replace with your actual number of news articles
                itemBuilder: (context, index) {
                  return ListItemWidget.notificationsCard(
                      context, notifications['notifications'][index], () async {
                    var a = await Get.to(NotificationDetail(
                      id: notifications['notifications'][index]['id'],
                    ));
                    setState(() {
                      loading = true;
                    });
                    _getNotificationList();
                  });
                }),
          )
        ],
      ),
    );
  }

  Widget appbar() {
    return Container(
      height: 60,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          
          GestureDetector(
              onTap: () {
                Get.back();
              },
              child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
                  child: Image.asset('asset/images/arrow_left_n.png'))),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
          ),
          TextWidget.textTitle('รายการเเจ้งเตือน')
        ],
      ),
    );
  }
}
