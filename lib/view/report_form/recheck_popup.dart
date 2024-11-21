// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:wma_app/Utils/Color.dart';
import 'package:wma_app/Utils/label.dart';
import 'package:wma_app/Utils/month.dart';
import 'package:wma_app/view/report_form/preview_img.dart';

import '../../Utils/log.dart';
import '../../api/OperatorRequest.dart';
import '../../model/user.dart';
import '../../widget/button_app.dart';
import '../../widget/dialog.dart';
import '../../widget/edittext.dart';
import '../../widget/text_widget.dart';
import '../report_home/report_home_view.dart';
import '../report_list/report_list_view.dart';

class RecheckPopUp extends StatefulWidget {
  String dateLabel;
  String authorization;
  String doo;
  String ph;
  String temp;
  String treatedDoo;
  String treatedPh;
  String treatedTemp;
  List<String> file;
  String treatedWater;
  String type;
  String role;
  Station station;
  List<File> img = [];

  String date;

  RecheckPopUp({
    Key? key,
    required this.dateLabel,
    required this.authorization,
    required this.doo,
    required this.ph,
    required this.temp,
    required this.treatedDoo,
    required this.treatedPh,
    required this.treatedTemp,
    required this.file,
    required this.treatedWater,
    required this.type,
    required this.role,
    required this.station,
    required this.img,
    required this.date,
  }) : super(key: key);

  @override
  State<RecheckPopUp> createState() => _RecheckPopUpState();
}

class _RecheckPopUpState extends State<RecheckPopUp> {
  TextEditingController commentController = TextEditingController();
  bool loading = false;

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
            height: MediaQuery.of(context).size.height * 0.87,
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
                  TextWidget.textSubTitleBoldMedium(widget.station.lite_name),
                ],
              )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                               
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextWidget.textTitleBold(
                                      'ข้อมูลคุณภาพน้ำ'),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextWidget.textTitle(
                                    'ประจำวันที่ ${widget.dateLabel}',
                                  ),
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: red_n,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      child: TextWidget.textTitle(
                                          '--:-- น. | รอเจ้าหน้าที่ดำเนินการ'),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    TextWidget.textTitleBoldWithColor('ตรวจสอบความถูกต้องของข้อมูล',Colors.red),
                                  ],
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
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                    ],
                  ),

                  // TextWidget.textTitle('สถานะต่อไป: รอผู้จัดการตรวจสอบ'),
                  // const SizedBox(
                  //   height: 25,
                  // ),
                ],
              ),
            ),
          ),
        ],
      )
    ]);
  }

  Widget reportSummary() {
    return Column(
      children: [
        // Row(
        //   children: [
        //     const SizedBox(
        //       width: 20,
        //     ),
        //     Container(
        //       decoration: BoxDecoration(
        //           color: greyBG,
        //           borderRadius: const BorderRadius.all(Radius.circular(5))),
        //       child: const ImageIcon(
        //           AssetImage('asset/images/bi_clipboard-check.png')),
        //     ),
        //     const SizedBox(
        //       width: 10,
        //     ),
        //     TextWidget.textSubTitleWithSize('สรุปรายงาน', 18),
        //   ],
        // ),
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
                    TextWidget.textTitle('${Label.commaFormat(widget.treatedWater)} ลบ.ม.')
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
                widget.role == 'ADMIN'
                    ? TextWidget.textTitle('admin')
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

          var outputDate = widget.date;
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.low);

          var result = await OperatorRequest.createDocument(
              widget.authorization,
              widget.station.id,
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
            Get.back();
            Get.to(ReportList(
              station: widget.station,
              role: widget.role,
            ));
          }
        }, true),
      ],
    );

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

              var outputDate = widget.date;
              Position position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.low);

              var result = await OperatorRequest.createDocument(
                  widget.authorization,
                  widget.station.id,
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
                Get.back();
                Get.to(ReportList(
                  station: widget.station,
                  role: widget.role,
                ));
              }
            }, true),
          ],
        ),
      ),
    );
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
                        child: Image.file(
                          widget.img[index],
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
