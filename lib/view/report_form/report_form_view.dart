// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wma_app/Utils/month.dart';
import 'package:wma_app/view/report_form/recheck_popup.dart';

import '../../Utils/Color.dart';
import '../../api/OperatorRequest.dart';
import '../../model/user.dart';
import '../../widget/button_app.dart';
import '../../widget/dialog.dart';
import '../../widget/edittext.dart';
import '../../widget/navigatebar.dart';
import '../../widget/text_widget.dart';

class ReportForm extends StatefulWidget {
  Station station;
  String role;
  DateTime date;
  ReportForm({
    Key? key,
    required this.station,
    required this.role,
    required this.date,
  }) : super(key: key);

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  var totalController = TextEditingController();
  var totalValidate = false;
  var doBeforeController = TextEditingController();
  var doBeforeValidate = false;
  var phBeforeController = TextEditingController();
  var phBeforeValidate = false;
  var temperatureBeforeController = TextEditingController();
  var temperatureBeforeValidate = false;
  var doAfterController = TextEditingController();
  var doAfterValidate = false;
  var phAfterController = TextEditingController();
  var phAfterValidate = false;
  var temperatureAfterController = TextEditingController();
  var temperatureAfterValidate = false;

  var isCheckBox = false;

  List<File> img = [];

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late var today;
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
    today = widget.date;
    var outputDate = outputFormat.format(today);
    var yesterday = today.subtract(Duration(days: 1));
    outputYesterdayDate = outputFormat.format(yesterday);
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              widget.role == 'ADMIN'
                  ? const SizedBox(
                      height: 30,
                    )
                  : notice(),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                width: MediaQuery.of(context).size.width,
                child: TextWidget.textGeneralWithColor(
                    'ข้อมูลคุณภาพน้ำประจำวันที่ ${Month.getMonthTitleReverse(outputDate)}',
                    greyBorder),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                width: MediaQuery.of(context).size.width,
                child: TextWidget.textGeneral('สถานะปัจจุบัน'),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                width: MediaQuery.of(context).size.width,
                child:
                    TextWidget.textGeneral('--:-- น. | รอเจ้าหน้าที่ดำเนินการ'),
              ),
              // ButtonApp.buttonSecondary(
              //     context, 'ดูประวัติการส่งรายงานทั้งหมด', () {}),
              Container(height: 5, color: greyBG),
              uploadPhotoCard(),
              before(),
              Edittext.edittextForm(
                  'DO', 'mg/I', doBeforeController, doBeforeValidate),
              Edittext.edittextForm(
                  'pH', '', phBeforeController, phBeforeValidate),
              Edittext.edittextForm('Temperature', 'ํC',
                  temperatureBeforeController, temperatureBeforeValidate),
              after(),
              Edittext.edittextForm(
                  'DO', 'mg/I', doAfterController, doAfterValidate),
              Edittext.edittextForm(
                  'pH', '', phAfterController, phAfterValidate),
              Edittext.edittextForm('Temperature', 'ํC',
                  temperatureAfterController, temperatureAfterValidate),
              Container(
                height: 10,
                color: greyBG,
              ),
              checkBox(),
              Container(
                height: 10,
                color: greyBG,
              ),
              ButtonApp.buttonMain(context, 'ส่งรายงาน', () async {
                final SharedPreferences prefs = await _prefs;
                String? authorization = prefs.getString('access_token');

                if (validate()) {
                  List<String> dataImg = [];
                  for (var i = 0; i < img.length; i++) {
                    String temp = convertIntoBase64(img[i]);
                    dataImg.add(temp);
                  }

                  if (!dataImg.isNotEmpty) {
                    MyDialog.showAlertDialogOk(
                        context, 'กรุณาแนบภาพอย่างน้อย 1 ภาพ', () {
                      Get.back();
                    });
                  } else {
                    Get.to(RecheckPopUp(
                      station: widget.station,
                      role: widget.role,
                      dateLabel: Month.getMonthTitleReverse(outputDate),
                      authorization: authorization!,
                      doo: doBeforeController.text,
                      file: dataImg,
                      ph: phBeforeController.text,
                      temp: temperatureBeforeController.text,
                      treatedDoo: doAfterController.text,
                      treatedPh: phAfterController.text,
                      treatedTemp: temperatureAfterController.text,
                      treatedWater: totalController.text,
                      type: 'DAILY',
                      date: outputDate,
                    ));
                  }
                }
              }, isCheckBox),
              ButtonApp.buttonSecondary(
                context,
                'ยกเลิก',
                () {
                  Get.back();
                },
              )
            ],
          ),
        ),
        Container(
          height: 80,
          alignment: Alignment.topCenter,
          child: NavigateBar.NavBarWithNotebook(
              context, 'รายงานคุณภาพน้ำประจำวัน', () {
            Get.back();
          }),
        ),
      ],
    );
  }

  Widget before() {
    return Container(
      color: greyBG,
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
                  color: blueSelected,
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
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
            TextWidget.textBig('ก่อน'),
            TextWidget.textGeneralWithColor('คุณภาพน้ำก่อนบำบัด', Colors.grey),
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
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
          width: MediaQuery.of(context).size.width,
          child: TextWidget.textGeneral('รูปภาพประกอบ'),
        ),
        const SizedBox(
          height: 10,
        ),
        // DottedBorder(
        //     borderType: BorderType.RRect,
        //     radius: const Radius.circular(5),
        //     dashPattern: const [10, 10],
        //     color: Colors.grey,
        //     strokeWidth: 2,
        //     child: Container(
        //       padding: EdgeInsets.all(50),
        //       width: MediaQuery.of(context).size.width * 0.9,
        //       child: Column(
        //         children: [
        //           const ImageIcon(AssetImage('asset/images/carbon_camera.png')),
        //           TextWidget.textGeneral('ถ่ายภาพ')
        //         ],
        //       ),
        //     )),
        SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: img.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Card(
                      child: Image.file(
                        img[index],
                        height: 170,
                        width: 100,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        img.removeAt(index);
                        setState(() {});
                      },
                      child: Image.asset(
                        'asset/images/close.png',
                      ),
                    ),
                  ],
                );
              },
            )),
        const SizedBox(
          height: 5,
        ),
        ButtonApp.buttonOutline(context, 'เปิดกล้องถ่ายภาพ (${img.length}/4)',
            () async {
          if (img.length >= 4) {
            _showSnackBar();
          } else {
            final ImagePicker _picker = ImagePicker();
            final XFile? photo = await _picker.pickImage(
                source: ImageSource.camera, imageQuality: 80);
            File photofile = File(photo!.path);
            img.add(photofile);
            setState(() {});
          }
        }),
        const SizedBox(
          height: 5,
        ),
        Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            child: Edittext.edittextForm(
                'ปริมาณน้ำเสียที่ผ่านการบำบัด (วันที่ ${Month.getMonthTitleReverse(outputYesterdayDate)})',
                'ลบ.ม.',
                totalController,
                totalValidate)),
      ],
    );
  }

  _showSnackBar() {
    const snackBar = SnackBar(
      content: Text('อัปโหลดภาพได้สูงสุด 4 ภาพ'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget after() {
    return Container(
      color: blueButtonBorder,
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
                  color: blueSelected,
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
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
            TextWidget.textBig('หลัง'),
            TextWidget.textGeneralWithColor('คุณภาพน้ำหลังบำบัด', Colors.grey),
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
          child: TextWidget.textGeneralWithColor(
              'กรุณาตรวจสอบความถูกต้องหลังจากกด “ยืนยัน”\nจะเข้าสู่สถานะ “รอผู้จัดการตรวจสอบ”',
              Colors.grey),
        ),
      ],
    );
  }

  bool validate() {
    var valid = true;

    if (totalController.text == '') {
      valid = false;
      setState(() {
        totalValidate = true;
      });
    }

    if (doBeforeController.text == '') {
      valid = false;
      setState(() {
        doBeforeValidate = true;
      });
    }

    if (phBeforeController.text == '') {
      valid = false;
      setState(() {
        phBeforeValidate = true;
      });
    }

    if (temperatureBeforeController.text == '') {
      valid = false;
      setState(() {
        temperatureBeforeValidate = true;
      });
    }

    if (doAfterController.text == '') {
      valid = false;
      setState(() {
        doAfterValidate = true;
      });
    }

    if (phAfterController.text == '') {
      valid = false;
      setState(() {
        phAfterValidate = true;
      });
    }

    if (temperatureAfterController.text == '') {
      valid = false;
      setState(() {
        temperatureAfterValidate = true;
      });
    }

    return valid;
  }

  String convertIntoBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    String base64File = base64Encode(imageBytes);
    return base64File;
  }
}
