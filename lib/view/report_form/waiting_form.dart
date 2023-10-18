// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/Color.dart';
import '../../widget/text_widget.dart';

class WaitingForm extends StatefulWidget {
  String dateLabel;
  String documentId;
  WaitingForm({
    Key? key,
    required this.dateLabel,
    required this.documentId,
  }) : super(key: key);

  @override
  State<WaitingForm> createState() => _WaitingFormState();
}

class _WaitingFormState extends State<WaitingForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        color: Colors.grey[60],
        child: Stack(
          children: [
            contentView(),
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
                image: AssetImage('asset/images/rejecticon.png'),
              ),
            )),
            TextWidget.textBigWithColor(
                'เจ้าหน้าที่ ได้ยกเลิกการส่งรายงานของวันที่', Colors.black),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget.textBigWithColor(widget.dateLabel, blueSelected),
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
                    'ดังนั้นขั้นตอนต่อไปคือ รอผู้เจ้าหน้าที่ดำเนินการ อีกครั้ง')),
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
