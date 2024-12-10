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
          '- ออกซิเจนละลายน้ำ (DISSOLVED OXGEN : DO) หมายถึง ปริมาณออกซิเจนที่ละลายอยู่ในน้ำ โดยออกซิเจนที่ละลายอยู่ในน้ำมีความสำคัญต่อสิ่งมีชีวิตที่อาศัยอยู่ในน้ำทั้งพืชและสัตว์\n   การตรวจวัดค่าออกซิเจนที่ละลายในน้ำ หมายถึง การหาปริมาณออกซิเจนซึ่งละลายอยู่ในน้ำเพื่อบ่งชี้คุณภาพของน้ำว่ามีความเหมาะสมเพียงใดต่อการดำรงชีวิตของสิ่งมีชีวิตในน้ำ\n\n- พีเอช (pH) เป็นค่าที่บอกถึงความเป็นกรดเป็นด่างของน้ำเสีย โดยทั่วไปสิ่งมีชีวิตในน้ำหรือจุลินทรีย์ในถังบำบัดจะดำรงชีพได้ดีในสภาะเป็นกลาง คือ pH ประมาณ 6-8\n\n- บีโอดี (Biochemical Oxygen Demand : BOD) เป็นค่าที่บอกถึงปริมาณออกซิเจนที่จุลินทรีย์ใช้ในการย่อยสลายสารอินทรีย์ ถ้าค่าบีโอดีสูงแสดงว่าความต้องการออกซิเจนสูง นั่นคือมีความสกปรกหรือสารอินทรีย์ในน้ำมาก\n\n- ซีโอดี (Chemical Oxygen Demand : COD) คือค่าปริมาณออกซิเจนที่ใช้ในการย่อยสารอินทรีย์ด้วยวิธีการทางเคมี มักใช้เทียบหาค่าบีโอดีโดยคร่าวๆ ปกติ COD:BOD ของน้ำเสียชุมชนประมาณ 2-4 เท่า\n\n- ปริมาณของแข็ง (Solids) หมายถึงปริมาณสารต่างๆ ที่มีอยู่ในน้ำเสีย ทั้งในลักษณะที่ไม่ละลายน้ำและที่ละลายน้ำ (Dissolved Solids) ของแข็งบางชนิดมีน้ำหนักเบาและแขวนลอยอยู่ในน้ำ (Suspended Solids) บางชนิดหนักและจมตัวลงเบื้องล่าง (Settleable Solids) ของแข็งที่ไม่ละลายน้ำนี้อาจสร้างปัญหาในการอุดตันเครื่องเติมอากาศ และถ้าปล่อยทิ้งในปริมาณมากจะทำให้เกิดความสกปรกและตื้นเขินในลำน้ำธรรมใชาติ ตลอดจนบดบังแสงแดดที่ส่องลงสู่ท้องน้ำ\n\n- ไนโตรเจน (Nitrogen) เป็นธาตุจำเป็นในการสร้างเซลล์ ของสิ่งมีชีวิต ไนโตรเจนจะเปลี่ยนสภาพเป็นแอมโมเนีย ถ้าหากในน้ำมีออกซิเจนพอเพียงก็จะถูกย่อยสลายไปเป็นไนไทรต์และไนเตรท ดังนั้นการปล่อยน้ำเสียที่มีสารประกอบไนโตรเจนสูงจึงทำให้ออกซิเจนที่มีอยู่ในลำน้ำลดน้อยลง\n\n- ไขมันและน้ำมัน (Fat, Oil, and Grease) ส่วนใหญ่ ได้แก่ น้ำมันและไขมันจากพืชและสัตว์ที่ใช้ในการทำอาหาร สบู่จากการอาบน้ำ ฟองสารซักฟอกจากการชำระล้าง สารเหล่านี้มีน้ำหนักเบาและลอยน้ำ ทำให้เกิดสภาพไม่น่าดูและขวางกั้นการซึมของอกอซิเจนจากอากาศสู่แหล่งน้ำ นอกจากนี้ยังมีค่าบีโอดีสูงเพราะเป็นสารอินทรีย์\n\n\nที่มา : ประกาศคณะกรรมการสิ่งแวดล้อมแห่งชาติ ฉบับที่ 8 (พ.ศ. 2537) เรื่อง กำหนดมาตรฐานคุณภาพน้ำในแหล่งน้ำผิวดิน'),
    );
  }
}
