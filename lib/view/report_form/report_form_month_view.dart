// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wma_app/view/report_form/recheck_popup_month.dart';

import '../../Utils/Color.dart';
import '../../Utils/month.dart';
import '../../model/user.dart';
import '../../widget/button_app.dart';
import '../../widget/dialog.dart';
import '../../widget/edittext.dart';
import '../../widget/navigatebar.dart';
import '../../widget/text_widget.dart';

class ReportFormMonth extends StatefulWidget {
  Station station;
  String role;
  String date;
  ReportFormMonth({
    Key? key,
    required this.station,
    required this.role,
    required this.date,
  }) : super(key: key);

  @override
  State<ReportFormMonth> createState() => _ReportFormMonthState();
}

class _ReportFormMonthState extends State<ReportFormMonth> {
  var powerElectricController = TextEditingController();
  var powerElectricValidate = false;

  var bodBeforeController = TextEditingController();
  var bodBeforeValidate = false;
  var codBeforeController = TextEditingController();
  var codBeforeValidate = false;
  var ssBeforeController = TextEditingController();
  var ssBeforeValidate = false;
  var fogBeforeController = TextEditingController();
  var fogBeforeValidate = false;
  var totalNitrogenBeforeController = TextEditingController();
  var totalNitrogenBeforeValidate = false;
  var totalPhosphorusBeforeController = TextEditingController();
  var totalPhosphorusBeforeValidate = false;
  var saltBeforeController = TextEditingController();
  var saltBeforeValidate = false;
  var bodAfterController = TextEditingController();
  var bodAfterValidate = false;
  var codAfterController = TextEditingController();
  var codAfterValidate = false;
  var ssAfterController = TextEditingController();
  var ssAfterValidate = false;
  var fogAfterController = TextEditingController();
  var fogAfterValidate = false;
  var totalNitrogenAfterController = TextEditingController();
  var totalNitrogenAfterValidate = false;
  var totalPhosphorusAfterController = TextEditingController();
  var totalPhosphorusAfterValidate = false;
  var saltAfterController = TextEditingController();
  var saltAfterValidate = false;

  var isCheckBox = false;

