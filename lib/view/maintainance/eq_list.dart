// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wma_app/model/user.dart';
import 'package:wma_app/view/maintainance/maintianance.dart';
import 'package:wma_app/widget/list_item_widget.dart';
import 'package:wma_app/widget/navigatebar.dart';
import 'package:wma_app/widget/text_widget.dart';

class EQList extends StatefulWidget {
  dynamic eqdata;
  Station station;
  String role;

  EQList({
    Key? key,
    required this.eqdata,
    required this.station,
    required this.role
  }) : super(key: key);

  @override
  State<EQList> createState() => _EQListState();
}

class _EQListState extends State<EQList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            height: MediaQuery.of(context).size.height * 0.75,
            child: ListView.builder(
                // physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.eqdata
                    .length, // Replace with your actual number of news articles
                itemBuilder: (context, index) {
                  return ListItemWidget.eqCard(context, widget.eqdata[index],
                      () async {
                    Get.to(Maintainance(
                      station: widget.station,
                      data: widget.eqdata[index],
                      role: widget.role,
                    ));
                  });
                }),
          )
        ]));
  }
}
