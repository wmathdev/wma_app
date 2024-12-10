// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wma_app/Utils/Color.dart';
import 'package:wma_app/Utils/month.dart';
import 'package:wma_app/api/MaintainanceRequest.dart';

import 'package:wma_app/model/user.dart';
import 'package:wma_app/widget/button_app.dart';
import 'package:wma_app/widget/edittext.dart';
import 'package:wma_app/widget/navigatebar.dart';
import 'package:wma_app/widget/text_widget.dart';

class Maintainance extends StatefulWidget {
  Station station;
  dynamic data;
  Maintainance({
    Key? key,
    required this.station,
    required this.data,
  }) : super(key: key);

  @override
  State<Maintainance> createState() => _MaintainanceState();
}

class _MaintainanceState extends State<Maintainance> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController commentController = TextEditingController();
  bool commentValidate = false;
  bool loading = false;

  List<File> img = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              NavigateBar.NavBar(context, 'การแจ้งเตือนเกณฑ์การบํารุงรักษา',
                  () {
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
    return SingleChildScrollView(
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
        // Row(
        //   children: [
        //     const SizedBox(
        //       width: 20,
        //     ),
        //     Expanded(child: TextWidget.textTitle('${widget.data['detail']}')),
        //   ],
        // ),
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: TextWidget.textTitle(
                    'ประจำวันที่ ${Month.getMonthTitleReverse(widget.data['report_at'])}')),
          ],
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
                color: widget.data['state'] == 'OPEN' ? yellow_n : green_n,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              child: TextWidget.textTitle('รอการรายงาน (OPEN)'),
            ),
          ],
        ),
        Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget.textTitle(
                          '${widget.data['instrument']['name']} มีชั่วโมงการทำงาน'),
                      TextWidget.textTitleBold(
                          '${widget.data['cycles_hr']} ชั่วโมง'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget.textTitle(
                          'รอบการเเจ้งเตือนชั่วโมงการทำงานทุกๆ'),
                      TextWidget.textTitleBold(
                          ' ${widget.data['data']['measure']} ชั่วโมง'),
                    ],
                  ),
                ]))),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            TextWidget.textTitle('การบำรุงรักษา'),
          ],
        ),
        Edittext.edittextAreaFormWhite('', '', commentController, false),
        uploadPhotoCard(),
        ButtonApp.buttonMain(context, 'ส่งรายงาน', () async {
          final SharedPreferences prefs = await _prefs;
          String? authorization = prefs.getString('access_token');

          if (validate()) {
            List<String> dataImg = [];
            for (var i = 0; i < img.length; i++) {
              String temp = convertIntoBase64(img[i]);
              dataImg.add(temp);
            }
            print('object ${commentController.text}');
            var result = await Maintainancerequest.revisionDocument(
                authorization!,
                widget.data['id'],
                commentController.text,
                dataImg);
            if (result['success'] == true) {
              Get.back();
              Get.back(); 
            } else {
              _showSnackBarAlert(result['message']);
            }
          }
        }, true),
      ]),
    );
  }

  _showSnackBarAlert(String s) {
    var snackBar = SnackBar(
      content: Text(s),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String convertIntoBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    String base64File = base64Encode(imageBytes);
    return base64File;
  }

  bool validate() {
    var valid = true;

    if (commentController.text == '') {
      valid = false;
      setState(() {
        commentValidate = true;
      });
    }
    return valid;
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
        ButtonApp.buttonMainGradient(
            context, 'เปิดกล้องถ่ายภาพ (${img.length}/4)', () async {
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
        }, true),
      ],
    );
  }

  _showSnackBar() {
    const snackBar = SnackBar(
      content: Text('อัปโหลดภาพได้สูงสุด 4 ภาพ'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