  List<File> img = [];

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final outputFormat = DateFormat('yyyy-MM-dd');
  var outputYesterdayDate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        color: Colors.grey[60],
        child: contentView(),
      ),
    ));
  }

  Widget contentView() {
    var outputDate = widget.date;
    var today = DateFormat("yyyy-MM-dd").parse(outputDate);
    var yesterday = today.subtract(Duration(days: 1));
    outputYesterdayDate = outputFormat.format(yesterday);
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('asset/images/waterbg.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 80,
                  alignment: Alignment.topCenter,
                  child: NavigateBar.NavBarWithNotebook(
                      context, 'รายงานคุณภาพน้ำประจำเดือน', () {
                    // Get.back();
                    showAlertDialog(context);
                  }),
                ),
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
                widget.role == 'ADMIN'
                    ? const SizedBox(
                        height: 30,
                      )
                    : notice(),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                            width: MediaQuery.of(context).size.width,
                            child: TextWidget.textTitleBold('ข้อมูลคุณภาพน้ำ'),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                            width: MediaQuery.of(context).size.width,
                            child: TextWidget.textTitle(
                              'ประจำวันที่ ${Month.getMonthTitleReverse(outputDate)}',
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
                            height: 7,
                          ),
                          Container(height: 1, color: Colors.black),
                          const SizedBox(
                            height: 5,
                          ),
                          uploadPhotoCard(),
                          const SizedBox(
                            height: 7,
                          ),
                          Container(height: 1, color: Colors.black),
                          const SizedBox(
                            height: 5,
                          ),
                          before(),
                          Edittext.edittextForm('BOD', 'mg/I',
                              bodBeforeController, bodBeforeValidate),
                          Edittext.edittextForm('COD', 'mg/I',
                              codBeforeController, codBeforeValidate),
                          Edittext.edittextForm('SS', 'mg/I',
                              ssBeforeController, ssBeforeValidate),
                          Edittext.edittextForm('Fat, Oil and Grease', 'mg/I',
                              fogBeforeController, fogBeforeValidate),
                          Edittext.edittextForm(
                              'Total Nitrogen',
                              'mg/I',
                              totalNitrogenBeforeController,
                              totalNitrogenBeforeValidate),
                          Edittext.edittextForm(
                              'Total Phosphorus',
                              'mg/I',
                              totalPhosphorusBeforeController,
                              totalPhosphorusBeforeValidate),
                          Edittext.edittextForm('ความเค็ม', 'ppt.',
                              saltBeforeController, saltBeforeValidate),
                          const SizedBox(
                            height: 7,
                          ),
                          Container(height: 1, color: Colors.black),
                          const SizedBox(
                            height: 5,
                          ),
                          after(),
                          Edittext.edittextForm('BOD', 'mg/I',
                              bodAfterController, bodAfterValidate),
                          Edittext.edittextForm('COD', 'mg/I',
                              codAfterController, codAfterValidate),
                          Edittext.edittextForm(
                              'SS', 'mg/I', ssAfterController, ssAfterValidate),
                          Edittext.edittextForm('Fat, Oil and Grease', 'mg/I',
                              fogAfterController, fogAfterValidate),
                          Edittext.edittextForm(
                              'Total Nitrogen',
                              'mg/I',
                              totalNitrogenAfterController,
                              totalNitrogenAfterValidate),
                          Edittext.edittextForm(
                              'Total Phosphorus',
                              'mg/I',
                              totalPhosphorusAfterController,
                              totalPhosphorusAfterValidate),
                          Edittext.edittextForm('ความเค็ม', 'ppt.',
                              saltAfterController, saltAfterValidate),
                          const SizedBox(
                            height: 7,
                          ),
                          Container(height: 1, color: Colors.black),
                          const SizedBox(
                            height: 5,
                          ),
                          checkBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ButtonApp.buttonSecondaryHalf(
                                context,
                                'ยกเลิก',
                                () {
                                  Get.back();
                                },
                              ),
                              ButtonApp.buttonMainhalf(context, 'ส่งรายงาน',
                                  () async {
                                final SharedPreferences prefs = await _prefs;
                                String? authorization =
                                    prefs.getString('access_token');

                                // if (validate()) {
                                // List<String> dataImg = [];
                                // for (var i = 0; i < img.length; i++) {
                                //   String temp = convertIntoBase64(img[i]);
                                //   dataImg.add(temp);
                                // }
                                // if (!dataImg.isNotEmpty) {
                                //   MyDialog.showAlertDialogOk(
                                //       context, 'กรุณาแนบภาพอย่างน้อย 1 ภาพ', () {
                                //     Get.back();
                                //   });
                                // } else {
                                Get.to(RecheckPopupMonth(
                                  station: widget.station,
                                  role: widget.role,
                                  dateLabel:
                                      Month.getMonthTitleReverse(outputDate),
                                  authorization: authorization!,
                                  file: [],
                                  type: 'MONTHLY',
                                  bod: bodBeforeController.text,
                                  cod: codBeforeController.text,
                                  electric_unit: powerElectricController.text,
                                  fog: fogBeforeController.text,
                                  salt: saltBeforeController.text,
                                  ss: ssBeforeController.text,
                                  totalNitrogen:
                                      totalNitrogenBeforeController.text,
                                  totalPhosphorous:
                                      totalPhosphorusBeforeController.text,
                                  treated_total_phosphorous:
                                      totalPhosphorusAfterController.text,
                                  treated_bod: bodAfterController.text,
                                  treated_cod: codAfterController.text,
                                  treated_fog: fogAfterController.text,
                                  treated_salt: saltAfterController.text,
                                  treated_ss: ssAfterController.text,
                                  treated_total_nitrogen:
                                      totalNitrogenAfterController.text,
                                  date: outputDate,
                                ));
                                // }
                              }, isCheckBox),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // ButtonApp.buttonSecondary(
                //     context, 'ดูประวัติการส่งรายงานทั้งหมด', () {}),
              ],
            ),
          ),
        ),
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
        const SizedBox(
          width: 20,
        ),
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

  Widget notice() {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Card(
          color: Colors.red[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // IconButton(
                //   icon: Image.asset(
                //     'asset/images/notice_card.png',
                //   ),
                //   onPressed: () {},
                // ),
                Expanded(
                    child: TextWidget.textGeneralWithColor(
                        'โปรดรายงานคุณภาพน้ำก่อนเวลา 10.00 น.', Colors.red)),
              ],
            ),
          )),
    );
  }

  Widget uploadPhotoCard() {
    return Column(
      children: [
        // const SizedBox(
        //   height: 10,
        // ),
        // Container(
        //   padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
        //   width: MediaQuery.of(context).size.width,
        //   child: TextWidget.textGeneral('รูปภาพประกอบ'),
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        // // DottedBorder(
        // //     borderType: BorderType.RRect,
        // //     radius: const Radius.circular(5),
        // //     dashPattern: const [10, 10],
        // //     color: Colors.grey,
        // //     strokeWidth: 2,
        // //     child: Container(
        // //       padding: EdgeInsets.all(50),
        // //       width: MediaQuery.of(context).size.width * 0.9,
        // //       child: Column(
        // //         children: [
        // //           const ImageIcon(AssetImage('asset/images/carbon_camera.png')),
        // //           TextWidget.textGeneral('ถ่ายภาพ')
        // //         ],
        // //       ),
        // //     )),
        // SizedBox(
        //     height: 150,
        //     child: ListView.builder(
        //       scrollDirection: Axis.horizontal,
        //       itemCount: img.length,
        //       itemBuilder: (context, index) {
        //         return Stack(
        //           children: [
        //             Card(
        //               child: Image.file(
        //                 img[index],
        //                 height: 170,
        //                 width: 100,
        //               ),
        //             ),
        //             GestureDetector(
        //               onTap: () {
        //                 img.removeAt(index);
        //                 setState(() {});
        //               },
        //               child: Image.asset(
        //                 'asset/images/close.png',
        //               ),
        //             ),
        //           ],
        //         );
        //       },
        //     )),
        // const SizedBox(
        //   height: 5,
        // ),
        // ButtonApp.buttonOutline(context, 'เปิดกล้องถ่ายภาพ', () async {
        //   final ImagePicker _picker = ImagePicker();
        //   final XFile? photo = await _picker.pickImage(
        //       source: ImageSource.camera, imageQuality: 80);
        //   File photofile = File(photo!.path);
        //   img.add(photofile);
        //   setState(() {});
        // }),
        const SizedBox(
          height: 5,
        ),
        Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          child: Edittext.edittextForm('ปริมาณพลังงานไฟฟ้าที่ใช้', 'kW-hr',
              powerElectricController, powerElectricValidate),
        ),
      ],
    );
  }

  Widget after() {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          afterHeader(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget afterHeader() {
    return Row(
      children: [
        const SizedBox(
          width: 20,
        ),
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

  Widget checkBox() {
    return Row(
      children: [
        Checkbox(
            value: isCheckBox,
            onChanged: (value) {
              setState(() {
                isCheckBox = !isCheckBox;
              });
            }),
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: TextWidget.textSubTitleWithSize(
                'กรุณาตรวจสอบความถูกต้องก่อนกด “ยืนยัน” เมื่อกด “ยืนยัน” \nแล้วสถานะจะเปลี่ยนเป็น “รอผู้จัดการตรวจสอบ”',
                10)),
      ],
    );
  }

  // bool validate() {
  //   var valid = true;

  //   if (totalController.text == '') {
  //     valid = false;
  //     setState(() {
  //       totalValidate = true;
  //     });
  //   }

  //   if (doBeforeController.text == '') {
  //     valid = false;
  //     setState(() {
  //       doBeforeValidate = true;
  //     });
  //   }

  //   if (phBeforeController.text == '') {
  //     valid = false;
  //     setState(() {
  //       phBeforeValidate = true;
  //     });
  //   }

  //   if (temperatureBeforeController.text == '') {
  //     valid = false;
  //     setState(() {
  //       temperatureBeforeValidate = true;
  //     });
  //   }

  //   if (doAfterController.text == '') {
  //     valid = false;
  //     setState(() {
  //       doAfterValidate = true;
  //     });
  //   }

  //   if (phAfterController.text == '') {
  //     valid = false;
  //     setState(() {
  //       phAfterValidate = true;
  //     });
  //   }

  //   if (temperatureAfterController.text == '') {
  //     valid = false;
  //     setState(() {
  //       temperatureAfterValidate = true;
  //     });
  //   }

  //   return valid;
  // }

  String convertIntoBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    String base64File = base64Encode(imageBytes);
    return base64File;
  }

  showAlertDialog(BuildContext context) async {
    // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    // final SharedPreferences prefs = await _prefs;
    // // set up the button
    Widget okButton = TextButton(
      child: Text("ยืนยัน"),
      onPressed: () async {
        Get.back();
        Get.back();
      },
    );

    Widget calcelButton = TextButton(
      child: Text("ยกเลิก"),
      onPressed: () {
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("คุณต้องการออกจากรายงานใช่หรือไม่"),
      content: Text("หากกด ยืนยัน ข้อมูลจะถูกล้าง"),
      actions: [okButton, calcelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
