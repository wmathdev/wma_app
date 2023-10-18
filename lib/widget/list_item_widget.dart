import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:wma_app/Utils/Color.dart';
import 'package:wma_app/api/Authentication.dart';
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
        print(' TERK : $authorization');
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Image.asset(
                        'asset/images/day_card.png',
                      ),
                      onPressed: () async {
                        Position position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.low);
                        await Authentication.checkin(authorization,
                            '${position.latitude},${position.longitude}');
                        Get.to(ReportList(
                          station: station,
                          role: role,
                        ));
                      },
                    )),
                Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextWidget.textGeneral('รายงานประจำวัน')),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextWidget.textTitle(
                              'ส่งรายงานประจำวันและ\nและดูประวัติรายงานเพิ่มเติม'),
                        )
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: IconButton(
                      iconSize: 100,
                      icon: Image.asset(
                        'asset/images/arrow_card.png',
                      ),
                      onPressed: () async {
                        Position position = await Geolocator.getCurrentPosition(
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
                        color: Colors.red[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Image.asset(
                                  'asset/images/notice_card.png',
                                ),
                                onPressed: () async {
                                  Position position =
                                      await Geolocator.getCurrentPosition(
                                          desiredAccuracy:
                                              LocationAccuracy.low);
                                  await Authentication.checkin(authorization,
                                      '${position.latitude},${position.longitude}');
                                  Get.to(ReportList(
                                    station: station,
                                    role: role,
                                  ));
                                },
                              ),
                              Expanded(
                                  child: TextWidget.textGeneral(
                                      'โปรดรายงานคุณภาพน้ำประจำวันที่ $date ก่อนเวลา $time น.')),
                            ],
                          ),
                        )),
                  )
                : Container(),
          ],
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Image.asset(
                        'asset/images/day_card.png',
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
                Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextWidget.textGeneral('รายงานประจำวัน')),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextWidget.textTitle(
                              'ส่งรายงานประจำวันและ\nและดูประวัติรายงานเพิ่มเติม'),
                        )
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: IconButton(
                      iconSize: 100,
                      icon: Image.asset(
                        'asset/images/arrow_card.png',
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Image.asset(
                        'asset/images/month_card.png',
                      ),
                      onPressed: () async {
                        Position position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.low);
                        await Authentication.checkin(authorization,
                            '${position.latitude},${position.longitude}');
                        Get.to(ReportListMonthView(
                          station: station,
                          role: role,
                        ));
                      },
                    )),
                Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextWidget.textGeneral('รายงานประจำเดือน')),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextWidget.textTitle(
                              'ส่งรายงานประจำเดือนและ\nและดูประวัติรายงานเพิ่มเติม'),
                        )
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: IconButton(
                      iconSize: 100,
                      icon: Image.asset(
                        'asset/images/arrow_card.png',
                      ),
                      onPressed: () async {
                        Position position = await Geolocator.getCurrentPosition(
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Image.asset(
                        'asset/images/month_card.png',
                      ),
                      onPressed: () async {
                        Position position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.low);
                        await Authentication.checkin(authorization,
                            '${position.latitude},${position.longitude}');
                        Get.to(StationListMonth(
                          role: role,
                        ));
                      },
                    )),
                Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextWidget.textGeneral('รายงานประจำเดือน')),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextWidget.textTitle(
                              'รายงานประจำเดือนและ\nและดูประวัติรายงานเพิ่มเติม'),
                        )
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: IconButton(
                      iconSize: 100,
                      icon: Image.asset(
                        'asset/images/arrow_card.png',
                      ),
                      onPressed: () async {
                        Position position = await Geolocator.getCurrentPosition(
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
    );
  }

  //Telephone
  static Widget telephoneHeader(BuildContext context, String title, Color bg) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: bg,
          border: Border.all(
            color: Colors.transparent,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  static Widget telephoneItem(BuildContext context, String title, Color bg,
      GestureTapCallback onClick) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: bg,
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: onClick,
              child: const Text(
                'โทร',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
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
                      color: Colors.black87,
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
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
                    child: TextWidget.textTitle(role == 'ADMIN'
                        ? 'รายงานคุณภาพน้ำประจำวันที่ $fullDate'
                        : 'โปรดรายงานคุณภาพน้ำประจำวันที่ $fullDate ก่อนเวลา $time น.'))
              ],
            ),
            Divider(color: greyBorder),
            ButtonApp.buttonMain(context, 'ส่งรายงาน', onClick, true)
          ],
        ),
      );
    }

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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                  const SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    'asset/images/required.png',
                  ),
                ],
              ),
            ),
          ),
          Divider(color: greyBorder),
          ButtonApp.buttonOutline(context, 'ดูข้อมูลการติดต่อ', onClick)
        ],
      ),
    );
  }

  static Widget reportListHeaderMonth(BuildContext context, String date,
      String fullDate, String time, String role, GestureTapCallback onClick) {
    if ((Time.checkTimeStatus('00:00AM', '10:00AM') &&  role == 'OPERATOR') ||
        role == 'ADMIN') {
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
                      color: Colors.black87,
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
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
                    child: TextWidget.textTitle(role == 'ADMIN'
                        ? 'รายงานคุณภาพน้ำประจำวันที่ $fullDate'
                        : 'โปรดรายงานคุณภาพน้ำรายเดือน\nวันที่ $fullDate .'))
              ],
            ),
            Divider(color: greyBorder),
            ButtonApp.buttonMain(context, 'ส่งรายงาน', onClick, true)
          ],
        ),
      );
    }

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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                  const SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    'asset/images/required.png',
                  ),
                ],
              ),
            ),
          ),
          Divider(color: greyBorder),
          ButtonApp.buttonOutline(context, 'ดูข้อมูลการติดต่อ', onClick)
        ],
      ),
    );
  }

  static Widget reportListHeaderManager(BuildContext context, String date,
      String fullDate, String time, String role, GestureTapCallback onClick) {
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
                      'โปรดรายงานคุณภาพน้ำประจำวันที่ $fullDate ก่อนเวลา $time น.'))
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: greyBG,
                border: Border.all(
                  color: Colors.transparent,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    role == 'MANAGER'
                        ? 'รอเจ้าหน้าที่ดำเนินการ'
                        : 'รอผู้จัดการตรวจสอบ',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  role == 'MANAGER'
                      ? Image.asset(
                          'asset/images/orangedot.png',
                        )
                      : Image.asset(
                          'asset/images/yellowdot.png',
                        ),
                ],
              ),
            ),
          ),
          Divider(color: greyBorder),
          ButtonApp.buttonOutline(context, 'ดูข้อมูลการติดต่อ', onClick)
        ],
      ),
    );
  }

  static Widget reportListHeaderManagerMonth(BuildContext context, String date,
      String fullDate, String time, String role, GestureTapCallback onClick) {
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
                      'รายงานคุณภาพน้ำประจำเดือน\nวันที่ $fullDate'))
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: greyBG,
                border: Border.all(
                  color: Colors.transparent,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    role == 'MANAGER'
                        ? 'รอเจ้าหน้าที่ดำเนินการ'
                        : 'รอผู้จัดการตรวจสอบ',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  role == 'MANAGER'
                      ? Image.asset(
                          'asset/images/orangedot.png',
                        )
                      : Image.asset(
                          'asset/images/yellowdot.png',
                        ),
                ],
              ),
            ),
          ),
          Divider(color: greyBorder),
          ButtonApp.buttonOutline(context, 'ดูข้อมูลการติดต่อ', onClick)
        ],
      ),
    );
  }

  static Widget reportListItem(BuildContext context, String date, String time,
      GestureTapCallback onPressed, dynamic data) {
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
                        '${data['treated_water']} ลบ.ม'),
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
          Status(context, data['workflow']['progress'],
              data['workflow']['label'], data['workflow']['state']),
          Divider(color: greyBorder),
          ButtonApp.buttonSecondary(context, 'ดูรายละเอียดเพิ่มเติม', onPressed)
        ],
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
                        '${data['electric_unit'] ?? '-'} kW-hr'),
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
                        '${data['treated_water']} ลบ.ม'),
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
          Status(context, data['workflow']['progress'],
              data['workflow']['label'], data['workflow']['state']),
          Divider(color: greyBorder),
          data['workflow']['state'] == 'REVISION'
              ? ButtonApp.buttonMain(context, 'แก้ไข', onPressed, true)
              : data['workflow']['state'] == 'COMPLETED' ||
                      data['workflow']['state'] == 'REVIEW' ||
                      data['workflow']['state'] == 'REVIEWING'
                  ? ButtonApp.buttonOutline(context, 'ดูรายละเอียด', onPressed)
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonApp.buttonSecondaryFixCard(
                            context, 'ยกเลิกการส่ง', onCancel, true),
                        ButtonApp.buttonOutlineFix(context, 'แก้ไข', onPressed)
                      ],
                    )
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
      dynamic data) {
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
                        '${data['electric_unit'] ?? '-'} kW-hr'),
                  ),
                  const SizedBox(
                    height: 10,
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
          data['workflow']['state'] == 'REVISION'
              ? ButtonApp.buttonMain(context, 'แก้ไข', onPressed, true)
              : data['workflow']['state'] == 'COMPLETED'
                  ? ButtonApp.buttonOutline(context, 'ดูรายละเอียด', onPressed)
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonApp.buttonSecondaryFixCard(
                            context, 'ยกเลิกการส่ง', onCancel, true),
                        ButtonApp.buttonOutlineFix(context, 'แก้ไข', onPressed)
                      ],
                    )
        ],
      ),
    );
  }

  static Widget reportListItemTodayManager(BuildContext context, String date,
      String time, GestureTapCallback onClick, dynamic data, onCancel) {
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
                        '${data['treated_water']} ลบ.ม'),
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
          Status(context, data['workflow']['progress'],
              data['workflow']['label'], data['workflow']['state']),
          Divider(color: greyBorder),
          data['workflow']['state'] == 'REVIEW' ||
                  data['workflow']['state'] == 'REVIEWING' ||
                  data['workflow']['state'] == 'REVISION' ||
                  data['workflow']['state'] == 'COMPLETED' 
              ? ButtonApp.buttonOutline(context, 'ดูรายละเอียด', onClick)
              : ButtonApp.buttonMain(context, 'ตรวจสอบ', onClick, true)
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
      onCancel) {
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
                        '${data['electric_unit'] ?? '-'} kW-hr'),
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
          data['workflow']['state'] == 'REVIEW' ||
                  data['workflow']['state'] == 'COMPLETED' ||
                  data['workflow']['state'] == 'REVISION'
              ? ButtonApp.buttonOutline(context, 'ดูรายละเอียด', onClick)
              : ButtonApp.buttonMain(context, 'ตรวจสอบ', onClick, true)
        ],
      ),
    );
  }

  static Widget reportListItemTodayOfficer(BuildContext context, String date,
      String time, GestureTapCallback onClick, dynamic data, onCancel) {
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
                        '${data['treated_water']} ลบ.ม'),
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
          Status(context, data['workflow']['progress'],
              data['workflow']['label'], data['workflow']['state']),
          Divider(color: greyBorder),
          data['workflow']['state'] == 'REVIEW' ||
                  data['workflow']['state'] == 'REVIEWING'
              ? ButtonApp.buttonMain(context, 'ตรวจสอบ', onClick, true)
              : ButtonApp.buttonOutline(context, 'ดูรายละเอียด', onClick)
        ],
      ),
    );
  }

  static Widget reportListItemTodayOfficerMonth(
      BuildContext context,
      String date,
      String time,
      GestureTapCallback onClick,
      dynamic data,
      onCancel) {
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
                        '${data['electric_unit'] ?? '-'} kW-hr'),
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
          data['workflow']['state'] == 'REVIEW' ||
                  data['workflow']['state'] == 'REVIEWING'
              ? ButtonApp.buttonMain(context, 'ตรวจสอบ', onClick, true)
              : ButtonApp.buttonOutline(context, 'ดูรายละเอียด', onClick)
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
              color: Colors.red[50],
              border: Border.all(
                color: Colors.transparent,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                Image.asset(
                  'asset/images/required.png',
                ),
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
            color: greyBG,
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Image.asset(
                'asset/images/yellowdot.png',
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
            color: greenBG,
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: greenValue,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Image.asset(
                'asset/images/bi_check-circle-fill.png',
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
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Image.asset(
                        'asset/images/hydroelectric.png',
                      ),
                      onPressed: () {},
                    )),
                Expanded(
                    flex: 5,
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
                        'asset/images/arrow_card.png',
                      ),
                      onPressed: () {},
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  static Widget cardList(
      BuildContext context, String station, GestureTapCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: 10,
                    )),
                Expanded(
                    flex: 5,
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
                        'asset/images/arrow_card.png',
                      ),
                      onPressed: onPressed,
                    )),
              ],
            )
          ],
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
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextWidget.textGeneral(station)),
          ),
        ),
      ),
    );
  }

  static Widget progressItem(String time, String status) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        children: [
          TextWidget.textGeneral(time),
          const SizedBox(
            width: 5,
          ),
          Container(
            height: 20,
            width: 1,
            color: Colors.grey,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(child: TextWidget.textGeneral(status)),
        ],
      ),
    );
  }

  static Widget progressItemHightlight(String time, String status) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: blueButtonBorder,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: [
          TextWidget.textGeneralWithColor(time, blueButtonText),
          const SizedBox(
            width: 5,
          ),
          Container(
            height: 20,
            width: 1,
            color: blueButtonText,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
              child: TextWidget.textGeneralWithColor(status, blueButtonText)),
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
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.33,
                height: MediaQuery.of(context).size.width * 0.33,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(url, fit: BoxFit.cover)),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.50,
                  child: TextWidget.textTitleHTMLBold(title),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  width: MediaQuery.of(context).size.width * 0.50,
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
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: greyBorder,
        ),
        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [Expanded(child: TextWidget.textTitle(title))],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: greyBG,
                border: Border.all(
                  color: Colors.transparent,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    status,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  state == 'REVISION'
                      ? Image.asset(
                          'asset/images/orangedot.png',
                        )
                      : state == 'PENDING' || state == 'NEW'
                          ? Image.asset('asset/images/yellowdot.png')
                          : Image.asset('asset/images/greendot.png')
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              date == 'null' || date == 'Null'
                  ? TextWidget.textTitle('')
                  : TextWidget.textTitle(date)
            ],
          ),
          Divider(color: greyBorder),
          ButtonApp.buttonSecondary(context, 'ดูรายละเอียดศูนย์', onClick)
        ],
      ),
    );
  }

  static Widget reportListItemTodayAdmin(BuildContext context, String date,
      String time, GestureTapCallback onClick, dynamic data) {
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
                        '${data['treated_water']} ลบ.ม'),
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
          ButtonApp.buttonOutline(context, 'ดูรายละเอียด', onClick)
        ],
      ),
    );
  }

  static Widget reportListItemTodayAdminMonth(BuildContext context, String date,
      String time, GestureTapCallback onClick, dynamic data) {
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
                        '${data['electric_unit'] ?? '-'} kW-hr'),
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
          ButtonApp.buttonOutline(context, 'ดูรายละเอียด', onClick)
        ],
      ),
    );
  }
}
