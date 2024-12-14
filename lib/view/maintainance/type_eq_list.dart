// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wma_app/Utils/Color.dart';
import 'package:wma_app/api/MaintainanceRequest.dart';
import 'package:wma_app/model/user.dart';
import 'package:wma_app/view/maintainance/eq_list.dart';
import 'package:wma_app/widget/list_item_widget.dart';

import 'package:wma_app/widget/navigatebar.dart';
import 'package:wma_app/widget/text_widget.dart';

class TypeEqList extends StatefulWidget {
  String name;
  Station station;
  String role;
  TypeEqList({super.key, required this.name, required this.station,required this.role});

  @override
  State<TypeEqList> createState() => _TypeEqListState();
}

class _TypeEqListState extends State<TypeEqList> {
  bool loading = true;
  dynamic eQType;
  Future<void> _getEQType() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var auth = await prefs.getString('access_token');
    var res1 =
        await Maintainancerequest.getTypeEqList(auth!, widget.station.id);
    print('object $res1');

    setState(() {
      eQType = res1['data'];
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getEQType();
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
                    NavigateBar.NavBar(context, '', () {
                      Get.back();
                    }),
                    eQType.length > 0
                        ? contentView()
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Center(
                              child: TextWidget.textSubTitleWithSizeGradient(
                                  'ไม่มีการแจ้งเตือน', 25, Colors.white),
                            ))
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget.textTitle('ศูนย์บริหารจัดการคุณภาพน้ำ'),
                  TextWidget.textSubTitleBoldMedium(widget.station.lite_name),
                ],
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
                // physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: eQType
                    .length, // Replace with your actual number of news articles
                itemBuilder: (context, index) {
                  return ListItemWidget.eqTypeCard(context, eQType[index],
                      () async {
                    var res = await Get.to(EQList(
                      station: widget.station,
                      eqdata: eQType[index]['items'],
                      role: widget.role,
                    ));
                    _getEQType();
                  });
                }),
          )
        ]));
  }
}
