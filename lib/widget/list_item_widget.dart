import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:wma_app/Utils/Color.dart';
import 'package:wma_app/Utils/label.dart';
import 'package:wma_app/Utils/month.dart';
import 'package:wma_app/api/Authentication.dart';
import 'package:wma_app/api/ReportDownloadRequest.dart';
import 'package:wma_app/view/maintainance/type_eq_list.dart';
import 'package:wma_app/view/notification/notificationDetail.dart';
import 'package:wma_app/view/report_download/report_download_list.dart';
import 'package:wma_app/view/report_home/station_officer_menu.dart';
import 'package:wma_app/view/scada/scada.dart';
import 'package:wma_app/view/scada/station_scada.dart';
import 'package:wma_app/widget/text_widget.dart';

import '../Utils/time.dart';
import '../model/user.dart';
import '../view/news/news_detail.dart';
import '../view/report_list/report_list_month_view.dart';
import '../view/report_list/report_list_view.dart';
import '../view/report_list/station_list_month_view.dart';
import '../view/report_list/station_list_view.dart';
import 'button_app.dart';

class ListItemWidget {
  //Menu
  static Widget cardListDay(String date, String time, BuildContext context,
      Station station, String role, String authorization) {
    return GestureDetector(
      onTap: () async {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low);

        await Authentication.checkin(
            authorization, '${position.latitude},${position.longitude}');
        Get.to(ReportList(
          station: station,
          role: role,
        ));
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      flex: 8,
                      child: Column(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child:
                                  TextWidget.textTitleBold('รายงานประจำวัน')),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextWidget.textSubTitleWithSize(
                                'ส่งรายงานประจำวันและและดูประวัติรายงานเพิ่มเติม',
                                10),
                          )
                        ],
                      )),
                  Expanded(
                      flex: 2,
                      child: IconButton(
                        iconSize: 100,
                        icon: Image.asset(
                          'asset/images/arrow_n.png',
                        ),
                        onPressed: () async {
                          Position position =
                              await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.low);
                          await Authentication.checkin(authorization,
                              '${position.latitude},${position.longitude}');
                          Get.to(ReportList(
                            station: station,
                            role: role,
                          ));
                        },
                      )),
                ],
              ),
              role == 'OPERATOR'
                  ? Container(
                      margin: const EdgeInsets.all(8),
                      child: Card(
                          color: red_n,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                // IconButton(
                                //   icon: Image.asset(
                                //     'asset/images/notice_card.png',
                                //   ),
                                //   onPressed: () async {
                                //     Position position =
                                //         await Geolocator.getCurrentPosition(
                                //             desiredAccuracy:
                                //                 LocationAccuracy.low);
                                //     await Authentication.checkin(authorization,
                                //         '${position.latitude},${position.longitude}');
                                //     Get.to(ReportList(
                                //       station: station,
                                //       role: role,
                                //     ));
                                //   },
                                // ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextWidget.textSubTitleWithSizeColor(
                                      'กรุณารายงานคุณภาพน้ำ\nประจำวันที่ $date ก่อนเวลา $time น.',
                                      13,
                                      Colors.white),
                                )),
                              ],
                            ),
                          )),
                    )
                  : Container(
                      margin: const EdgeInsets.all(8),
                      child: Card(
                          color: red_n,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextWidget.textSubTitleWithSizeColor(
                                      'กรุณาตรวจสอบรายงานคุณภาพน้ำ\nประจำวันที่ $date ก่อนเวลา $time น.',
                                      13,
                                      Colors.white),
                                )),
                              ],
                            ),
                          )),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget cardListDayOfficer(String date, String time,
      BuildContext context, String role, String authorization) {
    return GestureDetector(
      onTap: () async {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low);
        await Authentication.checkin(
            authorization, '${position.latitude},${position.longitude}');
        Get.to(StationList(
          role: role,
        ));
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 8,
                    child: Column(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextWidget.textTitleBold('รายงานประจำวัน')),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextWidget.textSubTitleWithSize(
                              'ส่งรายงานประจำวันและและดูประวัติรายงานเพิ่มเติม',
                              10),
                        )
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: IconButton(
                      iconSize: 100,
                      icon: Image.asset(
                        'asset/images/arrow_n.png',
                      ),
                      onPressed: () async {
                        Position position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.low);
                        await Authentication.checkin(authorization,
                            '${position.latitude},${position.longitude}');
                        Get.to(StationList(
                          role: role,
                        ));
                      },
                    )),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: Card(
                  color: yellow_n,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextWidget.textSubTitleWithSizeColor(
                              'กรุณาตรวจสอบรายงานคุณภาพน้ำ\nประจำวันที่ $date ก่อนเวลา $time น.',
                              13,
                              Colors.white),
                        )),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  static Widget cardListMonth(String date, String time, BuildContext context,
      Station station, String role, String authorization) {
    return GestureDetector(
      onTap: () async {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low);
        await Authentication.checkin(
            authorization, '${position.latitude},${position.longitude}');
        Get.to(ReportListMonthView(
          station: station,
          role: role,
        ));
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 8,
                      child: Column(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child:
                                  TextWidget.textTitleBold('รายงานประจำเดือน')),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextWidget.textSubTitleWithSize(
                                'ส่งรายงานประจำเดือนและและดูประวัติรายงานเพิ่มเติม',
                                13),
                          )
                        ],
                      )),
                  Expanded(
                      flex: 2,
                      child: IconButton(
                        iconSize: 100,
                        icon: Image.asset(
                          'asset/images/arrow_n.png',
                        ),
                        onPressed: () async {
                          Position position =
                              await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.low);
                          await Authentication.checkin(authorization,
                              '${position.latitude},${position.longitude}');
                          Get.to(ReportListMonthView(
                            station: station,
                            role: role,
                          ));
                        },
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget cardListMonthDownload(
      String date,
      String time,
      BuildContext context,
      Station station,
      String role,
      String authorization) {
    return GestureDetector(
      onTap: () async {
        Get.to(ReportDownloadList(
          station: station,
          role: role,
        ));
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 8,
                        child: Column(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: TextWidget.textTitleBold('ดาวน์โหลด')),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextWidget.textSubTitleWithSize(
                                  'ดาวน์โหลดรายงานประจำเดือน', 13),
                            )
                          ],
                        )),
                    Expanded(
                        flex: 2,
                        child: IconButton(
                          iconSize: 100,
                          icon: Image.asset(
                            'asset/images/arrow_n.png',
                          ),
                          onPressed: () async {
                            Get.to(ReportDownloadList(
                              station: station,
                              role: role,
                            ));
                          },
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget cardListMonthDownloadOfficer(String date, String time,
      BuildContext context, String role, String authorization) {
    return GestureDetector(
      onTap: () async {
        Get.to(StationOfficerMenu(
          menu: 'download',
          role: role,
          passphrases: [],
        ));
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 8,
                        child: Column(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: TextWidget.textTitleBold('ดาวน์โหลด')),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextWidget.textSubTitleWithSize(
                                  'ดาวน์โหลดรายงานประจำเดือน', 13),
                            )
                          ],
                        )),
                    Expanded(
                        flex: 2,
                        child: IconButton(
                          iconSize: 100,
                          icon: Image.asset(
                            'asset/images/arrow_n.png',
                          ),
                          onPressed: () async {
                            // Get.to(ReportDownloadList(
                            //   station: station,
                            //   role: role,
                            // ));
                          },
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget cardListMaintenance(
      String date,
      String time,
      BuildContext context,
      Station station,
      String role,
      String authorization) {
    return GestureDetector(
      onTap: () async {
        // Position position = await Geolocator.getCurrentPosition(
        //     desiredAccuracy: LocationAccuracy.low);
        // await Authentication.checkin(
        //     authorization, '${position.latitude},${position.longitude}');
        Get.to(TypeEqList(
          station: station,
          name: station.name,
          role: role,
        ));
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 8,
                        child: Column(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: TextWidget.textTitleBold(
                                    'การแจ้งเตือนเกณฑ์การบํารุงรักษา')),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextWidget.textSubTitleWithSize(
                                  'ส่งรายงานการบํารุงรักษา', 13),
                            )
                          ],
                        )),
                    Expanded(
                        flex: 2,
                        child: IconButton(
                            iconSize: 100,
                            icon: Image.asset(
                              'asset/images/arrow_n.png',
                            ),
                            onPressed: null)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget cardListMaintenanceOfficer(String date, String time,
      BuildContext context, String role, String authorization) {
    return GestureDetector(
      onTap: () async {
        Get.to(StationOfficerMenu(
          menu: 'maintenance',
          role: role,
          passphrases: [],
        ));
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 8,
                        child: Column(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: TextWidget.textTitleBold(
                                    'การแจ้งเตือนเกณฑ์การบํารุงรักษา')),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextWidget.textSubTitleWithSize(
                                  'ส่งรายงานการบํารุงรักษา', 13),
                            )
                          ],
                        )),
                    Expanded(
                        flex: 2,
                        child: IconButton(
                            iconSize: 100,
                            icon: Image.asset(
                              'asset/images/arrow_n.png',
                            ),
                            onPressed: null)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget cardListScada(BuildContext context, User user, String name,
      String url, String authorization) {
    return url != 'https://wma.or.th/home-eng'
        ? GestureDetector(
            onTap: () async {
              Get.to(ScadaPage(
                name: name,
                url: url,
              ));
            },
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 8,
                              child: Column(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: TextWidget.textTitleBold(
                                          'การเปิด - ปิดอุปกรณ์ระยะไกล')),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: TextWidget.textSubTitleWithSize(
                                        'การควบคุมการเปิด - ปิดอุปกรณ์ระยะไกล',
                                        13),
                                  )
                                ],
                              )),
                          Expanded(
                              flex: 2,
                              child: IconButton(
                                iconSize: 100,
                                icon: Image.asset(
                                  'asset/images/arrow_n.png',
                                ),
                                onPressed: null,
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  static Widget cardListScadaOfficer(BuildContext context, User user,
      String role, String authorization, List<dynamic> passphrases) {
    return GestureDetector(
      onTap: () async {
        Get.to(StationOfficerMenu(
          menu: 'scada',
          role: role,
          passphrases: passphrases,
        ));
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 8,
                        child: Column(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: TextWidget.textTitleBold(
                                    'การเปิด - ปิดอุปกรณ์ระยะไกล')),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextWidget.textSubTitleWithSize(
                                  'การควบคุมการเปิด - ปิดอุปกรณ์ระยะไกล', 13),
                            )
                          ],
                        )),
                    Expanded(
                        flex: 2,
                        child: IconButton(
                          iconSize: 100,
                          icon: Image.asset(
                            'asset/images/arrow_n.png',
                          ),
                          onPressed: null,
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget cardListMonthOfficer(String date, String time,
      BuildContext context, String role, String authorization) {
    return GestureDetector(
      onTap: () async {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low);
        await Authentication.checkin(
            authorization, '${position.latitude},${position.longitude}');
        Get.to(StationListMonth(
          role: role,
        ));
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 8,
                      child: Column(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child:
                                  TextWidget.textTitleBold('รายงานประจำเดือน')),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextWidget.textSubTitleWithSize(
                                'ส่งรายงานประจำเดือนและและดูประวัติรายงานเพิ่มเติม',
                                13),
                          )
                        ],
                      )),
                  Expanded(
                      flex: 2,
                      child: IconButton(
                        iconSize: 100,
                        icon: Image.asset(
                          'asset/images/arrow_n.png',
                        ),
                        onPressed: () async {
                          Position position =
                              await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.low);
                          await Authentication.checkin(authorization,
                              '${position.latitude},${position.longitude}');
                          Get.to(StationListMonth(
                            role: role,
                          ));
                        },
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //Telephone
  static Widget telephoneHeader(BuildContext context, String title, Color bg) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Colors.transparent,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: blue_navy_n,
          ),
        ),
      ),
    );
  }

  static Widget telephoneItem(BuildContext context, String title, Color bg,
      GestureTapCallback onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: bg,
            // border: Border.all(
            //   color: Colors.grey,
            // ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: 15,
                  height: 15,
                  child: Image.asset('asset/images/telephone.png')),
              const SizedBox(
                width: 20,
              ),
              TextWidget.textSubTitleWithSizeGradient2(title, 15, Colors.black)
              // GestureDetector(
              //   onTap: onClick,
              //   child: const Text(
              //     'โทร',
              //     style: TextStyle(
              //       fontSize: 14,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.blue,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  //reportlist
  static Widget reportListHeader(BuildContext context, String date,
      String fullDate, String time, String role, GestureTapCallback onClick) {
    if ((Time.checkTimeStatus('00:00AM', '10:00AM') && role == 'OPERATOR') ||
        role == 'ADMIN') {
      return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: blue_n,
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    height: MediaQuery.of(context).size.width * 0.15,
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Center(
                      child: Text(
                        date,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          TextWidget.textTitleBold('รายงานคุณภาพน้ำ'),
                        ],
                      ),
                      Row(
                        children: [
                          TextWidget.textTitle(role == 'ADMIN'
                              ? 'รายงานคุณภาพน้ำประจำวันที่ $fullDate'
                              : 'ประจำวันที่ $fullDate \nกรุณาส่งรายงานก่อนเวลา $time น.'),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    'asset/images/arrow_n.png',
                  ),
                ),
              ],
            ),
            //Divider(color: greyBorder),
            ButtonApp.buttonMain(context, 'ส่งรายงาน', onClick, true)
          ],
        ),
      );
    }

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.black87,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                height: MediaQuery.of(context).size.width * 0.20,
                width: MediaQuery.of(context).size.width * 0.20,
                child: Center(
                  child: Text(
                    date,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: TextWidget.textTitle(
                      'โปรดรายงานคุณภาพน้ำประจำวันที่ $fullDate ก่อนเวลา $time น.')),
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.red[50],
                border: Border.all(
                  color: Colors.transparent,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'asset/images/required.png',
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    role == 'OPERATOR'
                        ? 'รายการล่าช้า ติดต่อส่วนกลาง'
                        : 'รายการล่าช้า',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: greyBorder),
          ButtonApp.buttonSecondaryGradient(
              context, 'ดูข้อมูลการติดต่อ', onClick)
        ],
      ),
    );
  }

  static Widget reportListHeaderMonth(BuildContext context, String date,
      String fullDate, String time, String role, GestureTapCallback onClick) {
    if ((Time.checkTimeStatus('00:00AM', '10:00AM') && role == 'OPERATOR') ||
        role == 'ADMIN') {
      return Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: blue_n,
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  height: MediaQuery.of(context).size.width * 0.15,
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: Center(
                    child: Text(
                      date,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          TextWidget.textTitleBold('รายงานคุณภาพน้ำ'),
                        ],
                      ),
                      Row(
                        children: [
                          TextWidget.textTitle(role == 'ADMIN'
                              ? 'รายงานคุณภาพน้ำประจำวันที่ $fullDate'
                              : 'โปรดรายงานคุณภาพน้ำรายเดือน\nวันที่ $fullDate .'),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    'asset/images/arrow_n.png',
                  ),
                ),
              ],
            ),
            //Divider(color: greyBorder),
            ButtonApp.buttonMain(context, 'ส่งรายงาน', onClick, true)
          ],
        ),
      );
    }

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: blue_n,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                height: MediaQuery.of(context).size.width * 0.15,
                width: MediaQuery.of(context).size.width * 0.15,
                child: Center(
                  child: Text(
                    date,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: TextWidget.textTitle(
                      'โปรดรายงานคุณภาพน้ำประจำวันที่ $fullDate ก่อนเวลา $time น.'))
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.red[50],
                border: Border.all(
                  color: Colors.transparent,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'asset/images/required.png',
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    role == 'OPERATOR'
                        ? 'รายการล่าช้า ติดต่อส่วนกลาง'
                        : 'รายการล่าช้า',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: greyBorder),
          ButtonApp.buttonSecondaryGradient(
              context, 'ดูข้อมูลการติดต่อ', onClick)
        ],
      ),
    );
  }

  static Widget reportListHeaderManager(BuildContext context, String date,
      String fullDate, String time, String role, GestureTapCallback onClick) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        // side: BorderSide(
        //   color: greyBorder,
        // ),
        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: blue_n,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                height: MediaQuery.of(context).size.width * 0.15,
                width: MediaQuery.of(context).size.width * 0.15,
                child: Center(
                  child: Text(
                    date,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: TextWidget.textTitle(
                      'โปรดรายงานคุณภาพน้ำประจำวันที่ $fullDate ก่อนเวลา $time น.'))
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.transparent,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  role == 'MANAGER'
                      ? Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: red_n,
                          ),
                        )
                      : Image.asset(
                          'asset/images/yellowdot.png',
                        ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    role == 'MANAGER' || role == 'OFFICER'
                        ? 'รอเจ้าหน้าที่ดำเนินการ'
                        : 'รอผู้จัดการตรวจสอบ',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: greyBorder),
          ButtonApp.buttonSecondaryGradient(
              context, 'ดูข้อมูลการติดต่อ', onClick)
        ],
      ),
    );
  }

  static Widget reportListHeaderManagerMonth(BuildContext context, String date,
      String fullDate, String time, String role, GestureTapCallback onClick) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        // side: BorderSide(
        //   color: greyBorder,
        // ),
        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: blue_n,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                height: MediaQuery.of(context).size.width * 0.15,
                width: MediaQuery.of(context).size.width * 0.15,
                child: Center(
                  child: Text(
                    date,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: TextWidget.textTitle(
                      'รายงานคุณภาพน้ำประจำเดือน\nวันที่ $fullDate'))
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.transparent,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  role == 'MANAGER'
                      ? Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: red_n,
                          ),
                        )
                      : Image.asset(
                          'asset/images/yellowdot.png',
                        ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    role == 'MANAGER' || role == 'OFFICER'
                        ? 'รอเจ้าหน้าที่ดำเนินการ'
                        : 'รอผู้จัดการตรวจสอบ',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: greyBorder),
          ButtonApp.buttonSecondaryGradient(
              context, 'ดูข้อมูลการติดต่อ', onClick)
        ],
      ),
    );
  }

  static Widget reportListItem(BuildContext context, String date, String time,
      GestureTapCallback onPressed, dynamic data) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: blue_n,
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    height: MediaQuery.of(context).size.width * 0.15,
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Center(
                      child: Text(
                        date,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          TextWidget.textTitleBold(
                              'ปริมาณน้ำเสียที่ผ่านการบำบัด'),
                        ],
                      ),
                      Row(
                        children: [
                          TextWidget.textSubTitleWithSizeGradient(
                              '${Label.commaFormat('${data['treated_water']}')}',
                              20,
                              Colors.black),
                          SizedBox(
                            width: 10,
                          ),
                          TextWidget.textTitleBoldWithColorSize(
                              'ลบ.ม', Colors.black, 20),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    'asset/images/arrow_n.png',
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitleBold('ค่า DO')),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitle('${data['doo']} mg/I')),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'asset/images/arrowvalue.png',
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitle(
                              '${data['treated_doo']} mg/I')),
                    ]),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitleBold('ค่า pH')),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitle('${data['ph']}')),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'asset/images/arrowvalue.png',
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitle('${data['treated_ph']}')),
                    ]),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitleBold('ค่าอุณหภูมิ')),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitle('${data['temp']} °C')),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'asset/images/arrowvalue.png',
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitle(
                              '${data['treated_temp']} °C')),
                    ]),
              ],
            ),
            Status(context, data['workflow']['progress'],
                data['workflow']['label'], data['workflow']['state']),
            const SizedBox(
              height: 20,
            )
            // Divider(color: greyBorder),
            // // ButtonApp.buttonSecondaryGradient(
            // //     context, 'ดูรายละเอียดเพิ่มเติม', onPressed)
          ],
        ),
      ),
    );
  }

  static Widget reportListItemMonth(BuildContext context, String date,
      String time, GestureTapCallback onPressed, dynamic data) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: greyBorder,
        ),
        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                height: MediaQuery.of(context).size.width * 0.20,
                width: MediaQuery.of(context).size.width * 0.20,
                child: Center(
                  child: Text(
                    date,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              TextWidget.textTitle(Month.getMonthTitle(date))
            ],
          ),
          Status(context, data['workflow']['progress'],
              data['workflow']['label'], data['workflow']['state']),
          Divider(color: greyBorder),
          ButtonApp.buttonSecondary(context, 'ดูรายละเอียดเพิ่มเติม', onPressed)
        ],
      ),
    );
  }

  static Widget reportListItemToday(
      BuildContext context,
      String date,
      String time,
      GestureTapCallback onCancel,
      GestureTapCallback onPressed,
      dynamic data) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: blue_n,
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  height: MediaQuery.of(context).size.width * 0.15,
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: Center(
                    child: Text(
                      date,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextWidget.textTitleBold(
                            'ปริมาณน้ำเสียที่ผ่านการบำบัด'),
                      ],
                    ),
                    Row(
                      children: [
                        TextWidget.textSubTitleWithSizeGradient(
                            '${Label.commaFormat('${data['treated_water']}')}',
                            20,
                            Colors.black),
                        SizedBox(
                          width: 10,
                        ),
                        TextWidget.textTitleBoldWithColorSize(
                            'ลบ.ม', Colors.black, 20),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Image.asset(
                  'asset/images/arrow_n.png',
                ),
              ),
            ],
          ),
          Column(
            children: [
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child: TextWidget.textTitleBold('ค่า DO')),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child: TextWidget.textTitle('${data['doo']} mg/I')),
                    const SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      'asset/images/arrowvalue.png',
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child: TextWidget.textTitle(
                            '${data['treated_doo']} mg/I')),
                  ]),
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child: TextWidget.textTitleBold('ค่า pH')),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child: TextWidget.textTitle('${data['ph']}')),
                    const SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      'asset/images/arrowvalue.png',
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child: TextWidget.textTitle('${data['treated_ph']}')),
                  ]),
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child: TextWidget.textTitleBold('ค่าอุณหภูมิ')),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child: TextWidget.textTitle('${data['temp']} °C')),
                    const SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      'asset/images/arrowvalue.png',
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child:
                            TextWidget.textTitle('${data['treated_temp']} °C')),
                  ]),
            ],
          ),
          Status(context, data['workflow']['progress'],
              data['workflow']['label'], data['workflow']['state']),
         Time.checkTimeStatus('00:00AM', '10:00AM') ? Divider(color: greyBorder) : Container(),
          data['workflow']['state'] == 'REVISION'
              ? ButtonApp.buttonMain(context, 'แก้ไข', onPressed, true)
              : data['workflow']['state'] == 'COMPLETED' ||
                      data['workflow']['state'] == 'REVIEW' ||
                      data['workflow']['state'] == 'REVIEWING' ||
                      data['workflow']['state'] == 'RECHECK'
                  ? ButtonApp.buttonSecondaryGradient(
                      context, 'ดูรายละเอียด', onPressed)
                  : Time.checkTimeStatus('00:00AM', '10:00AM')
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonApp.buttonSecondaryFixCard(
                                context, 'ยกเลิกการส่ง', onCancel, true),
                            ButtonApp.buttonOutlineFixGradient(
                                context, 'แก้ไข', onPressed)
                          ],
                        )
                      : Container()
        ],
      ),
    );
  }

  static Widget reportListItemTodayMonth(
      BuildContext context,
      String date,
      String time,
      GestureTapCallback onCancel,
      GestureTapCallback onPressed,
      String fullDate,
      String role,
      dynamic data) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: greyBorder,
        ),
        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: blue_n,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                height: MediaQuery.of(context).size.width * 0.15,
                width: MediaQuery.of(context).size.width * 0.15,
                child: Center(
                  child: Text(
                    date,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextWidget.textTitleBold('รายงานคุณภาพน้ำ'),
                      ],
                    ),
                    Row(
                      children: [
                        TextWidget.textTitle(role == 'ADMIN'
                            ? 'รายงานคุณภาพน้ำประจำวันที่ $fullDate'
                            : 'รายงานคุณภาพน้ำรายเดือน\nวันที่ $fullDate .'),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Image.asset(
                  'asset/images/arrow_n.png',
                ),
              ),
            ],
          ),
          Status(context, data['workflow']['progress'],
              data['workflow']['label'], data['workflow']['state']),
          // Divider(color: greyBorder),
          data['workflow']['state'] == 'REVISION'
              ? ButtonApp.buttonMain(context, 'แก้ไข', onPressed, true)
              : data['workflow']['state'] == 'COMPLETED'
                  ? ButtonApp.buttonSecondaryGradient(
                      context, 'ดูรายละเอียด', onPressed)
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonApp.buttonSecondaryFixCard(
                            context, 'ยกเลิกการส่ง', onCancel, true),
                        ButtonApp.buttonOutlineFixGradient(
                            context, 'แก้ไข', onPressed)
                      ],
                    )
        ],
      ),
    );
  }

  static Widget reportListItemTodayManager(BuildContext context, String date,
      String time, GestureTapCallback onClick, dynamic data, onCancel) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: greyBorder,
        ),
        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: blue_n,
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  height: MediaQuery.of(context).size.width * 0.15,
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: Center(
                    child: Text(
                      date,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextWidget.textTitleBold(
                            'ปริมาณน้ำเสียที่ผ่านการบำบัด'),
                      ],
                    ),
                    Row(
                      children: [
                        TextWidget.textSubTitleWithSizeGradient(
                            '${Label.commaFormat('${data['treated_water']}')}',
                            20,
                            Colors.black),
                        SizedBox(
                          width: 10,
                        ),
                        TextWidget.textTitleBoldWithColorSize(
                            'ลบ.ม', Colors.black, 20),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Image.asset(
                  'asset/images/arrow_n.png',
                ),
              ),
            ],
          ),
          Column(
            children: [
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child: TextWidget.textTitleBold('ค่า DO')),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child: TextWidget.textTitle('${data['doo']} mg/I')),
                    const SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      'asset/images/arrowvalue.png',
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child: TextWidget.textTitle(
                            '${data['treated_doo']} mg/I')),
                  ]),
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child: TextWidget.textTitleBold('ค่า pH')),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child: TextWidget.textTitle('${data['ph']}')),
                    const SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      'asset/images/arrowvalue.png',
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child: TextWidget.textTitle('${data['treated_ph']}')),
                  ]),
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child: TextWidget.textTitleBold('ค่าอุณหภูมิ')),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child: TextWidget.textTitle('${data['temp']} °C')),
                    const SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      'asset/images/arrowvalue.png',
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child:
                            TextWidget.textTitle('${data['treated_temp']} °C')),
                  ]),
            ],
          ),
          Time.checkTimeStatus('00:00AM', '10:00AM')
              ? Status(context, data['workflow']['progress'],
                  data['workflow']['label'], data['workflow']['state'])
              : Container(
                  margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.red[50],
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'asset/images/required.png',
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'รายการล่าช้า ติดต่อส่วนกลาง',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          Divider(color: greyBorder),
          data['workflow']['state'] == 'REVIEW' ||
                  data['workflow']['state'] == 'REVIEWING' ||
                  data['workflow']['state'] == 'REVISION' ||
                  data['workflow']['state'] == 'COMPLETED' ||
                  !Time.checkTimeStatus('00:00AM', '10:00AM')
              ? ButtonApp.buttonSecondaryGradient(
                  context, 'ดูรายละเอียด', onClick)
              : ButtonApp.buttonMainGradient(context, 'ตรวจสอบ', onClick, true)
        ],
      ),
    );
  }

  static Widget reportListItemTodayManagerMonth(
      BuildContext context,
      String date,
      String time,
      GestureTapCallback onClick,
      dynamic data,
      String role,
      String fullDate,
      onCancel) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: greyBorder,
        ),
        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: blue_n,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                height: MediaQuery.of(context).size.width * 0.15,
                width: MediaQuery.of(context).size.width * 0.15,
                child: Center(
                  child: Text(
                    date,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextWidget.textTitleBold('รายงานคุณภาพน้ำ'),
                      ],
                    ),
                    Row(
                      children: [
                        TextWidget.textTitle(role == 'ADMIN'
                            ? 'รายงานคุณภาพน้ำประจำวันที่ $fullDate'
                            : 'รายงานคุณภาพน้ำรายเดือน\nวันที่ $fullDate .'),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Image.asset(
                  'asset/images/arrow_n.png',
                ),
              ),
            ],
          ),
          Status(context, data['workflow']['progress'],
              data['workflow']['label'], data['workflow']['state']),
          Divider(color: greyBorder),
          data['workflow']['state'] == 'REVIEW' ||
                  data['workflow']['state'] == 'COMPLETED' ||
                  data['workflow']['state'] == 'REVISION'
              ? ButtonApp.buttonSecondaryGradient(
                  context, 'ดูรายละเอียด', onClick)
              : ButtonApp.buttonMainGradient(context, 'ตรวจสอบ', onClick, true)
        ],
      ),
    );
  }

  static Widget reportListItemTodayOfficer(
      BuildContext context,
      String date,
      String time,
      GestureTapCallback onClick,
      dynamic data,
      onCancel,
      onChange,
      bool isSelect) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: greyBorder,
          ),
          borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: blue_n,
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    height: MediaQuery.of(context).size.width * 0.15,
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Center(
                      child: Text(
                        date,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          TextWidget.textTitleBold(
                              'ปริมาณน้ำเสียที่ผ่านการบำบัด'),
                        ],
                      ),
                      Row(
                        children: [
                          TextWidget.textSubTitleWithSizeGradient(
                              '${Label.commaFormat('${data['treated_water']}')}',
                              20,
                              Colors.black),
                          SizedBox(
                            width: 10,
                          ),
                          TextWidget.textTitleBoldWithColorSize(
                              'ลบ.ม', Colors.black, 20),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    'asset/images/arrow_n.png',
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitleBold('ค่า DO')),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitle('${data['doo']} mg/I')),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'asset/images/arrowvalue.png',
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitle(
                              '${data['treated_doo']} mg/I')),
                    ]),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitleBold('ค่า pH')),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitle('${data['ph']}')),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'asset/images/arrowvalue.png',
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child:
                              TextWidget.textTitle('${data['treated_ph']} ')),
                    ]),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitleBold('ค่าอุณหภูมิ')),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitle('${data['temp']} °C')),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'asset/images/arrowvalue.png',
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitle(
                              '${data['treated_temp']} °C')),
                    ]),
              ],
            ),
            Status(context, data['workflow']['progress'],
                data['workflow']['label'], data['workflow']['state']),
            data['workflow']['state'] == 'REVIEW' ||
                    data['workflow']['state'] == 'REVIEWING'
                ? ListTileTheme(
                    horizontalTitleGap: 0,
                    contentPadding: EdgeInsets.zero,
                    child: CheckboxListTile(
                      checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: TextWidget.textTitle("เผยแพร่"),
                      value: isSelect,
                      onChanged: onChange,
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                  )
                : ButtonApp.buttonSecondaryGradient(
                    context, 'ดูรายละเอียด', onClick)
          ],
        ),
      ),
    );
  }

  static Widget reportListItemTodayOfficerMonth(
      BuildContext context,
      String date,
      String time,
      GestureTapCallback onClick,
      dynamic data,
      String role,
      String fullDate,
      onCancel) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: greyBorder,
        ),
        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: blue_n,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                height: MediaQuery.of(context).size.width * 0.15,
                width: MediaQuery.of(context).size.width * 0.15,
                child: Center(
                  child: Text(
                    date,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextWidget.textTitleBold('รายงานคุณภาพน้ำ'),
                      ],
                    ),
                    Row(
                      children: [
                        TextWidget.textTitle(role == 'ADMIN'
                            ? 'รายงานคุณภาพน้ำประจำวันที่ $fullDate'
                            : 'รายงานคุณภาพน้ำรายเดือน\nวันที่ $fullDate .'),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Image.asset(
                  'asset/images/arrow_n.png',
                ),
              ),
            ],
          ),
          Status(context, data['workflow']['progress'],
              data['workflow']['label'], data['workflow']['state']),
          Divider(color: greyBorder),
          data['workflow']['state'] == 'REVIEW' ||
                  data['workflow']['state'] == 'REVIEWING'
              ? ButtonApp.buttonMainGradient(context, 'ตรวจสอบ', onClick, true)
              : ButtonApp.buttonSecondaryGradient(
                  context, 'ดูรายละเอียด', onClick)
        ],
      ),
    );
  }

  static Widget Status(
      BuildContext context, int progress, String title, String state) {
    if (progress == 1 || progress == 2 || progress == 3) {
      if (state == 'REVISION') {
        return Container(
          margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.transparent,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 23,
                  height: 23,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: red_n,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                // Image.asset(
                //   'asset/images/required.png',
                // ),
              ],
            ),
          ),
        );
      }

      return Container(
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'asset/images/yellowdot.png',
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 226, 205, 16),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 23,
                height: 23,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: mint_n,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: greenValue,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container();
  }

