// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wma_app/model/user.dart';
import 'package:wma_app/view/report_home/progress_detail.dart';

import '../../Utils/Color.dart';
import '../../Utils/month.dart';
import '../../api/ManagerRequest.dart';
import '../../api/OfficerRequest.dart';
import '../../api/OperatorRequest.dart';
import '../../widget/button_app.dart';
import '../../widget/edittext.dart';
import '../../widget/navigatebar.dart';
import '../../widget/text_widget.dart';

class ReportDetailMonth extends StatefulWidget {
  String documentId;
  String role;
  Station station;

  ReportDetailMonth({
    Key? key,
    required this.documentId,
    required this.role,
    required this.station
  }) : super(key: key);

  @override
  State<ReportDetailMonth> createState() => _ReportDetailMonthState();
}

class _ReportDetailMonthState extends State<ReportDetailMonth> {
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

  var loading = true;
  var isCheckBox = false;

  List<String> img = [];
  var accessToken = '';
  var result;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var today = DateTime.now();
  final outputFormat = DateFormat('yyyy-MM-dd');

  Future<void> _getDocumentList() async {
    final SharedPreferences prefs = await _prefs;
    accessToken = (prefs.getString('access_token') ?? '');

    if (widget.role == 'OPERATOR' || widget.role == 'ADMIN') {
      result =
          await OperatorRequest.getDocumentShow(accessToken, widget.documentId);
    } else if (widget.role == 'MANAGER') {
      result =
          await ManagerRequest.getDocumentShow(accessToken, widget.documentId);
    } else if (widget.role == 'OFFICER') {
      result =
          await OfficerRequest.getDocumentShow(accessToken, widget.documentId);
    }

    setState(() {
      powerElectricController.text = '${result['data']['electric_unit'] ?? ''}';
      bodBeforeController.text = '${result['data']['bod'] ?? ''}';
      codBeforeController.text = '${result['data']['cod'] ?? ''}';
      ssBeforeController.text = '${result['data']['ss'] ?? ''}';
      fogBeforeController.text = '${result['data']['fog'] ?? ''}';
      totalNitrogenBeforeController.text =
          '${result['data']['total_nitrogen'] ?? ''}';
      totalPhosphorusBeforeController.text =
          '${result['data']['total_phosphorous'] ?? ''}';
      saltBeforeController.text = '${result['data']['salt'] ?? ''}';

      bodAfterController.text = '${result['data']['treated_bod'] ?? ''}';
      codAfterController.text = '${result['data']['treated_cod'] ?? ''}';
      ssAfterController.text = '${result['data']['treated_ss'] ?? ''}';
      fogAfterController.text = '${result['data']['treated_fog'] ?? ''}';
      totalNitrogenAfterController.text =
          '${result['data']['treated_total_nitrogen'] ?? ''}';
      totalPhosphorusAfterController.text =
          '${result['data']['treated_total_phosphorous'] ?? ''}';
      saltAfterController.text = '${result['data']['treated_salt'] ?? ''}';

      List<dynamic> files = result['data']['files'];

      for (var i = 0; i < files.length; i++) {
        img.add(files[i]['url']);
      }

      loading = false;
    });
  }

