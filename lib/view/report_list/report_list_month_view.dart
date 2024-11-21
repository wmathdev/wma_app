import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wma_app/view/report_form/report_form_month_view_edit.dart';

import '../../Utils/month.dart';
import '../../api/ManagerRequest.dart';
import '../../api/OfficerRequest.dart';
import '../../api/OperatorRequest.dart';
import '../../model/user.dart';
import '../../widget/dialog.dart';
import '../../widget/list_item_widget.dart';
import '../report_form/cancel_popup_month.dart';
import '../report_form/report_form_manager_month.dart';
import '../report_form/report_form_month_officer.dart';
import '../report_form/report_form_month_view.dart';
import '../report_home/report_detail.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
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
import '../report_home/report_detail_month.dart';
import '../telephone_list/contact_view.dart';

class ReportListMonthView extends StatefulWidget {
  Station station;
  String role;
  ReportListMonthView({
    Key? key,
    required this.station,
    required this.role,
  }) : super(key: key);

  @override
  State<ReportListMonthView> createState() => _ReportListMonthViewState();
}

class _ReportListMonthViewState extends State<ReportListMonthView> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var accessToken = '';

  var today = DateTime.now();
  final outputFormat = DateFormat('yyyy-MM-dd');
  String formattedDate = '';

  late String month;
  late String year;

  var loading = true;

  List<dynamic> data = [];

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
        'MONTHLY',
        peroid,
      );
    } else if (widget.role == 'MANAGER') {
      result = await ManagerRequest.getDocumentLists(
          accessToken, '${widget.station.id}', 'MONTHLY', peroid);
    } else if (widget.role == 'OFFICER') {
      result = await OfficerRequest.getDocumentLists(
          accessToken, '${widget.station.id}', 'MONTHLY', peroid);
    }
    print('$result');
    if (result['success'] == false) {
      MyDialog.showAlertDialogOk(context, '${result['message']}', () {
        Get.back();
        Get.back();
      });
    } else {
      setState(() {
        data = result['data'];
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
    return RefreshIndicator(
      onRefresh: () => _getDocumentList(
        '',
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Container(
                    height: 80,
                    alignment: Alignment.topCenter,
                    child: NavigateBar.NavBarWithNotebook(
                        context, 'รายงานคุณภาพน้ำประจำเดือน', () {
                      Get.back();
                    }),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextWidget.textSubTitle(widget.station.name),
                  ),
                  filterMenu(),
                  listView()
                ],
              ),
            ),
          ),
          // Container(
          //   height: 80,
          //   alignment: Alignment.topCenter,
          //   child: NavigateBar.NavBarWithNotification(
          //       context, 'รายงานประจำเดือนทั้งหมด', () {
          //     Get.back();
          //   }),
          // ),
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
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: blueButton,
                      border: Border.all(
                        color: blueButtonBorder,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
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
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'asset/images/setting.png',
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
        if (data[index]['document'] == null) {
          if (widget.role == 'MANAGER' || widget.role == 'OFFICER') {
            return ListItemWidget.reportListHeaderManagerMonth(
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

          return ListItemWidget.reportListHeaderMonth(
              context,
              '${data[index]['date'].toString().substring(8)}\n${Month.getMonthLabel(data[index]['date'])}',
              Month.getMonthTitleReverse(data[index]['date']),
              '10.00',
              widget.role, () async {
            if (( //Time.checkTimeStatus('00:00AM', '10:00AM') &&
                    widget.role == 'OPERATOR') ||
                widget.role == 'ADMIN') {
              await Get.to(ReportFormMonth(
                  role: widget.role,
                  station: widget.station,
                  date: data[index]['date']));
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
            return ListItemWidget.reportListItemTodayManagerMonth(
                context,
                '${data[index]['date'].toString().substring(8)}\n${Month.getMonthLabel(data[index]['date'])}',
                '10.00', () async {
              if (data[index]['document']['workflow']['state'] == 'REVIEW' ||
                  data[index]['document']['workflow']['state'] == 'Review' ||
                  data[index]['document']['workflow']['state'] == 'REVIEWING' ||
                  data[index]['document']['workflow']['state'] == 'COMPLETED' ||
                  data[index]['document']['workflow']['state'] == 'REVISION') {
                Get.to(ReportDetailMonth(
                    documentId: '${data[index]['document']['id']}',
                                station: widget.station,
                    role: widget.role));
              } else {
                await Get.to(ReportFormManagerMonth(
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
            }, data[index]['document'], widget.role, data[index]['date'],
                () {});
          }

          if (widget.role == 'OFFICER') {
            print('role ; ${widget.role}');
            return ListItemWidget.reportListItemTodayOfficerMonth(
                context,
                '${data[index]['date'].toString().substring(8)}\n${Month.getMonthLabel(data[index]['date'])}',
                '10.00', () async {
              if (data[index]['document']['workflow']['state'] == 'REVIEW' ||
                  data[index]['document']['workflow']['state'] == 'Review' ||
                  data[index]['document']['workflow']['state'] == 'REVIEWING') {
                await Get.to(ReportFormMonthOfficer(
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
                Get.to(ReportDetailMonth(
                    documentId: '${data[index]['document']['id']}',
                                station: widget.station,
                    role: widget.role));
              }
            }, data[index]['document'], widget.role,
                Month.getMonthTitleReverse(data[index]['date']), () {});
          }

          if (widget.role == 'ADMIN') {
            print('role ; ${widget.role}');
            return ListItemWidget.reportListItemTodayAdminMonth(
                context,
                '${data[index]['date'].toString().substring(8)}\n${Month.getMonthLabel(data[index]['date'])}',
                '10.00', () async {
              if (data[index]['document']['workflow']['state'] == 'COMPLETED') {
                Get.to(ReportDetailMonth(
                    documentId: '${data[index]['document']['id']}',
                                station: widget.station,
                    role: widget.role));
              } else {
                final SharedPreferences prefs = await _prefs;
                accessToken = (prefs.getString('access_token') ?? '');
                await Get.to(ReportformMonthViewEdit(
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

          return ListItemWidget.reportListItemTodayMonth(
              context,
              '${data[index]['date'].toString().substring(8)}\n${Month.getMonthLabel(data[index]['date'])}',
              '10.00', () async {
            await Get.to(CancelPopupMonth(
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
                data[index]['document']['workflow']['state'] == 'COMPLETED' ||
                data[index]['document']['workflow']['state'] == 'REVIEW' ||
                data[index]['document']['workflow']['state'] == 'REVIEWING') {
              Get.to(ReportDetail(
                  documentId: '${data[index]['document']['id']}',
                  station: widget.station,
                  role: widget.role));
            } else {
              final SharedPreferences prefs = await _prefs;
              accessToken = (prefs.getString('access_token') ?? '');
              await Get.to(ReportformMonthViewEdit(
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
          }, Month.getMonthTitleReverse(data[index]['date']), widget.role,
              data[index]['document']);
        }

        // if (index == 5) {
        //   return Container(
        //     margin: const EdgeInsets.all(10),
        //     child: Center(
        //         child: TextWidget.textGeneralWithColor(
        //             'ดูรายงานทั้งหมด', blueSelected)),
        //   );
        // }

        // if (data[index]['document'] == null ||
        //     data[index]['document']['workflow'] == null) {
        //   return Container();
        // }

        // return ListItemWidget.reportListItemMonth(
        //     context,
        //     '${data[index]['date'].toString().substring(8)}\n${Month.getMonthLabel(data[index]['date'])}',
        //     '10.00', () {
        //   Get.to(ReportDetail(
        //       documentId: '${data[index]['document']['id']}',
        //       role: widget.role));
        // }, data[index]['document']);
      },
    );
  }
}
