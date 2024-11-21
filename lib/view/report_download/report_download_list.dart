import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wma_app/Utils/Color.dart';
import 'package:wma_app/Utils/month.dart';
import 'package:wma_app/api/ReportDownloadRequest.dart';
import 'package:wma_app/model/user.dart';
import 'package:wma_app/view/report_download/report_download_filter.dart';
import 'package:wma_app/widget/list_item_widget.dart';
import 'package:wma_app/widget/navigatebar.dart';
import 'package:wma_app/widget/text_widget.dart';

class ReportDownloadList extends StatefulWidget {
  Station station;
  String role;
  ReportDownloadList({
    Key? key,
    required this.station,
    required this.role,
  }) : super(key: key);

  @override
  State<ReportDownloadList> createState() => _ReportDownloadListState();
}

class _ReportDownloadListState extends State<ReportDownloadList> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var accessToken = '';

  var today = DateTime.now();
  final outputFormat = DateFormat('yyyy-MM-dd');
  String formattedDate = '';

  late String month;
  late String year;

  var loading = true;

  dynamic data;

  Future<void> _getReportDownloadList(
    String year,
  ) async {
    final SharedPreferences prefs = await _prefs;
    accessToken = (prefs.getString('access_token') ?? '');
    var result;

    result = await Reportdownloadrequest.getReportDownloadList(
        accessToken, widget.station.id, year);

    setState(() {
      data = result['data'];
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (loading) {
      formattedDate = DateFormat('yyyy-MM-dd').format(today);
      _getReportDownloadList(formattedDate.substring(0, 4));
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
    return Column(
      children: [
        Container(
          height: 80,
          alignment: Alignment.topCenter,
          child: NavigateBar.NavBar(context, 'ดาวน์โหลดรายงานประจำเดือน', () {
            Get.back();
          }),
        ),
        Container(
          height: MediaQuery.of(context).size.height - 105,
          child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(children: [
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
                            TextWidget.textSubTitleBoldMedium(
                                widget.station.lite_name),
                          ],
                        )
                      ],
                    ),
                    filterMenu(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TextWidget.textTitleBold(
                            'ดาวน์โหลดรายงานประจำเดือน'),
                      ),
                    ),
                    listView()
                  ]))),
        ),
      ],
    );
  }

  Widget listView() {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListItemWidget.cardListDownload(
              context, widget.station, widget.role, accessToken, data[index]);
        });
  }

  Widget filterMenu() {
    return Row(
      children: [
        Expanded(
            flex: 6,
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
                          'ปีงบประมาณ ${int.parse(year) + 543}', Colors.black)),
                ))),
        Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  loading = true;
                });
                dynamic result = await Get.to(const ReportDownloadFilter());
                print('result');
                print(result);
                if (result != null) {
                  await _getReportDownloadList(
                    result,
                  );
                  setState(() {
                    year = result.substring(0, 4);
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
}
