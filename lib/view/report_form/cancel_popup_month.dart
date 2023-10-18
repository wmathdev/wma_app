// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/Color.dart';
import '../../api/OperatorRequest.dart';
import '../../widget/button_app.dart';
import '../../widget/dialog.dart';
import '../../widget/text_widget.dart';

class CancelPopupMonth extends StatefulWidget {
  String dateLabel;
  String documentId;
  CancelPopupMonth({
    Key? key,
    required this.dateLabel,
    required this.documentId,
  }) : super(key: key);

  @override
  State<CancelPopupMonth> createState() => _CancelPopupMonthState();
}

class _CancelPopupMonthState extends State<CancelPopupMonth> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var accessToken = '';

  @override
  Widget build(BuildContext context) {
   return Scaffold(
        body: SafeArea(
      child: Container(
        color: Colors.grey[60],
        child: Stack(
          children: [
            contentView(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                    height: 80,
                    child: ButtonApp.buttonSecondary(context, 'ปิดหน้าต่างนี้',
                        () {
                      Get.back();
                    })),
                SizedBox(
                    height: 40,
                    child: ButtonApp.buttonOutline(
                        context, 'ยกเลิกการส่งรายงาน', () async {
                      final SharedPreferences prefs = await _prefs;
                      accessToken = (prefs.getString('access_token') ?? '');
                     var result = await OperatorRequest.deleteDocument(
                          accessToken, widget.documentId);

                      if (result['code'] != '200') {
                        MyDialog.showAlertDialogOk(
                            context, '${result['message']}', () {
                          Get.back();
                        });
                      } else {
                        Get.back();
                        Get.back();
                      }
                    })),
                const SizedBox(
                  height: 30,
                )
              ]),
            )
          ],
        ),
      ),
    ));
  }

  Widget contentView() {
    print(widget.dateLabel);
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
                image: AssetImage('asset/images/iconcancel.png'),
              ),
            )),
            TextWidget.textBigWithColor(
                'คุณจะยกเลิกการส่งรายงานประจำเดือน ', Colors.black),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 TextWidget.textBigWithColor('ของวันที่', Colors.black),
                TextWidget.textBigWithColor(widget.dateLabel, blueSelected),
                TextWidget.textBigWithColor(' ใช่หรือไม่', Colors.black),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: greyBorder,
                    border: Border.all(
                      color: greyBorder,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: TextWidget.textTitle(
                    'ผู้บริหารจะไม่เห็นการส่งรายงานของคุณ')),
            // const SizedBox(
            //   height: 25,
            // ),
            //reportSummary(),
            const SizedBox(
              height: 50,
            ),
            //footer()
          ],
        ),
      )
    ]);
  }
}
