// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wma_app/Utils/Color.dart';
import 'package:wma_app/api/DashboardRequest.dart';
import 'package:wma_app/view/login/overview_datail.dart';

import 'package:wma_app/widget/navigatebar.dart';
import 'package:wma_app/widget/text_widget.dart';

class ListQuality extends StatefulWidget {
  String title;
  String status;

  ListQuality({
    Key? key,
    required this.title,
    required this.status,
  }) : super(key: key);

  @override
  State<ListQuality> createState() => _ListQualityState();
}

class _ListQualityState extends State<ListQuality> {
  bool loading = true;
  dynamic data;

  Future<void> _getQualityListStation() async {

    var res1 = await DashboardRequest.getQualityStation( widget.status);
    print('object $res1');

    setState(() {
      data = res1['data'];
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getQualityListStation();
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
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage('asset/images/waterbg.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    NavigateBar.NavBar(context, widget.title, () {
                      Get.back();
                    }),
                    contentView()
                  ],
                ),
              ),
            ),
          );
  }

  Widget contentView() {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset('asset/images/iconintro.png')),
              Expanded(
                  child: TextWidget.textSubTitleBold('สรุปภาพรวมคุณภาพน้ำ')),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              TextWidget.textTitleBold(widget.status == 'PASSED'
                  ? 'ผ่านเกณฑ์จำนวน ${data['total']} ศูนย์'
                  : widget.status == 'FAILED'
                      ? 'เฝ้าระวังจำนวน ${data['total']} ศูนย์'
                      : 'ต้องตรวจสอบจำนวน ${data['total']} ศูนย์'),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              TextWidget.textTitle('สรุปภาพรวมคุณภาพน้ำ'),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.builder(
                // physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data['items']
                    .length, // Replace with your actual number of news articles
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(OverviewDertail(
                          stationId: '${data['items'][index]['id']}',
                          isSubmited: true,
                          isRule: false,
                          latlng: LatLng(0.0,0.0)
                          ));
                    },
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget.textTitle(
                                      'ศูนย์บริหารจัดการคุณภาพน้ำ'),
                                  TextWidget.textSubTitle(
                                      data['items'][index]['lite_name'])
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.status == 'PASSED'
                                      ? blue_n
                                      : widget.status == 'FAILED'
                                          ? yellow_n
                                          : red_n,
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: IconButton(
                                    iconSize: 100,
                                    icon: Image.asset(
                                      'asset/images/arrow_n.png',
                                    ),
                                    onPressed: null)),
                          ],
                        ),
                      ),
                    ),
                  );

                  // return TextWidget.textBig('${data['items'][0]['id']}');
                  // return ListItemWidget.eqTypeCard(context, eQType[index],
                  //     () async {
                  //   var res = await Get.to(EQList(
                  //     station: widget.station,
                  //     eqdata: eQType[index]['items'],
                  //   ));
                  //   _getEQType();
                  // });
                }),
          )
        ]));
  }
}
