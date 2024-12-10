// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:wma_app/Utils/label.dart';
import 'package:wma_app/view/report_form/preview_img.dart';
import 'package:wma_app/view/report_form/preview_img_value.dart';

import '../../Utils/Color.dart';
import '../../api/ManagerRequest.dart';
import '../../api/MediaRequest.dart';
import '../../api/OfficerRequest.dart';
import '../../model/user.dart';
import '../../widget/button_app.dart';
import '../../widget/dialog.dart';
import '../../widget/edittext.dart';
import '../../widget/text_widget.dart';
import '../report_list/report_list_view.dart';

class ApprovePopup extends StatefulWidget {
  String dateLabel;
  String authorization;
  String doo;
  String ph;
  String temp;
  String treatedDoo;
  String treatedPh;
  String treatedTemp;
  String treatedWater;
  String type;
  String role;
  Station station;
  String documentId;
  List<String> files;
  List<String> mediaDelete;
  List<dynamic> img = [];

  ApprovePopup({
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
    required this.files,
    required this.mediaDelete,
    required this.img,
  }) : super(key: key);

  @override
  State<ApprovePopup> createState() => _ApprovePopupState();
}

class _ApprovePopupState extends State<ApprovePopup> {
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
                  TextWidget.textSubTitleBoldMedium(widget.station.lite_name),
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
                                  widget.role == 'OFFICER' ? uploadPhotoCardOfficer() : uploadPhotoCardManager(),
                                  reportSummary(),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  footer(),
                                ])))),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
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

  Widget uploadPhotoCardOfficer() {
    String str = jsonEncode(widget.img);
    
    print(' str $str');
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
                return Card(
                  child: 
                  GestureDetector(
                         onTap: () {
                          Get.to(PreviewImage(
                            img: widget.img[index],
                          ));},
                    child: 
                    // widget.img[index]['type'] == 'url'
                    //     ? 
                        Image.network(
                            widget.img[index],
                            height: 170,
                            width: 100,
                          )
                        // : Image.file(
                        //     widget.img[index],
                        //     height: 170,
                        //     width: 100,
                        //   ),
                  ),
                );
              },
            )),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

   Widget uploadPhotoCardManager() {
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
                return Card(
                  child: 
                  GestureDetector(
                         onTap: () {
                          Get.to(PreviewImageValue(
                            img: widget.img[index],
                          ));},
                    child: widget.img[index]['type'] == 'url'
                        ? 
                        Image.network(
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
                );
              },
            )),
        const SizedBox(
          height: 5,
        ),
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
                widget.role == 'OFFICER'
                    ? TextWidget.textTitleBold('')
                    : TextWidget.textTitleBold('จาก: '),
                widget.role == 'OFFICER'
                    ? TextWidget.textTitle('โน้ตหมายเหตุ')
                    : TextWidget.textTitle('ผู้จัดการ'),
              ],
            ),
            Row(
              children: [
                widget.role == 'OFFICER'
                    ? TextWidget.textTitle('')
                    : TextWidget.textTitleBold('ถึง: '),
                widget.role == 'OFFICER'
                    ? TextWidget.textTitle(
                        'เห็นเฉพาะเจ้าหน้าที่ส่วนกลางและแอดมิน')
                    : TextWidget.textTitle('เจ้าหน้าที่ส่วนกลาง'),
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

          var result;

          if (widget.role == 'OFFICER') {
            result = await OfficerRequest.approval(widget.authorization,
                widget.documentId, 'APPROVE', commentController.text);
          } else {
            for (var i = 0; i < widget.mediaDelete.length; i++) {
              var result = await MediaRequest.delete(
                  widget.authorization, widget.mediaDelete[i]);
              if (result['code'] != '200') {
                MyDialog.showAlertDialogOk(context, '${result['message']}', () {
                  Get.back();
                });
              }
            }

            var today = DateTime.now();
            final outputFormat = DateFormat('yyyy-MM-dd');

            var outputDate = outputFormat.format(today);

            result = await ManagerRequest.revisionDocument(
                widget.authorization,
                widget.station.id,
                widget.documentId,
                widget.doo,
                widget.ph,
                widget.temp,
                widget.treatedDoo,
                widget.treatedPh,
                widget.treatedTemp,
                widget.files,
                widget.treatedWater,
                outputDate,
                widget.type,
                commentController.text);
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
