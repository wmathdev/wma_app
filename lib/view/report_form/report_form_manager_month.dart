// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wma_app/view/report_form/reject_popup_month.dart';

import '../../Utils/Color.dart';
import '../../Utils/month.dart';
import '../../api/ManagerRequest.dart';
import '../../model/user.dart';
import '../../widget/button_app.dart';
import '../../widget/edittext.dart';
import '../../widget/navigatebar.dart';
import '../../widget/text_widget.dart';
import '../report_home/progress_detail.dart';
import 'approve_popup_month.dart';

class ReportFormManagerMonth extends StatefulWidget {
  String role;
  dynamic document;
  Station station;
  String datelabel;

  ReportFormManagerMonth({
    Key? key,
    required this.role,
    required this.document,
    required this.station,
    required this.datelabel,
  }) : super(key: key);

  @override
  State<ReportFormManagerMonth> createState() => _ReportFormManagerMonthState();
}

class _ReportFormManagerMonthState extends State<ReportFormManagerMonth> {
  var powerElectricController = TextEditingController();
  var powerElectricValidate = false;
  var powerElectricValidateCb = false;

  var bodBeforeController = TextEditingController();
  var bodBeforeValidate = false;
  var bodBeforeValidateCb = false;
  var codBeforeController = TextEditingController();
  var codBeforeValidate = false;
  var codBeforeValidateCb = false;
  var ssBeforeController = TextEditingController();
  var ssBeforeValidate = false;
  var ssBeforeValidateCb = false;
  var fogBeforeController = TextEditingController();
  var fogBeforeValidate = false;
  var fogBeforeValidateCb = false;
  var totalNitrogenBeforeController = TextEditingController();
  var totalNitrogenBeforeValidate = false;
  var totalNitrogenBeforeValidateCb = false;
  var totalPhosphorusBeforeController = TextEditingController();
  var totalPhosphorusBeforeValidate = false;
  var totalPhosphorusBeforeValidateCb = false;
  var saltBeforeController = TextEditingController();
  var saltBeforeValidate = false;
  var saltBeforeValidateCb = false;
  var bodAfterController = TextEditingController();
  var bodAfterValidate = false;
  var bodAfterValidateCb = false;
  var codAfterController = TextEditingController();
  var codAfterValidate = false;
  var codAfterValidateCb = false;
  var ssAfterController = TextEditingController();
  var ssAfterValidate = false;
  var ssAfterValidateCb = false;
  var fogAfterController = TextEditingController();
  var fogAfterValidate = false;
  var fogAfterValidateCb = false;
  var totalNitrogenAfterController = TextEditingController();
  var totalNitrogenAfterValidate = false;
  var totalNitrogenAfterValidateCb = false;
  var totalPhosphorusAfterController = TextEditingController();
  var totalPhosphorusAfterValidate = false;
  var totalPhosphorusAfterValidateCb = false;
  var saltAfterController = TextEditingController();
  var saltAfterValidate = false;
  var saltAfterValidateCb = false;

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
              color: Colors.grey[60],
              child: contentView(),
            ),
    ));
  }

  Widget contentView() {
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
        ),
        Column(
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
              width: MediaQuery.of(context).size.width,
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
                    //notice(),
                    Container(
                        margin: const EdgeInsets.all(8),
                        child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                    width: MediaQuery.of(context).size.width,
                                    child: TextWidget.textTitleBold(
                                        'ข้อมูลคุณภาพน้ำประจำเดือน'),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(18, 0, 18, 0),
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
                                          color: yellow_n,
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
                                      context, 'ดูประวัติการส่งรายงานทั้งหมด',
                                      () {
                                    Get.to(ProgressDetail(
                                      result: result,
                                      dateLebal: Month.getMonthTitleReverse(
                                          result['data']['report_at']), station: widget.station,
                                    ));
                                  }),
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
                                  Edittext.edittextFormWithCheckbox(
                                      context,
                                      'BOD',
                                      'mg/I',
                                      bodBeforeController,
                                      bodBeforeValidate,
                                      bodBeforeValidateCb, (value) {
                                    setState(() {
                                      if (value != null) {
                                        bodBeforeValidateCb = value;
                                      }
                                    });
                                  }),
                                  Edittext.edittextFormWithCheckbox(
                                      context,
                                      'COD',
                                      'mg/I',
                                      codBeforeController,
                                      codBeforeValidate,
                                      codBeforeValidateCb, (value) {
                                    setState(() {
                                      if (value != null) {
                                        codBeforeValidateCb = value;
                                      }
                                    });
                                  }),
                                  Edittext.edittextFormWithCheckbox(
                                      context,
                                      'SS',
                                      'mg/I',
                                      ssBeforeController,
                                      ssBeforeValidate,
                                      ssBeforeValidateCb, (value) {
                                    setState(() {
                                      if (value != null) {
                                        ssBeforeValidateCb = value;
                                      }
                                    });
                                  }),
                                  Edittext.edittextFormWithCheckbox(
                                      context,
                                      'Fat, Oil and Grease',
                                      'mg/I',
                                      fogBeforeController,
                                      fogBeforeValidate,
                                      fogBeforeValidateCb, (value) {
                                    setState(() {
                                      if (value != null) {
                                        fogBeforeValidateCb = value;
                                      }
                                    });
                                  }),
                                  Edittext.edittextFormWithCheckbox(
                                      context,
                                      'Total Nitrogen',
                                      'mg/I',
                                      totalNitrogenBeforeController,
                                      totalNitrogenBeforeValidate,
                                      totalNitrogenBeforeValidateCb, (value) {
                                    setState(() {
                                      if (value != null) {
                                        totalNitrogenBeforeValidateCb = value;
                                      }
                                    });
                                  }),
                                  Edittext.edittextFormWithCheckbox(
                                      context,
                                      'Total Phosphorus',
                                      'mg/I',
                                      totalPhosphorusBeforeController,
                                      totalPhosphorusBeforeValidate,
                                      totalPhosphorusBeforeValidateCb, (value) {
                                    setState(() {
                                      if (value != null) {
                                        totalPhosphorusBeforeValidateCb = value;
                                      }
                                    });
                                  }),
                                  Edittext.edittextFormWithCheckbox(
                                      context,
                                      'ความเค็ม',
                                      'ppt.',
                                      saltBeforeController,
                                      saltBeforeValidate,
                                      saltBeforeValidateCb, (value) {
                                    setState(() {
                                      if (value != null) {
                                        saltBeforeValidateCb = value;
                                      }
                                    });
                                  }),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Container(height: 1, color: Colors.black),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  after(),
                                  Edittext.edittextFormWithCheckbox(
                                      context,
                                      'BOD',
                                      'mg/I',
                                      bodAfterController,
                                      bodAfterValidate,
                                      bodAfterValidateCb, (value) {
                                    setState(() {
                                      if (value != null) {
                                        bodAfterValidateCb = value;
                                      }
                                    });
                                  }),
                                  Edittext.edittextFormWithCheckbox(
                                      context,
                                      'COD',
                                      'mg/I',
                                      codAfterController,
                                      codAfterValidate,
                                      codAfterValidateCb, (value) {
                                    setState(() {
                                      if (value != null) {
                                        codAfterValidateCb = value;
                                      }
                                    });
                                  }),
                                  Edittext.edittextFormWithCheckbox(
                                      context,
                                      'SS',
                                      'mg/I',
                                      ssAfterController,
                                      ssAfterValidate,
                                      ssAfterValidateCb, (value) {
                                    setState(() {
                                      if (value != null) {
                                        ssAfterValidateCb = value;
                                      }
                                    });
                                  }),
                                  Edittext.edittextFormWithCheckbox(
                                      context,
                                      'Fat, Oil and Grease',
                                      'mg/I',
                                      fogAfterController,
                                      fogAfterValidate,
                                      fogAfterValidateCb, (value) {
                                    setState(() {
                                      if (value != null) {
                                        fogAfterValidateCb = value;
                                      }
                                    });
                                  }),
                                  Edittext.edittextFormWithCheckbox(
                                      context,
                                      'Total Nitrogen',
                                      'mg/I',
                                      totalNitrogenAfterController,
                                      totalNitrogenAfterValidate,
                                      totalNitrogenAfterValidateCb, (value) {
                                    setState(() {
                                      if (value != null) {
                                        totalNitrogenAfterValidateCb = value;
                                      }
                                    });
                                  }),
                                  Edittext.edittextFormWithCheckbox(
                                      context,
                                      'Total Phosphorus',
                                      'mg/I',
                                      totalPhosphorusAfterController,
                                      totalPhosphorusAfterValidate,
                                      totalPhosphorusAfterValidateCb, (value) {
                                    setState(() {
                                      if (value != null) {
                                        totalPhosphorusAfterValidateCb = value;
                                      }
                                    });
                                  }),
                                  Edittext.edittextFormWithCheckbox(
                                      context,
                                      'ความเค็ม',
                                      'ppt.',
                                      saltAfterController,
                                      saltAfterValidate,
                                      saltAfterValidateCb, (value) {
                                    setState(() {
                                      if (value != null) {
                                        saltAfterValidateCb = value;
                                      }
                                    });
                                  }),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Container(height: 1, color: Colors.black),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  listViewComment(),
                                  checkBox(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ButtonApp.buttonSecondaryHalf(
                                        context,
                                        'ตีกลับ',
                                        () async {
                                          final SharedPreferences prefs =
                                              await _prefs;
                                          String? authorization =
                                              prefs.getString('access_token');

                                          Get.to(RejectPopupMonth(
                                              role: widget.role,
                                              station: widget.station,
                                              dateLabel: widget.datelabel,
                                              authorization: authorization!,
                                              type: 'MONTHLY',
                                              documentId:
                                                  '${widget.document['id']}',
                                              bod: bodBeforeController.text,
                                              cod: codBeforeController.text,
                                              electric_unit:
                                                  powerElectricController.text,
                                              fog: fogBeforeController.text,
                                              salt: saltBeforeController.text,
                                              ss: ssBeforeController.text,
                                              totalNitrogen:
                                                  totalNitrogenBeforeController
                                                      .text,
                                              totalPhosphorous:
                                                  totalPhosphorusBeforeController
                                                      .text,
                                              treated_bod:
                                                  bodAfterController.text,
                                              treated_cod:
                                                  codAfterController.text,
                                              treated_fog:
                                                  fogAfterController.text,
                                              treated_salt:
                                                  saltAfterController.text,
                                              treated_ss:
                                                  ssAfterController.text,
                                              treated_total_nitrogen:
                                                  totalNitrogenAfterController
                                                      .text,
                                              treated_total_phosphorous:
                                                  totalPhosphorusAfterController
                                                      .text,
                                              img: img));
                                        },
                                      ),
                                      ButtonApp.buttonMainhalf(
                                          context, 'ส่งรายงาน', () async {
                                        if (checkValidate()) {
                                          final SharedPreferences prefs =
                                              await _prefs;
                                          String? authorization =
                                              prefs.getString('access_token');

                                          List<String> dataImg = [];
                                          for (var i = 0; i < img.length; i++) {
                                            if (img[i]['type'] == 'file') {
                                              String temp = convertIntoBase64(
                                                  img[i]['value']);
                                              dataImg.add(temp);
                                            }
                                          }

                                          Get.to(ApprovePopupMonth(
                                            role: widget.role,
                                            station: widget.station,
                                            dateLabel:
                                                Month.getMonthTitleReverse(
                                                    widget.datelabel),
                                            authorization: authorization!,
                                            type: 'MONTHLY',
                                            documentId:
                                                '${widget.document['id']}',
                                            bod: bodBeforeController.text,
                                            cod: codBeforeController.text,
                                            electric_unit:
                                                powerElectricController.text,
                                            file: dataImg,
                                            fog: fogBeforeController.text,
                                            salt: saltBeforeController.text,
                                            ss: ssBeforeController.text,
                                            totalNitrogen:
                                                totalNitrogenBeforeController
                                                    .text,
                                            totalPhosphorous:
                                                totalPhosphorusBeforeController
                                                    .text,
                                            treated_bod:
                                                bodAfterController.text,
                                            treated_cod:
                                                codAfterController.text,
                                            treated_fog:
                                                fogAfterController.text,
                                            treated_salt:
                                                saltAfterController.text,
                                            treated_ss: ssAfterController.text,
                                            treated_total_nitrogen:
                                                totalNitrogenAfterController
                                                    .text,
                                            treated_total_phosphorous:
                                                totalPhosphorusAfterController
                                                    .text,
                                            mediaDelete: delete,
                                          ));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                "กรุณาตรวจสอบข้อมูลให้ครบทุกช่อง"),
                                          ));
                                        }
                                      }, isCheckBox),
                                    ],
                                  )
                                ])))),

                    // ButtonApp.buttonMain(context, 'ยืนยัน', () async {
                    //   final SharedPreferences prefs = await _prefs;
                    //   String? authorization = prefs.getString('access_token');

                    //   List<String> dataImg = [];
                    //   for (var i = 0; i < img.length; i++) {
                    //     if (img[i]['type'] == 'file') {
                    //       String temp = convertIntoBase64(img[i]['value']);
                    //       dataImg.add(temp);
                    //     }
                    //   }

                    //   Get.to(ApprovePopupMonth(
                    //     role: widget.role,
                    //     station: widget.station,
                    //     dateLabel: Month.getMonthTitleReverse(widget.datelabel),
                    //     authorization: authorization!,
                    //     type: 'MONTHLY',
                    //     documentId: '${widget.document['id']}',
                    //     bod: bodBeforeController.text,
                    //     cod: codBeforeController.text,
                    //     electric_unit: powerElectricController.text,
                    //     file: dataImg,
                    //     fog: fogBeforeController.text,
                    //     salt: saltBeforeController.text,
                    //     ss: ssBeforeController.text,
                    //     totalNitrogen: totalNitrogenBeforeController.text,
                    //     totalPhosphorous: totalPhosphorusBeforeController.text,
                    //     treated_bod: bodAfterController.text,
                    //     treated_cod: codAfterController.text,
                    //     treated_fog: fogAfterController.text,
                    //     treated_salt: saltAfterController.text,
                    //     treated_ss: ssAfterController.text,
                    //     treated_total_nitrogen:
                    //         totalNitrogenAfterController.text,
                    //     treated_total_phosphorous:
                    //         totalPhosphorusAfterController.text,
                    //     mediaDelete: delete,
                    //   ));
                    // }, isCheckBox),
                    // ButtonApp.buttonSecondaryWithColor(context, 'ตีกลับ',
                    //     () async {
                    //   final SharedPreferences prefs = await _prefs;
                    //   String? authorization = prefs.getString('access_token');

                    //   Get.to(RejectPopupMonth(
                    //     role: widget.role,
                    //     station: widget.station,
                    //     dateLabel: widget.datelabel,
                    //     authorization: authorization!,
                    //     type: 'MONTHLY',
                    //     documentId: '${widget.document['id']}',
                    //     bod: bodBeforeController.text,
                    //     cod: codBeforeController.text,
                    //     electric_unit: powerElectricController.text,
                    //     fog: fogBeforeController.text,
                    //     salt: saltBeforeController.text,
                    //     ss: ssBeforeController.text,
                    //     totalNitrogen: totalNitrogenBeforeController.text,
                    //     totalPhosphorous: totalPhosphorusBeforeController.text,
                    //     treated_bod: bodAfterController.text,
                    //     treated_cod: codAfterController.text,
                    //     treated_fog: fogAfterController.text,
                    //     treated_salt: saltAfterController.text,
                    //     treated_ss: ssAfterController.text,
                    //     treated_total_nitrogen:
                    //         totalNitrogenAfterController.text,
                    //     treated_total_phosphorous:
                    //         totalPhosphorusAfterController.text,
                    //   ));
                    //   // }
                    // }, Colors.red)
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool checkValidate() {
    if (powerElectricValidateCb == false) {
      return false;
    }

    if (bodBeforeValidateCb == false) {
      return false;
    }

    if (codBeforeValidateCb == false) {
      return false;
    }
    if (ssBeforeValidateCb == false) {
      return false;
    }

    if (fogBeforeValidateCb == false) {
      return false;
    }

    if (totalNitrogenBeforeValidateCb == false) {
      return false;
    }

    if (totalPhosphorusBeforeValidateCb == false) {
      return false;
    }

    if (saltBeforeValidateCb == false) {
      return false;
    }

    if (bodAfterValidateCb == false) {
      return false;
    }

    if (codAfterValidateCb == false) {
      return false;
    }

    if (ssAfterValidateCb == false) {
      return false;
    }

    if (fogAfterValidateCb == false) {
      return false;
    }

    if (totalNitrogenAfterValidateCb == false) {
      return false;
    }

    if (totalPhosphorusAfterValidateCb == false) {
      return false;
    }

    if (saltAfterValidateCb == false) {
      return false;
    }

    return true;
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
                        'ผู้จัดการ โปรดตรวจสอบก่อนเวลา 10.00 น.', Colors.red)),
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
        //               child: img[index]['type'] == 'url'
        //                   ? Image.network(
        //                       img[index]['value'],
        //                       height: 170,
        //                       width: 100,
        //                     )
        //                   : Image.file(
        //                       img[index]['value'],
        //                       height: 170,
        //                       width: 100,
        //                     ),
        //             ),
        //             GestureDetector(
        //               onTap: () {
        //                 delete.add(img[index]['uuid']);
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
        //   final XFile? photo =
        //       await _picker.pickImage(source: ImageSource.camera,  imageQuality: 80,);
        //   File photofile = File(photo!.path);
        //   img.add({'type': 'file', 'value': photofile, 'uuid': ''});
        //   setState(() {});
        // }),
        const SizedBox(
          height: 5,
        ),
        Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            child: Edittext.edittextFormWithCheckbox(
                context,
                'ปริมาณพลังงานไฟฟ้าที่ใช้',
                'kW-hr',
                powerElectricController,
                powerElectricValidate,
                powerElectricValidateCb, (value) {
              setState(() {
                if (value != null) {
                  powerElectricValidateCb = value;
                }
              });
            })),
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
