// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wma_app/api/ManagerRequest.dart';
import 'package:wma_app/api/OfficerRequest.dart';
import 'package:wma_app/view/report_form/cancel_popup.dart';
import 'package:wma_app/view/report_form/recheck_popup_edit.dart';

import 'package:wma_app/view/report_form/report_form_view.dart';
import 'package:wma_app/view/report_form/report_from_view_edit.dart';
import 'package:wma_app/view/report_home/report_detail.dart';
import 'package:wma_app/view/report_list/report_list_filter_view.dart';

import '../../Utils/Color.dart';
import '../../Utils/month.dart';
import '../../Utils/time.dart';
import '../../api/OperatorRequest.dart';
import '../../model/user.dart';
import '../../widget/dialog.dart';
import '../../widget/list_item_widget.dart';
import '../../widget/navigatebar.dart';
import '../../widget/text_widget.dart';
import '../report_form/report_form_manager.dart';
import '../report_form/report_from_officer.dart';
import '../telephone_list/contact_view.dart';

class ReportList extends StatefulWidget {
  Station station;
  String role;
  ReportList({
    Key? key,
    required this.station,
    required this.role,
  }) : super(key: key);

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var accessToken = '';

  var today = DateTime.now();
  final outputFormat = DateFormat('yyyy-MM-dd');
  String formattedDate = '';

  late String month;
  late String year;

  var loading = true;

  List<dynamic> data = [];
  List<bool> publicList = [];

