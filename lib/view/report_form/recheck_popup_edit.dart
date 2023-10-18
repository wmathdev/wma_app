// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:wma_app/api/MediaRequest.dart';

import '../../Utils/Color.dart';
import '../../api/OperatorRequest.dart';
import '../../model/user.dart';
import '../../widget/button_app.dart';
import '../../widget/dialog.dart';
import '../../widget/edittext.dart';
import '../../widget/text_widget.dart';

class RecheckPopupEdit extends StatefulWidget {
  String dateLabel;
  String authorization;
  String documentId;
  String doo;
  String ph;
  String temp;
  String treatedDoo;
  String treatedPh;
  String treatedTemp;
  List<String> file;
  List<String> mediaDelete;
  String treatedWater;
  String type;
  String role;
  String comment;
  Station station;
  RecheckPopupEdit(
      {Key? key,
      required this.dateLabel,
      required this.authorization,
      required this.documentId,
      required this.doo,
      required this.ph,
      required this.temp,
      required this.treatedDoo,
      required this.treatedPh,
      required this.treatedTemp,
      required this.file,
      required this.mediaDelete,
      required this.treatedWater,
      required this.type,
      required this.role,
      required this.comment,
      required this.station})
      : super(key: key);

  @override
  State<RecheckPopupEdit> createState() => _RecheckPopupEditState();
}

