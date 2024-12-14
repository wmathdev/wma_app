// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wma_app/Utils/label.dart';

import 'package:wma_app/api/ManagerRequest.dart';
import 'package:wma_app/api/OfficerRequest.dart';
import 'package:wma_app/view/report_form/preview_img.dart';

import '../../Utils/Color.dart';
import '../../Utils/month.dart';
import '../../api/OperatorRequest.dart';
import '../../model/user.dart';
import '../../widget/button_app.dart';
import '../../widget/dialog.dart';
import '../../widget/edittext.dart';
import '../../widget/text_widget.dart';
import '../report_list/report_list_view.dart';

class RejectPopup extends StatefulWidget {
  String dateLabel;
  String authorization;
  String doo;
  String ph;
  String temp;
  String treatedDoo;
  String treatedPh;
  String treatedTemp;
  // List<String> file;
  String treatedWater;
  String type;
  String role;
  Station station;
  String documentId;
  List<dynamic> img = [];

  RejectPopup({
    Key? key,
    required this.dateLabel,
    required this.authorization,
    required this.doo,
    required this.ph,
    required this.temp,
    required this.treatedDoo,
    required this.treatedPh,
    required this.treatedTemp,
    required this.treatedWater,
    required this.type,
    required this.role,
    required this.station,
    required this.documentId,
    required this.img,
  }) : super(key: key);

  @override
  State<RejectPopup> createState() => _RejectPopupState();
}