  String formattedDate = '';

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
        resizeToAvoidBottomInset: false,
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
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('asset/images/waterbg.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: contentView(),
                ),
        ));
  }

  Widget contentView() {
    return Column(
      children: [
        Container(
          height: 70,
          alignment: Alignment.topCenter,
          child: NavigateBar.NavBarWithNotebook(
              context, 'รายงานคุณภาพน้ำประจำเดือน', () {
            Get.back();
          }),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.all(10),
                    child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
                            width: MediaQuery.of(context).size.width,
                            child: TextWidget.textTitleBold(
                                'ข้อมูลคุณภาพน้ำประจำเดือน'),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                            width: MediaQuery.of(context).size.width,
                            child: TextWidget.textTitle(
                              'ประจำวันที่ ${Month.getMonthTitleReverse(result['data']['report_at'])}',
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
                                  color: green_n,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextWidget.textTitle(
                                    '${result['data']['workflow']['transactions'][0]['time']} | ${result['data']['workflow']['transactions'][0]['type']}'),
                              ),
                            ],
                          ),
                          ButtonApp.buttonSecondaryGradient(
                              context, 'ดูประวัติการส่งรายงานทั้งหมด', () {
                            Get.to(ProgressDetail(
                              result: result,
                              station: widget.station,
                              dateLebal: Month.getMonthTitleReverse(
                                  result['data']['report_at']),
                            ));
                          }),
                          const SizedBox(
                            height: 7,
                          ),
                          Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Container(height: 1, color: Colors.black)),
                          const SizedBox(
                            height: 5,
                          ),
                          uploadPhotoCard(),
                          const SizedBox(
                            height: 7,
                          ),
                          Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Container(height: 1, color: Colors.black)),
                          const SizedBox(
                            height: 5,
                          ),
                          before(),
                          Edittext.alignEdittextFormDisable(
                              'BOD',
                              'mg/I',
                              bodBeforeController,
                              bodBeforeValidate,
                              MediaQuery.of(context).size.width * 0.63),
                          Edittext.alignEdittextFormDisable(
                              'COD',
                              'mg/I',
                              codBeforeController,
                              codBeforeValidate,
                              MediaQuery.of(context).size.width * 0.63),
                          Edittext.alignEdittextFormDisable(
                              'SS',
                              'mg/I',
                              ssBeforeController,
                              ssBeforeValidate,
                              MediaQuery.of(context).size.width * 0.63),
                          Edittext.alignEdittextFormDisable(
                              'Fat, Oil and Grease',
                              'mg/I',
                              fogBeforeController,
                              fogBeforeValidate,
                              MediaQuery.of(context).size.width * 0.63),
                          Edittext.alignEdittextFormDisable(
                              'Total Nitrogen',
                              'mg/I',
                              totalNitrogenBeforeController,
                              totalNitrogenBeforeValidate,
                              MediaQuery.of(context).size.width * 0.63),
                          Edittext.alignEdittextFormDisable(
                              'Total Phosphorus',
                              'mg/I',
                              totalPhosphorusBeforeController,
                              totalPhosphorusBeforeValidate,
                              MediaQuery.of(context).size.width * 0.63),
                          Edittext.alignEdittextFormDisable(
                              'ความเค็ม',
                              'ppt.',
                              saltBeforeController,
                              saltBeforeValidate,
                              MediaQuery.of(context).size.width * 0.63),
                          const SizedBox(
                            height: 7,
                          ),
                          Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Container(height: 1, color: Colors.black)),
                          const SizedBox(
                            height: 5,
                          ),
                          after(),
                          Edittext.alignEdittextFormDisable(
                              'BOD',
                              'mg/I',
                              bodAfterController,
                              bodAfterValidate,
                              MediaQuery.of(context).size.width * 0.63),
                          Edittext.alignEdittextFormDisable(
                              'COD',
                              'mg/I',
                              codAfterController,
                              codAfterValidate,
                              MediaQuery.of(context).size.width * 0.63),
                          Edittext.alignEdittextFormDisable(
                              'SS',
                              'mg/I',
                              ssAfterController,
                              ssAfterValidate,
                              MediaQuery.of(context).size.width * 0.63),
                          Edittext.alignEdittextFormDisable(
                              'Fat, Oil and Grease',
                              'mg/I',
                              fogAfterController,
                              fogAfterValidate,
                              MediaQuery.of(context).size.width * 0.63),
                          Edittext.alignEdittextFormDisable(
                              'Total Nitrogen',
                              'mg/I',
                              totalNitrogenAfterController,
                              totalNitrogenAfterValidate,
                              MediaQuery.of(context).size.width * 0.63),
                          Edittext.alignEdittextFormDisable(
                              'Total Phosphorus',
                              'mg/I',
                              totalPhosphorusAfterController,
                              totalPhosphorusAfterValidate,
                              MediaQuery.of(context).size.width * 0.63),
                          Edittext.alignEdittextFormDisable(
                              'ความเค็ม',
                              'ppt.',
                              saltAfterController,
                              saltAfterValidate,
                              MediaQuery.of(context).size.width * 0.63),
                          const SizedBox(
                            height: 7,
                          ),
                          Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Container(height: 1, color: Colors.black)),
                          const SizedBox(
                            height: 5,
                          ),
                          listViewComment()
                        ]))),
              ],
            ),
          ),
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

        if (result['data']['workflow']['transactions'][index]['assign'] == '' ||
            result['data']['workflow']['transactions'][index]['assign'] ==
                null) {
          if (widget.role == 'OFFICER' || widget.role == 'ADMIN') {
            return commentItem(
                temp,
                result['data']['workflow']['transactions'][index]['reporter'],
                '',
                '${result['data']['workflow']['transactions'][index]['signer']['comment']}',
                '${result['data']['workflow']['transactions'][index]['created_at']}',
                Colors.blue[200]);
          }
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
              color: blue_n_2,
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
                return Card(
                  child: Image.network(
                    img[index],
                    height: 170,
                    width: 100,
                  ),
                );
              },
            )),
        const SizedBox(
          height: 5,
        ),
        // ButtonApp.buttonOutline(context, 'เปิดกล้องถ่ายภาพ', () async {
        //   final ImagePicker _picker = ImagePicker();
        //   final XFile? photo =
        //       await _picker.pickImage(source: ImageSource.camera);
        //   File photofile = File(photo!.path);
        //   img.add(photofile);
        //   setState(() {});
        // }),
        // const SizedBox(
        //   height: 5,
        // ),
        Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            child: Edittext.edittextFormDisable('ปริมาณพลังงานไฟฟ้าที่ใช้',
                'kW-hr', powerElectricController, powerElectricValidate)),
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
}
