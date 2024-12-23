// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wma_app/model/user.dart';

import 'package:wma_app/model/workflow.dart';
import 'package:wma_app/widget/text_widget.dart';

import '../../Utils/month.dart';
import '../../widget/appbarGeneral.dart';
import '../../widget/list_item_widget.dart';
import '../../widget/navigatebar.dart';

class ProgressDetail extends StatefulWidget {
  String dateLebal;
  dynamic result;
  Station station;

  ProgressDetail(
      {Key? key,
      required this.dateLebal,
      required this.result,
      required this.station})
      : super(key: key);

  @override
  State<ProgressDetail> createState() => _ProgressDetailState();
}

class _ProgressDetailState extends State<ProgressDetail> {
  late Workflow workflow;
  bool loading = true;
  List<Transactions> trans = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (loading) {
      List<dynamic> temp = widget.result['data']['workflow']['transactions'];

      for (var i = 0; i < temp.length; i++) {
        Transactions tempTrans = Transactions.fromMap(temp[i]);

        trans.add(tempTrans);
      }

      // for (var i = temp.length - 1 ; i > 0; i--) {
      //   Transactions tempTrans = Transactions.fromMap(temp[i]);

      //   trans.add(tempTrans);
      // }

      setState(() {
        workflow = Workflow(
            id: widget.result['data']['workflow']['id'],
            state: widget.result['data']['workflow']['state'],
            progress: widget.result['data']['workflow']['progress'],
            label: widget.result['data']['workflow']['label'],
            tansactions: trans,
            completedAt:
                widget.result['data']['workflow']['completed_at'] ?? '');

        loading = false;
      });
    }
  }

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
              Container(
                height: 80,
                alignment: Alignment.topCenter,
                child: NavigateBar.NavBar(context, 'ประวัติการส่งรายงานทั้งหมด',
                    () {
                  Get.back();
                }),
              ),
              contentView()
            ],
          ),
        ),
      ),
    );
  }

  Widget contentView() {
    return trans.isNotEmpty
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget.textTitle('ศูนย์บริหารจัดการคุณภาพน้ำ'),
                      TextWidget.textSubTitleBoldMedium(
                          widget.station.lite_name),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Colors.white,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          TextWidget.textTitle('ข้อมูลคุณภาพน้ำ'),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          TextWidget.textSubTitleBold(
                              'ประจำวันที่ ${widget.dateLebal}'),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        // height: MediaQuery.of(context).size.height * 0.25,
                        child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: trans.length + 1,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                return ListItemWidget.progressItemHightlight(
                                    '${workflow.completedAt.length > 0 ? workflow.completedAt.substring(12) : '--:--'} น.',
                                    workflow.label);
                              }
                              return ListItemWidget.progressItem(
                                  '${trans[index - 1].time}',
                                  trans[index - 1].type);
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Text('No workflow');
  }
}
