// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../Utils/Color.dart';
import '../../api/MediaRequest.dart';
import '../../api/OperatorRequest.dart';
import '../../model/user.dart';
import '../../widget/button_app.dart';
import '../../widget/dialog.dart';
import '../../widget/edittext.dart';
import '../../widget/text_widget.dart';

class RecheckPopupMonthEdit extends StatefulWidget {
  String dateLabel;
  String authorization;
  String documentId;
  List<String> file;
  List<String> mediaDelete;
  String role;
  Station station;
  String type;

  String bod;
  String cod;
  String ss;
  String fog;
  String totalNitrogen;
  String totalPhosphorous;
  String salt;

  String treated_bod;
  String treated_cod;
  String treated_ss;
  String treated_fog;
  String treated_total_nitrogen;
  String treated_total_phosphorous;
  String treated_salt;

  String electric_unit;

  RecheckPopupMonthEdit({
    Key? key,
    required this.dateLabel,
    required this.authorization,
    required this.documentId,
    required this.file,
    required this.mediaDelete,
    required this.role,
    required this.station,
    required this.type,
    required this.bod,
    required this.cod,
    required this.ss,
    required this.fog,
    required this.totalNitrogen,
    required this.totalPhosphorous,
    required this.salt,
    required this.treated_bod,
    required this.treated_cod,
    required this.treated_ss,
    required this.treated_fog,
    required this.treated_total_nitrogen,
    required this.treated_total_phosphorous,
    required this.treated_salt,
    required this.electric_unit,
  }) : super(key: key);

  @override
  State<RecheckPopupMonthEdit> createState() => _RecheckPopupMonthEditState();
}

class _RecheckPopupMonthEditState extends State<RecheckPopupMonthEdit> {
  bool loading = true;
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (loading) {
      // commentController.text = widget.comment;
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
                TextWidget.textBigWithColor('ใช่หรือไม่', Colors.black),
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
                    TextWidget.textTitle('ปริมาณพลังงานไฟฟ้าที่ใช้'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [TextWidget.textSubTitleBold('${widget.electric_unit} kW-hr')],
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
                          TextWidget.textTitle('BOD'),
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
                          TextWidget.textTitle('BOD'),
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
                          TextWidget.textTitle('${widget.bod} mg/I'),
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
                             '${widget.treated_bod} mg/I', greenValue),
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
                          TextWidget.textTitle('COD'),
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
                          TextWidget.textTitle('COD'),
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
                          TextWidget.textTitle('${widget.cod} mg/I'),
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
                              '${widget.treated_cod} mg/I', greenValue),
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
                          TextWidget.textTitle('SS'),
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
                          TextWidget.textTitle('SS'),
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
                          TextWidget.textTitle('${widget.ss} mg/I'),
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
                              '${widget.treated_ss} mg/I', greenValue),
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
                          TextWidget.textTitle('Fat, Oil and Grease'),
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
                          TextWidget.textTitle('Fat, Oil and Grease'),
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
                          TextWidget.textTitle('${widget.fog} mg/I'),
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
                              '${widget.treated_fog} mg/I', greenValue),
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
                          TextWidget.textTitle('Total Nitrogen'),
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
                          TextWidget.textTitle('Total Nitrogen'),
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
                          TextWidget.textTitle('${widget.totalNitrogen} mg/I'),
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
                              '${widget.treated_total_nitrogen} mg/I', greenValue),
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
                          TextWidget.textTitle('Total Phosphorus'),
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
                          TextWidget.textTitle('Total Phosphorus'),
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
                          TextWidget.textTitle('${widget.totalPhosphorous} mg/I'),
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
                              '${widget.treated_total_phosphorous} mg/I', greenValue),
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
                          TextWidget.textTitle('ความเค็ม'),
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
                          TextWidget.textTitle('ความเค็ม'),
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
                          TextWidget.textTitle('${widget.salt} ppt.'),
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
                              '${widget.treated_salt} ppt.', greenValue),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
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

              Position position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.low);

              var result = await OperatorRequest.revisionMonthlyDocument(
                  widget.authorization,
                  widget.station.id,
                  widget.documentId,
                  widget.bod,
                  widget.cod,
                  widget.ss,
                  widget.fog,
                  widget.totalNitrogen,
                  widget.totalPhosphorous,
                  widget.salt,
                  widget.treated_bod,
                  widget.treated_cod,
                  widget.treated_ss,
                  widget.treated_fog,
                  widget.treated_total_nitrogen,
                  widget.treated_total_phosphorous,
                  widget.treated_salt,
                  widget.electric_unit,
                  widget.file,
                  outputDate,
                  widget.type,
                  commentController.text,
                  '${position.latitude},${position.longitude}');

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
