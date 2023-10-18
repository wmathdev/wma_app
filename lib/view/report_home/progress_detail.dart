// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wma_app/model/workflow.dart';
import 'package:wma_app/widget/text_widget.dart';

import '../../Utils/month.dart';
import '../../widget/appbarGeneral.dart';
import '../../widget/list_item_widget.dart';
import '../../widget/navigatebar.dart';

class ProgressDetail extends StatefulWidget {
  String dateLebal;
  dynamic result;
  ProgressDetail({
    Key? key,
    required this.dateLebal,
    required this.result,
  }) : super(key: key);

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

      setState(() {
        workflow = Workflow(
            id: widget.result['data']['workflow']['id'],
            state: widget.result['data']['workflow']['state'],
            progress: widget.result['data']['workflow']['progress'],
            label: widget.result['data']['workflow']['label'],
            tansactions: trans,
            completedAt: widget.result['data']['workflow']['completed_at'] ?? '');

        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          //   colors: [
          //     blueGradientTop,
          //     blueGradientBottom,
          //   ],
          // )),
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
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    TextWidget.textGeneral(
                        'ข้อมูลคุณภาพน้ำประจำวันที่ ${widget.dateLebal}'),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: trans.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == trans.length) {
                        return ListItemWidget.progressItemHightlight(
                            '${workflow.completedAt.length > 0 ? workflow.completedAt.substring(12) : '--:--'} น.', workflow.label);
                      }
                      return ListItemWidget.progressItem(
                          '${trans[index].time}', trans[index].type);
                    }),
              ),
            ],
          )
        : Text('No workflow');
  }
}
