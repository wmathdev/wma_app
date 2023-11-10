// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wma_app/view/report_form/reject_popup.dart';

import '../../Utils/Color.dart';
import '../../Utils/month.dart';
import '../../api/ManagerRequest.dart';

import '../../model/user.dart';
import '../../widget/button_app.dart';
import '../../widget/dialog.dart';
import '../../widget/edittext.dart';
import '../../widget/navigatebar.dart';
import '../../widget/text_widget.dart';
import '../report_home/progress_detail.dart';
import 'approve_popup.dart';

class ReportFormManager extends StatefulWidget {
  String role;
  dynamic document;
  Station station;
  String datelabel;

  ReportFormManager({
    Key? key,
    required this.role,
    required this.document,
    required this.station,
    required this.datelabel,
  }) : super(key: key);

  @override
  State<ReportFormManager> createState() => _ReportFormManagerState();
}

class _ReportFormManagerState extends State<ReportFormManager> {
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

  var loading = true;
  var isCheckBox = false;

  List<dynamic> img = [];
  List<String> delete = [];

  var accessToken = '';
  var result;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var today = DateTime.now();
  final outputFormat = DateFormat('yyyy-MM-dd');

  String formattedDate = '';

  Future<void> _getDocumentList() async {
    ;
    final SharedPreferences prefs = await _prefs;
    accessToken = (prefs.getString('access_token') ?? '');

    result = await ManagerRequest.getDocumentShow(
        accessToken, '${widget.document['id']}');

    setState(() {
      totalController.text = '${result['data']['treated_water'] ?? ''}';
      doBeforeController.text = '${result['data']['doo'] ?? ''}';
      phBeforeController.text = '${result['data']['ph'] ?? ''}';
      temperatureBeforeController.text = '${result['data']['temp'] ?? ''}';

      doAfterController.text = '${result['data']['treated_doo'] ?? ''}';
      phAfterController.text = '${result['data']['treated_ph'] ?? ''}';
      temperatureAfterController.text =
          '${result['data']['treated_temp'] ?? ''}';

      if (result['data']['files'] != null) {
        List<dynamic> files = result['data']['files'];

        for (var i = 0; i < files.length; i++) {
          img.add({
            'type': 'url',
            'value': files[i]['url'],
            'uuid': files[i]['uuid']
          });
        }
      }

      // commentController.text =
      //     '${result['data']['workflow']['transactions'][0]['signer']['comment']}';

      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (loading) {
      _getDocumentList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
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
          : Container(
              color: Colors.grey[60],
              child: contentView(),
            ),
    ));
  }

  Widget contentView() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              notice(),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                width: MediaQuery.of(context).size.width,
                child: TextWidget.textGeneralWithColor(
                    'ข้อมูลคุณภาพน้ำประจำวันที่ ${Month.getMonthTitleReverse(result['data']['report_at'])}',
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
                child: TextWidget.textGeneral(
                    '${result['data']['workflow']['transactions'][0]['time']} | ${result['data']['workflow']['transactions'][0]['type']}'),
              ),
              ButtonApp.buttonSecondary(context, 'ดูประวัติการส่งรายงานทั้งหมด',
                  () {
                Get.to(ProgressDetail(
                  result: result,
                  dateLebal:
                      Month.getMonthTitleReverse(result['data']['report_at']),
                ));
              }),
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
              listViewComment(),
              checkBox(),
              Container(
                height: 10,
                color: greyBG,
              ),
              ButtonApp.buttonMain(context, 'ยืนยัน', () async {
                final SharedPreferences prefs = await _prefs;
                String? authorization = prefs.getString('access_token');

                List<String> dataImg = [];
                for (var i = 0; i < img.length; i++) {
                  if (img[i]['type'] == 'file') {
                    print('ธธธธธธธธธธธธ');
                    print(dataImg);
                    String temp = convertIntoBase64(img[i]['value']);
                    dataImg.add(temp);
                  }
                }

                if (!img.isNotEmpty) {
                  MyDialog.showAlertDialogOk(
                      context, 'กรุณาแนบภาพอย่างน้อย 1 ภาพ', () {
                    Get.back();
                  });
                } else {
                  Get.to(ApprovePopup(
                    role: widget.role,
                    station: widget.station,
                    dateLabel: Month.getMonthTitleReverse(widget.datelabel),
                    authorization: authorization!,
                    doo: doBeforeController.text,
                    files: dataImg,
                    ph: phBeforeController.text,
                    temp: temperatureBeforeController.text,
                    treatedDoo: doAfterController.text,
                    treatedPh: phAfterController.text,
                    treatedTemp: temperatureAfterController.text,
                    treatedWater: totalController.text,
                    type: 'DAILY',
                    documentId: '${widget.document['id']}',
                    mediaDelete: delete,
                  ));
                }
              }, isCheckBox),
              ButtonApp.buttonSecondaryWithColor(context, 'ตีกลับ', () async {
                final SharedPreferences prefs = await _prefs;
                String? authorization = prefs.getString('access_token');

                Get.to(RejectPopup(
                  role: widget.role,
                  station: widget.station,
                  dateLabel: widget.datelabel,
                  authorization: authorization!,
                  doo: doBeforeController.text,
                  // file: img,
                  ph: phBeforeController.text,
                  temp: temperatureBeforeController.text,
                  treatedDoo: doAfterController.text,
                  treatedPh: phAfterController.text,
                  treatedTemp: temperatureAfterController.text,
                  treatedWater: totalController.text,
                  type: 'DAILY',
                  documentId: '${widget.document['id']}',
                ));
                // }
              }, Colors.red)
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
              'กรุณาตรวจสอบความถูกต้อง หลังจากกด “ยืนยัน”\nจะเข้าสู่สถานะ “รอส่วนกลางการตรวจสอบ”',
              Colors.grey),
        ),
      ],
    );
  }

  Widget listViewComment() {
    var temlist = result['data']['workflow']['transactions'];
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: temlist.length,
      itemBuilder: (context, index) {
        var temp = TextEditingController();
        // temp.text = '${result['data']['workflow']['transactions'][index]['signer']['comment']}';
        if (result['data']['workflow']['transactions'][index]['signer']
                    ['comment'] ==
                '' ||
            result['data']['workflow']['transactions'][index]['signer']
                    ['comment'] ==
                null) {
          return Container();
        }
        return commentItem(
            temp,
            result['data']['workflow']['transactions'][index]['reporter'],
            result['data']['workflow']['transactions'][index]['assign'],
            '${result['data']['workflow']['transactions'][index]['signer']['comment']}',
            '${result['data']['workflow']['transactions'][index]['created_at']}',
            Colors.blue[200]);
      },
    );
  }

  bool equalsIgnoreCase(String? string1, String? string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }

  Widget commentItem(TextEditingController commentController, String form,
      String to, String comment, String datetime, Color? color) {
    commentController.text = comment;
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
              color: orange,
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Column(children: [
            Row(
              children: [
                TextWidget.textTitleBold('จาก: '),
                TextWidget.textTitle(form),
              ],
            ),
            to == ''
                ? Container()
                : Row(
                    children: [
                      TextWidget.textTitleBold('ถึง: '),
                      TextWidget.textTitle(to),
                    ],
                  ),
          ]),
        ),
        Edittext.edittextAreaFormDisable('', '', commentController, false),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextWidget.textTitleBoldWithColor('', blueSelected),
              TextWidget.textTitle(Month.getNoteTime(datetime))
            ],
          ),
        )
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
                        'ผู้จัดการ โปรดตรวจสอบก่อนเวลา 10.00 น.', Colors.red)),
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
                      child: img[index]['type'] == 'url'
                          ? Image.network(
                              img[index]['value'],
                              height: 170,
                              width: 100,
                            )
                          : Image.file(
                              img[index]['value'],
                              height: 170,
                              width: 100,
                            ),
                    ),
                    GestureDetector(
                      onTap: () {
                        delete.add(img[index]['uuid']);
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
              source: ImageSource.camera,
              imageQuality: 80,
            );
            File photofile = File(photo!.path);
            img.add({'type': 'file', 'value': photofile, 'uuid': ''});
            setState(() {});
          }
        }),
        const SizedBox(
          height: 5,
        ),
        Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            child: Edittext.edittextForm('ปริมาณน้ำเสียที่ผ่านการบำบัด',
                'ลบ.ม.', totalController, totalValidate)),
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

  // Widget checkBox() {
  //   return Row(
  //     children: [
  //       Checkbox(
  //           value: isCheckBox,
  //           onChanged: (value) {
  //             setState(() {
  //               isCheckBox = !isCheckBox;
  //             });
  //           }),
  //       const SizedBox(
  //         width: 20,
  //       ),
  //       TextWidget.textGeneralWithColor(
  //           'กรุณาตรวจสอบความถูกต้องหลังจากกด “ยืนยัน”\nจะเข้าสู่สถาานะ “รอผู้จัดการตรวจสอบ”',
  //           Colors.grey),
  //     ],
  //   );
  // }

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
}