class _RejectPopupState extends State<RejectPopup> {
  TextEditingController commentController = TextEditingController();
  bool loading = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                : contentView(),
          ),
        ));
  }

  Widget contentView() {
    return Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage('asset/images/waterbg.jpg'),
            fit: BoxFit.fill,
          ),
        ),
      ),
      Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const ImageIcon(
                        AssetImage('asset/images/arrow_left_n.png'))),
                Row(
                  children: [TextWidget.textTitle('รายงานคุณภาพน้ำประจำวัน')],
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: SingleChildScrollView(
              child: Column(
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
                  Column(children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextWidget.textBigWithColor(
                                          'คุณยืนยันการ', Colors.black),
                                      TextWidget.textBigWithColor(
                                          'ตีกลับ', Colors.red),
                                      TextWidget.textBigWithColor(
                                          'รายงานประจำวันที่', Colors.black),
                                    ]),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextWidget.textBigWithColor(
                                        Month.getMonthTitleReverse(
                                            widget.dateLabel),
                                        blueSelected),
                                    TextWidget.textBigWithColor(
                                        ' ใช่หรือไม่', Colors.black),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextWidget.textTitleBold(
                                      'ข้อมูลคุณภาพน้ำ'),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Container(height: 1, color: Colors.black),
                                const SizedBox(
                                  height: 5,
                                ),
                                uploadPhotoCard(),
                                reportSummary(),
                                const SizedBox(
                                  height: 50,
                                ),
                                footer(),
                              ]))),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                    )
                  ]),
                ],
              ),
            ),
          ),
        ],
      )
    ]);
  }

  Widget uploadPhotoCard() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
          width: MediaQuery.of(context).size.width,
          child: TextWidget.textTitleBold('รูปภาพประกอบ'),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.img.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Card(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(PreviewImage(
                            img: widget.img[index],
                          ));
                        },
                        child: widget.role == 'OFFICER'
                            ? Image.network(
                                widget.img[index],
                                height: 170,
                                width: 100,
                              )
                            : widget.img[index]['type'] == 'url'
                                ? Image.network(
                                    widget.img[index]['value'],
                                    height: 170,
                                    width: 100,
                                  )
                                : Image.file(
                                    widget.img[index]['value'],
                                    height: 170,
                                    width: 100,
                                  ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     widget.img.removeAt(index);
                    //     setState(() {});
                    //   },
                    //   child: Image.asset(
                    //     'asset/images/close.png',
                    //   ),
                    // ),
                  ],
                );
              },
            )),
        const SizedBox(
          height: 5,
        ),
        // ButtonApp.buttonMainGradient(
        //     context, 'เปิดกล้องถ่ายภาพ (${img.length}/4)', () async {
        //   if (img.length >= 4) {
        //     _showSnackBar();
        //   } else {
        //     final ImagePicker _picker = ImagePicker();
        //     final XFile? photo = await _picker.pickImage(
        //         source: ImageSource.camera, imageQuality: 80);
        //     File photofile = File(photo!.path);
        //     img.add(photofile);
        //     setState(() {});
        //   }
        // }, true),
        // const SizedBox(
        //   height: 5,
        // ),
        // Container(
        //     alignment: Alignment.centerLeft,
        //     width: MediaQuery.of(context).size.width,
        //     child: Edittext.edittextForm(
        //         'ปริมาณน้ำเสียที่ผ่านการบำบัด (วันที่ ${Month.getMonthTitleReverse(outputYesterdayDate)})',
        //         'ลบ.ม.',
        //         totalController,
        //         totalValidate)),
      ],
    );
  }

  Widget reportSummary() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          // decoration: BoxDecoration(
          //     border: Border.all(color: Colors.grey),
          //     borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget.textTitleBold('ปริมาณน้ำเสียที่ผ่านการบำบัด'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget.textTitle(
                        '${Label.commaFormat(widget.treatedWater)} ลบ.ม.')
                  ],
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Container(height: 1, color: Colors.black),
              const SizedBox(
                height: 5,
              ),
              before(),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextWidget.textTitleBold('ค่า Do     '),
                      const SizedBox(
                        width: 20,
                      ),
                      TextWidget.textTitle(widget.doo),
                      const SizedBox(
                        width: 20,
                      ),
                      TextWidget.textTitle('mg/l')
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextWidget.textTitleBold('ค่า pH     '),
                      const SizedBox(
                        width: 20,
                      ),
                      TextWidget.textTitle(widget.ph),
                      const SizedBox(
                        width: 20,
                      ),
                      // TextWidget.textTitle('pH')
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextWidget.textTitleBold('ค่าอุณหภูมิ'),
                      const SizedBox(
                        width: 20,
                      ),
                      TextWidget.textTitle(widget.temp),
                      const SizedBox(
                        width: 20,
                      ),
                      TextWidget.textTitle(' ํC')
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Container(height: 1, color: Colors.black),
              after(),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextWidget.textTitleBold('ค่า Do     '),
                      const SizedBox(
                        width: 20,
                      ),
                      TextWidget.textTitle(widget.treatedDoo),
                      const SizedBox(
                        width: 20,
                      ),
                      TextWidget.textTitle('mg/l')
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextWidget.textTitleBold('ค่า pH     '),
                      const SizedBox(
                        width: 20,
                      ),
                      TextWidget.textTitle(widget.treatedPh),
                      const SizedBox(
                        width: 20,
                      ),
                      // TextWidget.textTitle('pH')
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextWidget.textTitleBold('ค่าอุณหภูมิ'),
                      const SizedBox(
                        width: 20,
                      ),
                      TextWidget.textTitle(widget.treatedTemp),
                      const SizedBox(
                        width: 20,
                      ),
                      TextWidget.textTitle(' ํC')
                    ],
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
              color: blue_n_2,
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Column(children: [
            Row(
              children: [
                TextWidget.textTitleBold('จาก: '),
                widget.role == 'OFFICER'
                    ? TextWidget.textTitle('เจ้าหน้าที่ส่วนกลาง')
                    : TextWidget.textTitle('ผู้จัดการ'),
              ],
            ),
            Row(
              children: [
                TextWidget.textTitleBold('ถึง: '),
                widget.role == 'OFFICER'
                    ? TextWidget.textTitle('ผู้จัดการ')
                    : TextWidget.textTitle('เจ้าหน้าที่หน้างาน'),
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
              TextWidget.textTitle(Month.getMonthTitleReverse(widget.dateLabel))
            ],
          ),
        ),
      ],
    );
  }

  Widget footer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonApp.buttonSecondaryHalf(
          context,
          'ยกเลิก',
          () {
            Get.back();
          },
        ),
        ButtonApp.buttonMainhalf(context, 'ส่งรายงาน', () async {
          setState(() {
            loading = true;
          });

          final SharedPreferences prefs = await _prefs;
          String? authorization = prefs.getString('access_token');

          var today = DateTime.now();
          final outputFormat = DateFormat('yyyy-MM-dd');

          var outputDate = outputFormat.format(today);

          var result;
          if (widget.role == 'OFFICER') {
            result = await OfficerRequest.approval(authorization!,
                widget.documentId, 'REJECT', commentController.text);
          } else {
            result = await ManagerRequest.approval(authorization!,
                widget.documentId, 'REJECT', commentController.text);
          }

          if (result['code'] != '200') {
            // ignore: use_build_context_synchronously
            MyDialog.showAlertDialogOk(context, '${result['message']}', () {
              setState(() {
                loading = false;
              });
              Get.back();
            });
          } else {
            Get.back();
            Get.back();
            Get.back();
            Get.to(ReportList(
              station: widget.station,
              role: widget.role,
            ));
          }
        }, true),
      ],
    );
  }

  Widget before() {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          beforeHeader(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget beforeHeader() {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  color: yellow_n,
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Center(
                child: TextWidget.textGeneralWithColor('1', Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextWidget.textTitle('คุณภาพน้ำ'),
            TextWidget.textTitleBold('ก่อนการบำบัด'),
          ],
        )
      ],
    );
  }

  Widget after() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        afterHeader(),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget afterHeader() {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  color: blue_n,
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Center(
                child: TextWidget.textGeneralWithColor('2', Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextWidget.textTitle('คุณภาพน้ำ'),
            TextWidget.textTitleBold('หลังการบำบัด'),
          ],
        )
      ],
    );
  }
}