  Future<void> _getDocumentList(
    String peroid,
  ) async {
    final SharedPreferences prefs = await _prefs;
    accessToken = (prefs.getString('access_token') ?? '');
    var result;
    if (widget.role == 'OPERATOR' || widget.role == 'ADMIN') {
      result = await OperatorRequest.getDocumentLists(
        accessToken,
        '${widget.station.id}',
        'DAILY',
        peroid,
      );
    } else if (widget.role == 'MANAGER') {
      result = await ManagerRequest.getDocumentLists(
          accessToken, '${widget.station.id}', 'DAILY', peroid);
    } else if (widget.role == 'OFFICER') {
      result = await OfficerRequest.getDocumentLists(
          accessToken, '${widget.station.id}', 'DAILY', peroid);
    }
    if (result['success'] == false) {
      MyDialog.showAlertDialogOk(context, '${result['message']}', () {
        Get.back();
        Get.back();
      });
    } else {
      setState(() {
        data = result['data'];
        for (var i = 0; i < data.length; i++) {
          publicList.add(false);
        }
        loading = false;
      });
      print(result['data']);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (loading) {
      _getDocumentList(
        '',
      );
      formattedDate = DateFormat('yyyy-MM-dd').format(today);
      setState(() {
        month = Month.getMonthFullLabel(formattedDate);
        year = formattedDate.substring(0, 4);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: loading
                ? Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage('asset/images/waterbg.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
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
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage('asset/images/waterbg.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: contentView()),
          ),
        ));
  }

  Widget contentView() {
    return RefreshIndicator(
      onRefresh: () => _getDocumentList(
        '',
      ),
      child: Column(
        children: [
          Container(
            height: 80,
            alignment: Alignment.topCenter,
            child: NavigateBar.NavBarWithNotification(
                context, 'รายงานประจำวันทั้งหมด', () {
              Get.back();
            }),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 110,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
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
                    filterMenu(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TextWidget.textTitleBold('รายงานประจำวัน'),
                      ),
                    ),
                    listView()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterMenu() {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: TextButton(
                onPressed: null,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: blueButton,
                      border: Border.all(
                        color: blueButtonBorder,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: Center(
                      child:
                          TextWidget.textGeneralWithColor(month, Colors.black)),
                ))),
        Expanded(
            flex: 3,
            child: TextButton(
                onPressed: null,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: blueButton,
                      border: Border.all(
                        color: blueButtonBorder,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: Center(
                      child: TextWidget.textGeneralWithColor(
                          '${int.parse(year) + 543}', Colors.black)),
                ))),
        Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  loading = true;
                });
                dynamic result = await Get.to(const ReprotListFilter());
                print('result');
                print(result);
                if (result != null) {
                  await _getDocumentList(
                    result,
                  );
                  setState(() {
                    year = result.substring(0, 4);
                    month = Month.getMonthFullLabel(result);
                  });
                }
                setState(() {
                  loading = false;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'asset/images/setting.png',
                        scale: 1,
                      ),
                      onPressed: null,
                    ),
                  ],
                ),
              ),
            ))
      ],
    );
  }

  Widget listView() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        if (formattedDate == '${data[index]['date']}' ||
            widget.role == 'ADMIN') {
          if (data[index]['document'] == null) {
            if (widget.role == 'MANAGER' || widget.role == 'OFFICER') {
              return ListItemWidget.reportListHeaderManager(
                  context,
                  '${data[index]['date'].toString().substring(8)}\n${Month.getMonthLabel(data[index]['date'])}',
                  Month.getMonthTitleReverse(data[index]['date']),
                  '10.00',
                  widget.role, () async {
                await Get.to(ContactView(station: widget.station));

                setState(() {
                  loading = true;
                  _getDocumentList(
                    '',
                  );
                });
              });
            }

            return ListItemWidget.reportListHeader(
                context,
                '${data[index]['date'].toString().substring(8)}\n${Month.getMonthLabel(data[index]['date'])}',
                Month.getMonthTitleReverse(data[index]['date']),
                '10.00',
                widget.role, () async {
              if (( //Time.checkTimeStatus('00:00AM', '10:00AM') &&
                      widget.role == 'OPERATOR') ||
                  widget.role == 'ADMIN') {
                await Get.to(ReportForm(
                    role: widget.role,
                    station: widget.station,
                    date: DateFormat("yyyy-MM-dd").parse(data[index]['date'])));
                setState(() {
                  loading = true;
                  _getDocumentList(
                    '',
                  );
                });
              } else {
                await Get.to(ContactView(station: widget.station));
              }
            });
          } else {
            if (widget.role == 'MANAGER') {
              return ListItemWidget.reportListItemTodayManager(
                  context,
                  '${data[index]['date'].toString().substring(8)}\n${Month.getMonthLabel(data[index]['date'])}',
                  '10.00', () async {
                if (data[index]['document']['workflow']['state'] == 'REVIEW' ||
                    data[index]['document']['workflow']['state'] == 'Review' ||
                    data[index]['document']['workflow']['state'] ==
                        'REVISION' ||
                    data[index]['document']['workflow']['state'] ==
                        'COMPLETED') {
                  Get.to(ReportDetail(
                      documentId: '${data[index]['document']['id']}',
                      station: widget.station,
                      role: widget.role));
                } else {
                  await Get.to(ReportFormManager(
                    document: data[index]['document'],
                    datelabel: data[index]['date'],
                    role: widget.role,
                    station: widget.station,
                  ));
                  setState(() {
                    loading = true;
                    _getDocumentList(
                      '',
                    );
                  });
                }
              }, data[index]['document'], () {});
            }

            if (widget.role == 'OFFICER') {
              return ListItemWidget.reportListItemTodayOfficer(
                  context,
                  '${data[index]['date'].toString().substring(8)}\n${Month.getMonthLabel(data[index]['date'])}',
                  '10.00',
                  () async {
                    if (data[index]['document']['workflow']
                                ['state'] ==
                            'REVIEW' ||
                        data[index]['document']['workflow']['state'] ==
                            'Review' ||
                        data[index]['document']['workflow']['state'] ==
                            'REVIEWING') {
                      await Get.to(ReportFormOfficer(
                        document: data[index]['document'],
                        datelabel: data[index]['date'],
                        role: widget.role,
                        station: widget.station,
                      ));
                      setState(() {
                        loading = true;
                        _getDocumentList(
                          '',
                        );
                      });
                    } else {
                      Get.to(ReportDetail(
                          documentId: '${data[index]['document']['id']}',
                          station: widget.station,
                          role: widget.role));
                    }
                  },
                  data[index]['document'],
                  () {},
                  (value) {
                    setState(() {
                      publicList[index] = value;
                    });
                  },
                  publicList[index]);
            }

            if (widget.role == 'ADMIN') {
              print('role ; ${widget.role}');
              return ListItemWidget.reportListItemTodayAdmin(
                  context,
                  '${data[index]['date'].toString().substring(8)}\n${Month.getMonthLabel(data[index]['date'])}',
                  '10.00', () async {
                if (data[index]['document']['workflow']['state'] ==
                    'COMPLETED') {
                  Get.to(ReportDetail(
                      documentId: '${data[index]['document']['id']}',
                      role: widget.role, station: widget.station,));
                } else {
                  final SharedPreferences prefs = await _prefs;
                  accessToken = (prefs.getString('access_token') ?? '');
                  await Get.to(ReportFormViewEdit(
                    station: widget.station,
                    data: data[index],
                    role: widget.role,
                  ));
                  setState(() {
                    loading = true;
                    _getDocumentList(
                      '',
                    );
                  });
                }
              }, data[index]['document']);
            }

            return ListItemWidget.reportListItemToday(
                context,
                '${data[index]['date'].toString().substring(8)}\n${Month.getMonthLabel(data[index]['date'])}',
                '10.00', () async {
              await Get.to(CancelPopup(
                  dateLabel: Month.getMonthTitleReverse(data[index]['date']),
                  documentId: '${data[index]['document']['id']}'));
              setState(() {
                loading = true;
                _getDocumentList(
                  '',
                );
              });
              // Get.to(ReportDetail(
              //     documentId: '${data[index]['document']['id']}',
              //     role: widget.role));
            }, () async {
              if (data[index]['document']['workflow']['state'] == 'COMPLETED' ||
                  data[index]['document']['workflow']['state'] == 'REVIEW' ||
                  data[index]['document']['workflow']['state'] == 'REVIEWING') {
                Get.to(ReportDetail(
                    documentId: '${data[index]['document']['id']}',
                    role: widget.role, station: widget.station,));
              } else {
                final SharedPreferences prefs = await _prefs;
                accessToken = (prefs.getString('access_token') ?? '');
                await Get.to(ReportFormViewEdit(
                  station: widget.station,
                  data: data[index],
                  role: widget.role,
                ));
                setState(() {
                  loading = true;
                  _getDocumentList(
                    '',
                  );
                });
              }
            }, data[index]['document']);
          }
        }

        // if (index == 5) {
        //   return Container(
        //     margin: const EdgeInsets.all(10),
        //     child: Center(
        //         child: TextWidget.textGeneralWithColor(
        //             'ดูรายงานทั้งหมด', blueSelected)),
        //   );
        // }

        if (data[index]['document'] == null ||
            data[index]['document']['workflow'] == null) {
          return Container();
        }

        return ListItemWidget.reportListItem(
            context,
            '${data[index]['date'].toString().substring(8)}\n${Month.getMonthLabel(data[index]['date'])}',
            '10.00', () {
          Get.to(ReportDetail(
              documentId: '${data[index]['document']['id']}',
              role: widget.role, station: widget.station,));
        }, data[index]['document']);
      },
    );
  }
}
