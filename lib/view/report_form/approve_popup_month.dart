// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:wma_app/Utils/label.dart';

import 'package:wma_app/view/report_list/report_list_month_view.dart';

import '../../Utils/Color.dart';
import '../../api/ManagerRequest.dart';
import '../../api/MediaRequest.dart';
import '../../api/OfficerRequest.dart';
import '../../model/user.dart';
import '../../widget/button_app.dart';
import '../../widget/dialog.dart';
import '../../widget/edittext.dart';
import '../../widget/text_widget.dart';

class ApprovePopupMonth extends StatefulWidget {
  String dateLabel;
  String authorization;
  String bod;
  String cod;
  String ss;
  String fog;
  String totalNitrogen;
  String totalPhosphorous;
  String salt;

  String treated_bod;
  String treated_cod;
  String treated_ss;
  String treated_fog;
  String treated_total_nitrogen;
  String treated_total_phosphorous;
  String treated_salt;

  String electric_unit;
  String type;
  String role;
  Station station;
  String documentId;

  List<String> file;
  List<String> mediaDelete;
  ApprovePopupMonth(
      {Key? key,
      required this.dateLabel,
      required this.authorization,
      required this.bod,
      required this.cod,
      required this.ss,
      required this.fog,
      required this.totalNitrogen,
      required this.totalPhosphorous,
      required this.salt,
      required this.treated_bod,
      required this.treated_cod,
      required this.treated_ss,
      required this.treated_fog,
      required this.treated_total_nitrogen,
      required this.treated_total_phosphorous,
      required this.treated_salt,
      required this.electric_unit,
      required this.type,
      required this.role,
      required this.station,
      required this.documentId,
      required this.file,
      required this.mediaDelete})
      : super(key: key);

  @override
  State<ApprovePopupMonth> createState() => _ApprovePopupMonthState();
}