class _RecheckPopupEditState extends State<RecheckPopupEdit> {
  bool loading = true;
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (loading) {
      commentController.text = widget.comment;
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        color: Colors.grey[60],
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
                        'asset/lottie/animation_lk0uamsc.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                      TextWidget.textGeneralWithColor(
                          'กรุณารอสักครู่...', blueSelected)
                    ],
                  ),
                ),
              )
            : contentView(),
      ),
    ));
  }

  Widget contentView() {
    return Stack(children: [
      SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const ImageIcon(
                        AssetImage('asset/images/bi_chevron-right.png')))
              ],
            ),
            Center(
                child: Container(
              width: 200,
              height: 200,
              child: const Image(
                image: AssetImage('asset/images/recheckicon.png'),
              ),
            )),
            TextWidget.textBigWithColor(
                'คุณยืนยันการส่งรายงานประจำวันที่', Colors.black),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget.textBigWithColor(widget.dateLabel, blueSelected),
                TextWidget.textBigWithColor(' ใช่หรือไม่', Colors.black),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            // TextWidget.textTitle('สถานะต่อไป: รอผู้จัดการตรวจสอบ'),
            // const SizedBox(
            //   height: 25,
            // ),
            reportSummary(),
            const SizedBox(
              height: 50,
            ),
            footer()
          ],
        ),
      )
    ]);
  }

  Widget reportSummary() {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: greyBG,
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: const ImageIcon(
                  AssetImage('asset/images/bi_clipboard-check.png')),
            ),
            const SizedBox(
              width: 10,
            ),
            TextWidget.textSubTitleWithSize('สรุปรายงาน', 18),
          ],
        ),
        Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget.textTitle('ปริมาณน้ำเสียที่ผ่านการบำบัด'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [TextWidget.textSubTitleBold('${widget.treatedWater} ลบ.ม.')],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      color: greyBG,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget.textTitle('คุณภาพน้ำ'),
                          TextWidget.textTitleBold('ก่อน'),
                          TextWidget.textTitle('การบำบัด')
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      color: blueButtonBorder,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget.textTitle('คุณภาพน้ำ'),
                          TextWidget.textTitleBold('หลัง'),
                          TextWidget.textTitle('การบำบัด')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                              width: 1.0,
                              color: Color.fromARGB(255, 210, 210, 210)),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget.textTitle('Do'),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              width: 1.0,
                              color: Color.fromARGB(255, 210, 210, 210)),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget.textTitle('Do'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                              width: 1.0,
                              color: Color.fromARGB(255, 210, 210, 210)),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget.textTitle('${widget.doo} mg/l'),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              width: 1.0,
                              color: Color.fromARGB(255, 210, 210, 210)),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget.textTitleBoldWithColor(
                              '${widget.treatedDoo} mg/l', greenValue),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                              width: 1.0,
                              color: Color.fromARGB(255, 210, 210, 210)),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget.textTitle('pH'),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              width: 1.0,
                              color: Color.fromARGB(255, 210, 210, 210)),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget.textTitle('pH'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                              width: 1.0,
                              color: Color.fromARGB(255, 210, 210, 210)),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget.textTitle(widget.ph),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              width: 1.0,
                              color: Color.fromARGB(255, 210, 210, 210)),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget.textTitleBoldWithColor(
                              widget.treatedPh, greenValue),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                              width: 1.0,
                              color: Color.fromARGB(255, 210, 210, 210)),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget.textTitle('Temperature'),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              width: 1.0,
                              color: Color.fromARGB(255, 210, 210, 210)),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget.textTitle('Temperature'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                              width: 1.0,
                              color: Color.fromARGB(255, 210, 210, 210)),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget.textTitle('${widget.temp} ํC'),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              width: 1.0,
                              color: Color.fromARGB(255, 210, 210, 210)),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget.textTitleBoldWithColor(
                              '${widget.treatedTemp} ํC', greenValue),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: greyBG,
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: const ImageIcon(
                  AssetImage('asset/images/bi_chat-left-dots.png')),
            ),
            const SizedBox(
              width: 10,
            ),
            TextWidget.textSubTitleWithSize('โน้ต (Optional)', 18),
          ],
        ),
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: widget.role == 'ADMIN' ? Colors.green[50] : orange,
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Column(children: [
            Row(
              children: [
                TextWidget.textTitleBold('จาก: '),
                widget.role == 'ADMIN'
                    ? TextWidget.textTitle('ADMIN')
                    : TextWidget.textTitle('เจ้าหน้าที่หน้างาน'),
              ],
            ),
            widget.role == 'ADMIN'
                ? Container()
                : Row(
                    children: [
                      TextWidget.textTitleBold('ถึง: '),
                      TextWidget.textTitle('ผู้จัดการ'),
                    ],
                  ),
          ]),
        ),
        // Container(
        //     margin: const EdgeInsets.all(10),
        //     decoration: BoxDecoration(
        //         border: Border.all(color: Colors.grey),
        //         borderRadius: const BorderRadius.all(Radius.circular(5))),
        //     child: const Padding(
        //       padding: EdgeInsets.all(8.0),
        //       child: TextField(
        //         controller: TextEditingController(),
        //         maxLines: 5, //or null
        //         decoration: InputDecoration.collapsed(
        //             hintText: "ข้อความเพิ่มเติม . . . "),
        //       ),
        //     )),
        Edittext.edittextAreaForm('', '', commentController, false),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextWidget.textTitleBoldWithColor('', blueSelected),
              TextWidget.textTitle('${widget.dateLabel}')
            ],
          ),
        )
      ],
    );
  }

  Widget footer() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 25.0,
            spreadRadius: 5,
            offset: Offset(-5, 0), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ButtonApp.buttonSecondaryFix(context, 'ยกเลิก', () {
              Get.back();
            }, true),
            ButtonApp.buttonMainFix(context, 'ยืนยัน', () async {
              setState(() {
                loading = true;
              });

              for (var i = 0; i < widget.mediaDelete.length; i++) {
                var result = await MediaRequest.delete(
                    widget.authorization, widget.mediaDelete[i]);
                if (result['code'] != '200') {
                  MyDialog.showAlertDialogOk(context, '${result['message']}',
                      () {
                    setState(() {
                      loading = false;
                    });
                    Get.back();
                  });
                }
              }

              var today = DateTime.now();
              final outputFormat = DateFormat('yyyy-MM-dd');

              var outputDate = outputFormat.format(today);

              var result = await OperatorRequest.revisionDocument(
                  widget.authorization,
                  widget.station.id,
                  widget.documentId,
                  widget.doo,
                  widget.ph,
                  widget.temp,
                  widget.treatedDoo,
                  widget.treatedPh,
                  widget.treatedTemp,
                  widget.file,
                  widget.treatedWater,
                  outputDate,
                  widget.type,
                  commentController.text);

              if (result['code'] != '200') {
                MyDialog.showAlertDialogOk(context, '${result['message']}', () {
                  setState(() {
                    loading = false;
                  });
                  Get.back();
                });
              } else {
                Get.back();
                Get.back();
              }
            }, true),
          ],
        ),
      ),
    );
  }
}