//   static Widget reportListItem(BuildContext context, String date, String time) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         side: BorderSide(
//           color: greyBorder,
//         ),
//         borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 margin: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                     color: greyBorder,
//                     border: Border.all(
//                       color: Colors.transparent,
//                     ),
//                     borderRadius: const BorderRadius.all(Radius.circular(20))),
//                 height: MediaQuery.of(context).size.width * 0.20,
//                 width: MediaQuery.of(context).size.width * 0.20,
//                 child: Center(
//                   child: Text(
//                     date,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.normal,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                   child: Column(
//                 children: [
//                   SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       child:
//                           TextWidget.textTitle('ปริมาณน้ำเสียนที่ผ่านการบำบัด')),
//                   SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       child: TextWidget.textSubTitle('2,000.00 ลบ.ม')),
//                 //   Row(
//                 //     mainAxisAlignment: MainAxisAlignment.start,
//                 //     children: [
//                 //       TextWidget.textTitle('DO 2.45'),
//                 //       const SizedBox(
//                 //         width: 10,
//                 //       ),
//                 //       TextWidget.textTitle('>'),
//                 //       const SizedBox(
//                 //         width: 10,
//                 //       ),
//                 //       TextWidget.textTitleWithColor('3.45 mg/I', greenValue),
//                 //     Row(
//                 //     mainAxisAlignment: MainAxisAlignment.start,
//                 //     children: [
//                 //       TextWidget.textTitle('PH 2.45'),
//                 //       const SizedBox(
//                 //         width: 10,
//                 //       ),
//                 //       TextWidget.textTitle('>'),
//                 //       const SizedBox(
//                 //         width: 10,
//                 //       ),
//                 //       TextWidget.textTitleWithColor('3.45 mg/I', greenValue),
//                 //     ],
//                 //   )
//                 // ],
//                 //   )
//             ],
//           )),
//           Divider(color: greyBorder),
//           ButtonApp.buttonMain(context, 'ส่งรายงาน', () {})
//         ],
//       ),
//     ]));
//   }

  static Widget cardListStation(
      BuildContext context, String station, GestureTapCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(5),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 8,
                        child: Column(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: TextWidget.textTitle(
                                    'ศูนย์บริหารจัดการคุณภาพน้ำ')),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: TextWidget.textGeneral(station)),
                          ],
                        )),
                    // Expanded(
                    //     flex: 1,
                    //     child: IconButton(
                    //       iconSize: 100,
                    //       icon: Container(
                    //         width: MediaQuery.of(context).size.width * 0.07,
                    //         height: MediaQuery.of(context).size.width * 0.07,
                    //         decoration: BoxDecoration(
                    //           color: red_n,
                    //           shape: BoxShape.circle,
                    //         ),
                    //         child: Center(
                    //             child: TextWidget.textTitleBoldWithColorSize(
                    //                 '4', Colors.white, 10)),
                    //       ),
                    //       onPressed: onPressed,
                    //     )),
                    Expanded(
                        flex: 2,
                        child: IconButton(
                          iconSize: 100,
                          icon: Image.asset(
                            'asset/images/arrow_n.png',
                          ),
                          onPressed: onPressed,
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget cardListStationScada(
      BuildContext context, String station, GestureTapCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 8,
                      child: Column(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextWidget.textGeneral(station)),
                        ],
                      )),
                  Expanded(
                      flex: 2,
                      child: IconButton(
                        iconSize: 100,
                        icon: Image.asset(
                          'asset/images/arrow_n.png',
                        ),
                        onPressed: onPressed,
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget cardList(
      BuildContext context, String station, GestureTapCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextWidget.textGeneral(station)),
                        ],
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget cardListDropdown(
      BuildContext context, String station, GestureTapCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: ListTile(
        title: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextWidget.textGeneral(station)),
                ),
                IconButton(
                  iconSize: 100,
                  icon: Image.asset(
                    'asset/images/arrow_n.png',
                  ),
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget progressItem(String time, String status) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Row(
        children: [
          TextWidget.textTitle(time),
          const SizedBox(
            width: 5,
          ),
          Container(
            height: 20,
            width: 1,
            color: Colors.transparent,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
              child: TextWidget.textTitleBoldWithColor(status, blue_navy_n)),
        ],
      ),
    );
  }

  static Widget progressItemHightlight(String time, String status) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Row(
        children: [
          TextWidget.textTitle(time),
          const SizedBox(
            width: 5,
          ),
          Container(
            height: 20,
            width: 1,
            color: Colors.transparent,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(child: TextWidget.textTitleBoldWithColor(status, blue_n)),
        ],
      ),
    );
  }

  static Widget newsCard(BuildContext context, String title, String url,
      dynamic news, String date) {
    return GestureDetector(
      onTap: () {
        Get.to(NewsDetail(
          news: news,
        ));
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.width * 0.33,
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  child: Image.network(url, fit: BoxFit.cover)),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: TextWidget.textTitleHTMLBoldLimit(title),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: TextWidget.textSubTitleWithSizeColor(
                        date, 10, Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget newsFirstCard(BuildContext context, String title, String url,
      dynamic news, String date) {
    return GestureDetector(
      onTap: () {
        Get.to(NewsDetail(
          news: news,
        ));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.27,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(url, fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextWidget.textTitleHTMLBold(title),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextWidget.textSubTitleWithSizeColor(date, 10, Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget reportListStation(BuildContext context, String title,
      String status, String date, String state, GestureTapCallback onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          // side: BorderSide(
          //   color: greyBorder,
          // ),
          borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                      child:
                          TextWidget.textTitle("ศูนย์บริหารจัดการคุณภาพน้ำ")),
                  Image.asset(
                    'asset/images/arrow_n.png',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Expanded(
                      child: TextWidget.textTitleBoldWithColorSize(
                          title, blue_navy_n, 18)),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.fromLTRB(5, 10, 5, 2),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    state == 'REVISION' || state == 'PENDING'
                        ? Image.asset(
                            'asset/images/orangedot.png',
                          )
                        : state == 'REVIEW' ||
                                state == 'REVIEWING' ||
                                state == 'RECHECK'
                            ? Image.asset('asset/images/yellowdot.png')
                            : state == 'COMPLETED'
                                ? Image.asset('asset/images/greendot.png')
                                : Image.asset('asset/images/greydot.png'),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      status,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   height: 20,
            // ),
            // Row(
            //   mainAxisSize: MainAxisSize.max,
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     date == 'null' || date == 'Null'
            //         ? TextWidget.textTitle('')
            //         : TextWidget.textTitle(date)
            //   ],
            // ),
            // Divider(color: greyBorder),
            // ButtonApp.buttonSecondary(context, 'ดูรายละเอียดศูนย์', onClick)
          ],
        ),
      ),
    );
  }

  static Widget reportListItemTodayAdmin(BuildContext context, String date,
      String time, GestureTapCallback onClick, dynamic data) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: greyBorder,
        ),
        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                height: MediaQuery.of(context).size.width * 0.20,
                width: MediaQuery.of(context).size.width * 0.20,
                child: Center(
                  child: Text(
                    date,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextWidget.textTitle('ปริมาณน้ำเสียที่ผ่านการบำบัด'),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextWidget.textSubTitle(
                        '${Label.commaFormat('${data['treated_water']}')} ลบ.ม'),
                  ),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            width: 100,
                            child: TextWidget.textTitle('DO ${data['doo']}')),
                        const SizedBox(
                          width: 10,
                        ),
                        TextWidget.textTitle('>'),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            width: 100,
                            child: TextWidget.textTitleWithColor(
                                '${data['treated_doo']} mg/I', greenValue)),
                      ]),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitle('pH ${data['ph']}')),
                      const SizedBox(
                        width: 10,
                      ),
                      TextWidget.textTitle('>'),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitleWithColor(
                              '${data['treated_ph']}', greenValue)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitle('°C ${data['temp']} °C')),
                      const SizedBox(
                        width: 10,
                      ),
                      TextWidget.textTitle('>'),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitleWithColor(
                              '${data['treated_temp']} °C', greenValue)),
                    ],
                  ),
                ],
              )
            ],
          ),
          data['workflow'] != null
              ? Status(context, data['workflow']['progress'],
                  data['workflow']['label'], data['workflow']['state'])
              : Container(),
          Divider(color: greyBorder),
          ButtonApp.buttonMainGradient(context, 'ดูรายละเอียด', onClick, false)
        ],
      ),
    );
  }

  static Widget reportListItemTodayAdminMonth(BuildContext context, String date,
      String time, GestureTapCallback onClick, dynamic data) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: greyBorder,
        ),
        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                height: MediaQuery.of(context).size.width * 0.20,
                width: MediaQuery.of(context).size.width * 0.20,
                child: Center(
                  child: Text(
                    date,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextWidget.textTitle('ปริมาณพลังงานไฟฟ้าที่ใช้'),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextWidget.textSubTitle(
                        '${Label.commaFormat(data['electric_unit']) ?? '-'} kW-hr'),
                  ),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            width: 100,
                            child: TextWidget.textTitle(
                                'BOD ${data['bod'] ?? '-'}')),
                        const SizedBox(
                          width: 10,
                        ),
                        TextWidget.textTitle('>'),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            width: 100,
                            child: TextWidget.textTitleWithColor(
                                '${data['treated_bod'] ?? '-'} mg/I',
                                greenValue)),
                      ]),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitle(
                              'COD ${data['cod'] ?? '-'}')),
                      const SizedBox(
                        width: 10,
                      ),
                      TextWidget.textTitle('>'),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitleWithColor(
                              '${data['treated_cod'] ?? '-'} mg/I',
                              greenValue)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child:
                              TextWidget.textTitle('SS ${data['ss'] ?? '-'}')),
                      const SizedBox(
                        width: 10,
                      ),
                      TextWidget.textTitle('>'),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitleWithColor(
                              '${data['treated_ss'] ?? '-'} mg/I', greenValue)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitle(
                              'Fat, Oil Grease ${data['fog'] ?? '-'}')),
                      const SizedBox(
                        width: 10,
                      ),
                      TextWidget.textTitle('>'),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitleWithColor(
                              '${data['treated_fog'] ?? '-'} mg/I',
                              greenValue)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitle(
                              'Total Nitrogen ${data['total_nitrogen'] ?? '-'}')),
                      const SizedBox(
                        width: 10,
                      ),
                      TextWidget.textTitle('>'),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitleWithColor(
                              '${data['treated_total_nitrogen'] ?? '-'} mg/I',
                              greenValue)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitle(
                              'Total Phosphorous ${data['total_phosphorous'] ?? '-'}')),
                      const SizedBox(
                        width: 10,
                      ),
                      TextWidget.textTitle('>'),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitleWithColor(
                              '${data['treated_total_phosphorous'] ?? '-'} mg/I',
                              greenValue)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitle(
                              'Salt ${data['salt'] ?? '-'}')),
                      const SizedBox(
                        width: 10,
                      ),
                      TextWidget.textTitle('>'),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: TextWidget.textTitleWithColor(
                              '${data['treated_salt'] ?? '-'} ppt.',
                              greenValue)),
                    ],
                  ),
                ],
              )
            ],
          ),
          Status(context, data['workflow']['progress'],
              data['workflow']['label'], data['workflow']['state']),
          Divider(color: greyBorder),
          ButtonApp.buttonSecondaryGradient(context, 'ดูรายละเอียด', onClick)
        ],
      ),
    );
  }

  static Widget newsCard_n(BuildContext context, String title, String url,
      dynamic news, String date) {
    return GestureDetector(
      onTap: () {
        Get.to(NewsDetail(
          news: news,
        ));
      },
      child: Container(
        // margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.width * 0.4,
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  child: Image.network(url, fit: BoxFit.cover)),
            ),
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.48,
                  child: TextWidget.textTitleHTMLBoldLimit(title),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  width: MediaQuery.of(context).size.width * 0.40,
                  child: TextWidget.textSubTitleWithSizeColor(
                      date, 10, Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget notificationsCard(BuildContext context, dynamic noti, onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.15,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget.textSubTitleBoldWithSizeGradient(
                      noti['body'], 15, Colors.white),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: TextWidget.textSubTitleWithSizeColor(
                            noti['created_at'], 10, Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            noti['read']
                ? Container()
                : Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: red_n,
                    ),
                  )
          ],
        ),
      ),
    );
  }

  static Widget eqTypeCard(BuildContext context, dynamic eq, onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.15,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: TextWidget.textTitleBold(eq['type']),
                      )
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Container(
                  //       alignment: Alignment.bottomLeft,
                  //       child: TextWidget.textSubTitleWithSizeColor(
                  //           noti['created_at'], 10, Colors.grey),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            // noti['read']
            //     ? Container()
            //     :
            Expanded(
              flex: 1,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: eq['total'] > 0 ? yellow_n : Colors.transparent,
                ),
                child: eq['total'] > 0
                    ? Center(child: TextWidget.textTitle('${eq['total']}'))
                    : const SizedBox(),
              ),
            ),
            Expanded(
              flex: 2,
              child: IconButton(
                iconSize: 100,
                icon: Image.asset(
                  'asset/images/arrow_n.png',
                ),
                onPressed: () async {
                  // Get.to(ReportDownloadList(
                  //   station: station,
                  //   role: role,
                  // ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget eqCard(BuildContext context, dynamic eq, onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.15,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 8,
              child: Column(
                children: [
                  Row(
                    children: [
                      TextWidget.textTitleBold('${eq['instrument']['EQ_name']}')
                    ],
                  ),

                  Row(
                    children: [
                      TextWidget.textTitle('${eq['instrument']['name']}'),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Container(
                  //       alignment: Alignment.bottomLeft,
                  //       child: TextWidget.textSubTitleWithSizeColor(
                  //           noti['created_at'], 10, Colors.grey),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            // noti['read']
            //     ? Container()
            //     :
            // Expanded(
            //   flex: 1,
            //   child: Container(
            //     width: 30,
            //     height: 30,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: yellow_n,
            //     ),
            //     child: Center(child: TextWidget.textTitle('${eq['total']}')),
            //   ),
            // ),
            Expanded(
              flex: 2,
              child: IconButton(
                iconSize: 100,
                icon: Image.asset(
                  'asset/images/arrow_n.png',
                ),
                onPressed: () async {
                  // Get.to(ReportDownloadList(
                  //   station: station,
                  //   role: role,
                  // ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget cardListDownload(BuildContext context, Station station,
      String role, String authorization, dynamic data) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: greyBorder,
        ),
        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: blue_n,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                height: MediaQuery.of(context).size.width * 0.15,
                width: MediaQuery.of(context).size.width * 0.15,
                child: Center(
                  child: Text(
                    data['abbr'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextWidget.textTitleBold('รายงานคุณภาพน้ำ'),
                      ],
                    ),
                    Row(
                      children: [
                        TextWidget.textTitle(data['text']),
                      ],
                    ),
                  ],
                ),
              ),
              // Expanded(
              //   flex: 2,
              //   child: Image.asset(
              //     'asset/images/download.png',
              //   ),
              // ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await Reportdownloadrequest.getReportDownload(
                      authorization, station.id, data['date'], 'xlsx');
                  var snackBar = const SnackBar(
                      content: Text(
                          'ดาวน์โหลดรายงานสำเร็จแล้ว กรุณาตรวจสอบไฟล์ ในพื้นที่เก็บไฟล์ดาวน์โหลดในโทรศัพท์ของคุณ'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Row(
                  children: [
                    Image.asset(
                      'asset/images/download.png',
                      scale: 1,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    TextWidget.textSubTitleWithSizeGradient(
                        'XLSX', 10, Colors.white)
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton(
                onPressed: () async {
                  await Reportdownloadrequest.getReportDownload(
                      authorization, station.id, data['date'], 'pdf');
                  var snackBar = const SnackBar(
                      content: Text(
                          'ดาวน์โหลดรายงานสำเร็จแล้ว กรุณาตรวจสอบไฟล์ ในพื้นที่เก็บไฟล์ดาวน์โหลดในโทรศัพท์ของคุณ'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Row(
                  children: [
                    Image.asset(
                      'asset/images/download.png',
                      scale: 1,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    TextWidget.textSubTitleWithSizeGradient(
                        'PDF', 10, Colors.white)
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              )
            ],
          ),
        ],
      ),
    );
  }
}