class _ApprovePopupMonthState extends State<ApprovePopupMonth> {
  TextEditingController commentController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            color: Colors.grey[60],
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
                : contentView(),
          ),
        ));
  }

  Widget contentView() {
    return Stack(children: [
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const ImageIcon(
                        AssetImage('asset/images/arrow_left_n.png'))),
                Row(
                  children: [TextWidget.textTitle('รายงานคุณภาพน้ำประจำวัน')],
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.87,
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
                  Column(children: [
                    Container(
                        margin: const EdgeInsets.all(8),
                        child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                   Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextWidget.textTitleBold(
                                      'ข้อมูลคุณภาพน้ำ'),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextWidget.textTitle(
                                    'ประจำวันที่ ${widget.dateLabel}',
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
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    TextWidget.textTitleBoldWithColor('ตรวจสอบความถูกต้องของข้อมูล',Colors.red),
                                  ],
                                ),
                                  reportSummary(),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  footer(),
                                ])))),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                    )
                  ]),
                ],
              ),
            ),
          ),
        ],
      )
    ]);
  }

  Widget reportSummary() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          // decoration: BoxDecoration(
          //     border: Border.all(color: Colors.grey),
          //     borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget.textTitleBold('ปริมาณพลังงานไฟฟ้าที่ใช้'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget.textTitle('${Label.commaFormat(widget.electric_unit)} kW-hr')
                  ],
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Container(height: 1, color: Colors.black),
              const SizedBox(
                height: 5,
              ),
              before(),
              Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget.textTitleBold('ค่า BOD     '),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle(widget.bod),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle('mg/l')
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget.textTitleBold('ค่า COD     '),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle(widget.cod),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle('mg/l')
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget.textTitleBold('ค่า SS      '),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle(widget.ss),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle('mg/l')
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget.textTitleBold('ค่า Fat, Oil and Grease'),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle(widget.fog),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle('mg/l')
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget.textTitleBold('ค่า Total Nitrogen'),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle(widget.totalNitrogen),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle('mg/l')
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget.textTitleBold('ค่า Total Phosphorus'),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle(widget.totalPhosphorous),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle('mg/l')
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget.textTitleBold('ค่าความเค็ม'),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle(widget.salt),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle('.ppt')
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ]),
              Container(height: 1, color: Colors.black),
              after(),
              Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget.textTitleBold('ค่า BOD     '),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle(widget.treated_bod),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle('mg/l')
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget.textTitleBold('ค่า COD     '),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle(widget.treated_cod),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle('mg/l')
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget.textTitleBold('ค่า SS      '),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle(widget.treated_ss),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle('mg/l')
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget.textTitleBold('ค่า Fat, Oil and Grease'),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle(widget.treated_fog),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle('mg/l')
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget.textTitleBold('ค่า Total Nitrogen'),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle(widget.treated_total_nitrogen),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle('mg/l')
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget.textTitleBold('ค่า Total Phosphorus'),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle(widget.treated_total_phosphorous),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle('mg/l')
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget.textTitleBold('ค่าความเค็ม'),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle(widget.treated_salt),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget.textTitle('.ppt')
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ]),
            ],
          ),
        ),

        // Row(
        //   children: [
        //     const SizedBox(
        //       width: 20,
        //     ),
        //     Container(
        //       decoration: BoxDecoration(
        //           color: greyBG,
        //           borderRadius: const BorderRadius.all(Radius.circular(5))),
        //       child: const ImageIcon(
        //           AssetImage('asset/images/bi_clipboard-check.png')),
        //     ),
        //     const SizedBox(
        //       width: 10,
        //     ),
        //     TextWidget.textSubTitleWithSize('สรุปรายงาน', 18),
        //   ],
        // ),
        // Container(
        //   margin: EdgeInsets.all(10),
        //   decoration: BoxDecoration(
        //       border: Border.all(color: Colors.grey),
        //       borderRadius: const BorderRadius.all(Radius.circular(10))),
        //   child: Column(
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        //         child: Row(
        //           mainAxisSize: MainAxisSize.max,
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('ปริมาณพลังงานไฟฟ้าที่ใช้'),
        //           ],
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //         child: Row(
        //           mainAxisSize: MainAxisSize.max,
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textSubTitleBold('${widget.electric_unit} kW-hr')
        //           ],
        //         ),
        //       ),
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         padding: EdgeInsets.all(15),
        //         color: greyBG,
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             TextWidget.textTitle('คุณภาพน้ำ'),
        //             TextWidget.textTitleBold('ก่อน'),
        //             TextWidget.textTitle('การบำบัด')
        //           ],
        //         ),
        //       ),
        //     ),
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         padding: EdgeInsets.all(15),
        //         color: blueButtonBorder,
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             TextWidget.textTitle('คุณภาพน้ำ'),
        //             TextWidget.textTitleBold('หลัง'),
        //             TextWidget.textTitle('การบำบัด')
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             right: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('BOD'),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             left: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('BOD'),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             right: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('${widget.bod} mg/I'),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             left: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitleBoldWithColor(
        //                 '${widget.treated_bod} mg/I', greenValue),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             right: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('COD'),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             left: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('COD'),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             right: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('${widget.cod} mg/I'),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             left: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitleBoldWithColor(
        //                 '${widget.treated_cod} mg/I', greenValue),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             right: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('SS'),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             left: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('SS'),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             right: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('${widget.ss} mg/I'),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             left: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitleBoldWithColor(
        //                 '${widget.treated_ss} mg/I', greenValue),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             right: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('Fat, Oil and Grease'),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             left: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('Fat, Oil and Grease'),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             right: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('${widget.fog} mg/I'),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             left: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitleBoldWithColor(
        //                 '${widget.treated_fog} mg/I', greenValue),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             right: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('Total Nitrogen'),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             left: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('Total Nitrogen'),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             right: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('${widget.totalNitrogen} mg/I'),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             left: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitleBoldWithColor(
        //                 '${widget.treated_total_nitrogen} mg/I',
        //                 greenValue),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             right: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('Total Phosphorus'),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             left: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('Total Phosphorus'),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             right: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle(
        //                 '${widget.totalPhosphorous} mg/I'),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             left: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitleBoldWithColor(
        //                 '${widget.treated_total_phosphorous} mg/I',
        //                 greenValue),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             right: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('ความเค็ม'),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             left: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('ความเค็ม'),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             right: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitle('${widget.salt} ppt.'),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Flexible(
        //       flex: 1,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //           border: Border(
        //             left: BorderSide(
        //                 width: 1.0,
        //                 color: Color.fromARGB(255, 210, 210, 210)),
        //           ),
        //         ),
        //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             TextWidget.textTitleBoldWithColor(
        //                 '${widget.treated_salt} ppt.', greenValue),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        //       const SizedBox(
        //         height: 10,
        //       ),
        //     ],
        //   ),
        // ),
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
                widget.role == 'OFFICER'
                    ? TextWidget.textTitleBold('')
                    : TextWidget.textTitleBold('จาก: '),
                widget.role == 'OFFICER'
                    ? TextWidget.textTitle('โน้ตหมายเหตุ')
                    : TextWidget.textTitle('ผู้จัดการ'),
              ],
            ),
            Row(
              children: [
                widget.role == 'OFFICER'
                    ? TextWidget.textTitle('')
                    : TextWidget.textTitleBold('ถึง: '),
                widget.role == 'OFFICER'
                    ? TextWidget.textTitle(
                        'เห็นเฉพาะเจ้าหน้าที่ส่วนกลางและแอดมิน')
                    : TextWidget.textTitle('เจ้าหน้าที่ส่วนกลาง'),
              ],
            ),
          ]),
        ),
        // Container(
        //     margin: const EdgeInsets.all(10),
        //     decoration: BoxDecoration(
        //         border: Border.all(color: Colors.grey),
        //         borderRadius: const BorderRadius.all(Radius.circular(5))),
        //     child: const Padding(
        //       padding: EdgeInsets.all(8.0),
        //       child: TextField(
        //         controller: TextEditingController(),
        //         maxLines: 5, //or null
        //         decoration: InputDecoration.collapsed(
        //             hintText: "ข้อความเพิ่มเติม . . . "),
        //       ),
        //     )),
        Edittext.edittextAreaForm('', '', commentController, false),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextWidget.textTitleBoldWithColor('', blueSelected),
              TextWidget.textTitle('${widget.dateLabel}')
            ],
          ),
        )
      ],
    );
  }

  Widget footer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonApp.buttonSecondaryHalf(
          context,
          'ยกเลิก',
          () {
            Get.back();
          },
        ),
        ButtonApp.buttonMainhalf(context, 'ยืนยัน', () async {
          setState(() {
            loading = true;
          });

          var result;

          if (widget.role == 'OFFICER') {
            result = await OfficerRequest.approval(widget.authorization,
                widget.documentId, 'APPROVE', commentController.text);
          } else {
            var today = DateTime.now();
            final outputFormat = DateFormat('yyyy-MM-dd');

            var outputDate = outputFormat.format(today);

            for (var i = 0; i < widget.mediaDelete.length; i++) {
              var result = await MediaRequest.delete(
                  widget.authorization, widget.mediaDelete[i]);
              if (result['code'] != '200') {
                MyDialog.showAlertDialogOk(context, '${result['message']}', () {
                  Get.back();
                });
              }
            }

            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.low);

            result = await ManagerRequest.revisionMonthlyDocument(
                widget.authorization,
                widget.station.id,
                widget.documentId,
                widget.bod,
                widget.cod,
                widget.ss,
                widget.fog,
                widget.totalNitrogen,
                widget.totalPhosphorous,
                widget.salt,
                widget.treated_bod,
                widget.treated_cod,
                widget.treated_ss,
                widget.treated_fog,
                widget.treated_total_nitrogen,
                widget.treated_total_phosphorous,
                widget.treated_salt,
                widget.electric_unit,
                widget.file,
                outputDate,
                widget.type,
                commentController.text,
                '${position.latitude},${position.longitude}');
          }

          if (result['code'] != '200') {
            // ignore: use_build_context_synchronously
            MyDialog.showAlertDialogOk(context, '${result['message']}', () {
              setState(() {
                loading = false;
              });
              Get.back();
            });
          } else {
            Get.back();
            Get.back();
            Get.back();
            Get.to(ReportListMonthView(
              station: widget.station,
              role: widget.role,
            ));
          }
        }, true),
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
