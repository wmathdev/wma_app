import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/text_widget.dart';

class VocabDetail extends StatefulWidget {
  const VocabDetail({super.key});

  @override
  State<VocabDetail> createState() => _VocabDetailState();
}

class _VocabDetailState extends State<VocabDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
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
              appbar(),
              header(),
              content(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset('asset/images/wave2.png',
                    fit: BoxFit.fitHeight),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget appbar() {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Image.asset('asset/images/arrow_left_n.png')),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
          ),
          // Image.asset('asset/images/baricon.png'),
        ],
      ),
    );
  }

  Widget header() {
    bool _customTileExpanded = false;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.17,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: Stack(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset('asset/images/detailbg.png',
                        fit: BoxFit.fitWidth)),
                Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Center(
                        child: TextWidget.textTitleBoldCenter('อ่านเพิ่มเติม'),
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget content() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: TextWidget.textGeneral(
          'มาตรฐานควบคุมการระบายน้ำทิ้งจากระบบบำบัดน้ำเสียรวมของชุมชน\n' 
           '1.	ความหมาย\n' +  
           '    o	ระบบบำบัดน้ำเสียรวมของชุมชน: ระบบบำบัดน้ำเสียที่จัดตั้งโดยหน่วยงานรัฐหรือผู้ให้บริการ เพื่อลดมลพิษจากน้ำเสียในชุมชน\n ' + 
           '    o	บ่อปรับเสถียร/บ่อผึ่ง: บ่อบำบัดน้ำเสียชีววิทยาที่ใช้เวลาเก็บกักน้ำเสียไม่น้อยกว่า 7 วัน\n' + 
           '2.	ค่ามาตรฐานน้ำทิ้ง\n' + 
           '    o	pH: ระหว่าง 5.5 - 9.0\n' + 
           '    o	บีโอดี (BOD): ไม่เกิน 20 มก./ลิตร (กรณีใช้บ่อปรับเสถียร ให้ใช้ค่าบีโอดีที่กรองแล้ว) \n' + 
           '    o	ของแข็งแขวนลอย (Suspended Solids): ไม่เกิน 30 มก./ลิตร (กรณีใช้บ่อปรับเสถียร ไม่เกิน 50 มก./ลิตร) \n'+
           '    o	น้ำมันและไขมัน: ไม่เกิน 5 มก./ลิตร\n' + 
           '    o	ไนโตรเจนทั้งหมด: ไม่เกิน 20 มก./ลิตร\n' + 
           '    o	ฟอสฟอรัสทั้งหมด: ไม่เกิน 2 มก./ลิตร\n' + 
           '3.	การตรวจสอบมาตรฐาน\n'+
           '    o	ให้ใช้วิธีตาม Standard Methods for the Examination of Water and Wastewater ฉบับล่าสุด หรือวิธีที่คณะกรรมการควบคุมมลพิษกำหนด\n' + 
           '4.	วิธีกรองตัวอย่างน้ำ\n' + 
           '    o	ใช้กระดาษกรองใยแก้ว (Glass Fiber Filter Disk) ก่อนวิเคราะห์หาค่าบีโอดี\n'+
           '5.	วันที่บังคับใช้\n'+
           '    o	มีผลตั้งแต่ 7 เมษายน 2553 (วันประกาศในราชกิจจานุเบกษา) \n' + ' \n' +
              'พระราชบัญญัติส่งเสริมและรักษาคุณภาพสิ่งแวดล้อมแห่งชาติ พ.ศ. 2535 กฎ ประกาศ และระเบียบที่เกี่ยวข้องด้านการควบคุมมลพิษ เรื่อง: กำหนดมาตรฐานคุณภาพน้ำในแหล่งน้ำผิวดิน\n'+
           '1.	แหล่งน้ำประเภทที่ 4\n'+
           '    o	แหล่งน้ำที่ได้รับน้ำทิ้งจากกิจกรรมบางประเภทและสามารถใช้ประโยชน์เพื่อ: \n'+
           '        1.	การอุปโภคและบริโภค (ต้องผ่านการฆ่าเชื้อโรคตามปกติและปรับปรุงคุณภาพน้ำเป็นพิเศษก่อน) \n'+
           '        2.	การอุตสาหกรรม\n'+
           '2.	คุณภาพน้ำในแหล่งน้ำประเภทที่ 4\n'+
           '    o	ค่าออกซิเจนละลาย (DO) ต้องไม่น้อยกว่า 2.0 มิลลิกรัม/ลิตร\n' + '\n' + 
              'อ้างอิงจาก มาตรฐานน้ำเสียชุมชน และมาตรฐานน้ำผิวดิน'),
    );
  }
}
