import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wma_app/Utils/Color.dart';
import 'package:wma_app/api/OtherRequest.dart';
import 'package:wma_app/view/graph/solarcell/solarcellreport.dart';
import 'package:wma_app/view/graph/solarcell/solarcellreportyear.dart';
import 'package:wma_app/view/graph/statgraphMonth_n.dart';
import 'package:wma_app/view/graph/statgraphQuarter_n.dart';
import 'package:wma_app/view/graph/statgraphYear_n.dart';
import 'package:wma_app/view/graph/statgraph_n.dart';

import '../../Utils/label.dart';
import '../../widget/button_app.dart';
import '../../widget/text_widget.dart';
import '../graph/statgraph.dart';
import '../graph/statgraphMonth.dart';
import '../graph/statgraphQuarter.dart';
import '../graph/statgraphYear.dart';

class Statistic extends StatefulWidget {
  Statistic({super.key});

  @override
  State<Statistic> createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  late dynamic data;
  List<dynamic> graph = [];

  late dynamic dataMonth;
  List<dynamic> graphMonth = [];

  late dynamic dataQUARTER;
  List<dynamic> graphQUARTER = [];

  late dynamic dataYear;
  List<dynamic> graphYear = [];

  bool loading = true;
  bool swapinggraph = false;

  var select = 0;
  int tab = 0;

  String solarReportType = 'DAILY';
  dynamic solarReport = '';
  String solarReportCache = '';
  dynamic solarReportData = '';

  bool dailytab = true;
  bool monthlytab = false;

  String treeReportCache = '';
  dynamic treeReportData = '';

  Future<void> _getData() async {
    var res = await OtherRequest.statistic('WEEK');
    data = res;
    graph = data['data']['graph'];

    var res2 = await OtherRequest.statistic('MONTH');
    dataMonth = res2;
    graphMonth = dataMonth['data']['graph'];

    var res3 = await OtherRequest.statistic('QUARTER');
    dataQUARTER = res3;
    graphQUARTER = dataQUARTER['data']['graph'];

    var res4 = await OtherRequest.statistic('YEAR');
    dataYear = res4;
    graphYear = dataYear['data']['graph'];

    var res5 = await OtherRequest.statisticSolarcellPlant(solarReportType);
    solarReport = res5;
    solarReportCache = solarReport['data']['collect_at'];
    solarReportData = solarReport['data']['data'];

    var res6 = await OtherRequest.statisticSolarcellPlant('YEARLY');
    treeReportCache = res6['data']['collect_at'];
    treeReportData = res6['data']['data'];

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
          body: SafeArea(
              child: Container(
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
              TextWidget.textGeneralWithColor('กรุณารอสักครู่...', blueSelected)
            ],
          ),
        ),
      )));
    }
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('asset/images/waterbg.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              ToggleSwitch(
                minWidth: MediaQuery.of(context).size.width * 0.8,
                minHeight: MediaQuery.of(context).size.width * 0.15,
                initialLabelIndex: tab,
                totalSwitches: 2,
                activeBgColor: [
                  bottomNav_blue,
                  blue_n_txt1,
                ],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.white,
                inactiveFgColor: blue_navy_n,
                labels: ['ปริมาณน้ำเสีย\nที่ผ่านการบำบัด', 'พลังงานสะอาด'],
                onToggle: (index) {
                  setState(() {
                    tab = index!;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.78,
                child: SingleChildScrollView(
                    child: tab == 0 ? statisticTab() : solarTab()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget solarTab() {
    return Column(
      children: [
        headerBarSolar(),
        SizedBox(
          height: 15,
        ),
        menu(),
        SizedBox(
          height: 15,
        ),
        filterMenu(),
        SizedBox(
          height: 15,
        ),
        TextWidget.textTitleWithColorSize(
            'อัปเดตเมื่อ $solarReportCache', Colors.black, 8),
        solargraph(),
      ],
    );
  }

  Widget filterMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonApp.buttonGraphFilter2(context, 'ย้อนหลัง 1 เดือน', () async {
          setState(() {
            loading = true;
            dailytab = true;
            monthlytab = false;
            solarReportType = 'DAILY';

            solarReport = '';
            solarReportCache = '';
            solarReportData = '';
          });
          await _getData();
        }, dailytab),
        SizedBox(
          width: 20,
        ),
        ButtonApp.buttonGraphFilter2(context, 'ย้อนหลัง 1 ปี', () async {
          setState(() {
            loading = true;
            dailytab = false;
            monthlytab = true;
            solarReportType = 'MONTHLY';

            solarReport = '';
            solarReportCache = '';
            solarReportData = '';
          });
          await _getData();
        }, monthlytab),
      ],
    );
  }

  Widget solargraph() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        margin: const EdgeInsetsDirectional.all(20),
        child: dailytab
            ? SolarcellReportGraph(
                data: solarReportData,
                type: _current,
              )
            : SolarcellReportyearGraph(
                data: solarReportData,
                type: _current,
              ));
  }

  Widget statisticTab() {
    return Column(
      children: [
        headerBar(),
        const SizedBox(
          height: 10,
        ),
        valueCard(),
        const SizedBox(
          height: 20,
        ),
        graphFilter(),
        const SizedBox(
          height: 20,
        ),
        select == 0
            ? weekgraph()
            : select == 1
                ? monthgraph()
                : select == 2
                    ? quartergraph()
                    : yeargraph()
      ],
    );
  }

  Widget headerBar() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height * 0.1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'asset/images/bigdrop.png',
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextWidget.textTitleWithColorSize(
                        'ปริมาณน้ำเสียที่ผ่านการบำบัด', Colors.black, 15),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextWidget.textTitleWithColorSize(
                        'จากศูนย์บริหารจัดการคุณภาพน้ำ ${data['data']['stations']} แห่ง',
                        const Color.fromARGB(255, 111, 111, 111),
                        11),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget headerBarSolar() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        // height: MediaQuery.of(context).size.height * 0.1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'asset/images/pine-tree.png',
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextWidget.textSubTitleBoldWithSizeGradient(
                        '${treeReportData[0]['reduction_total_tree'].ceil()}',30, Colors.black),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextWidget.textTitleWithColorSize(
                        'Equivalent trees planted',
                        const Color.fromARGB(255, 111, 111, 111),
                        11),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget valueCard() {
    return Container(
        margin: const EdgeInsets.all(10),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    child: select == 0
                        ? TextWidget.textTitle(
                            'ปริมาณสะสมตั้งแต่ ${data['data']['period']}')
                        : select == 1
                            ? TextWidget.textTitle(
                                'ปริมาณสะสมตั้งแต่ ${dataMonth['data']['period']}')
                            : select == 2
                                ? TextWidget.textTitle(
                                    'ปริมาณสะสมตั้งแต่ ${dataQUARTER['data']['period']}')
                                : TextWidget.textTitle(
                                    'ปริมาณสะสมตั้งแต่ ${dataYear['data']['period']}'),
                  )
                ],
              ),
              Row(
                children: [
                  select == 0
                      ? TextWidget.textSubTitleWithSizeGradient(
                          Label.nemerricFormat(data['data']['total'] * 1.00),
                          25,
                          blueSelected)
                      : select == 1
                          ? TextWidget.textSubTitleWithSizeGradient(
                              Label.nemerricFormat(
                                  dataMonth['data']['total'] * 1.00),
                              25,
                              blueSelected)
                          : select == 2
                              ? TextWidget.textSubTitleWithSizeGradient(
                                  Label.nemerricFormat(
                                      dataQUARTER['data']['total'] * 1.00),
                                  25,
                                  blueSelected)
                              : TextWidget.textSubTitleWithSizeGradient(
                                  Label.nemerricFormat(
                                      dataYear['data']['total'] * 1.00),
                                  25,
                                  blueSelected),
                  SizedBox(
                    width: 10,
                  ),
                  TextWidget.textTitle('ลบ.ม.')
                ],
              ),
            ]),
          ),
        ));
  }

  List<bool> graphFilterIndex = [true, false, false, false];

  Widget graphFilter() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ButtonApp.buttonGraphFilter(context, '1 สัปดาห์', () async {
          graphFilterIndex = [true, false, false, false];
          // await _getData('WEEK');
          setState(() {
            select = 0;
          });
        }, graphFilterIndex[0]),
        ButtonApp.buttonGraphFilter(context, '1 เดือน', () async {
          graphFilterIndex = [false, true, false, false];
          // await _getData('MONTH');
          setState(() {
            select = 1;
          });
        }, graphFilterIndex[1]),
        ButtonApp.buttonGraphFilter(context, '3 เดือน', () async {
          graphFilterIndex = [false, false, true, false];
          // await _getData('QUARTER');
          setState(() {
            select = 2;
          });
        }, graphFilterIndex[2]),
        ButtonApp.buttonGraphFilter(context, '1 ปี', () async {
          graphFilterIndex = [false, false, false, true];
          // await _getData('YEAR');
          setState(() {
            select = 3;
          });
        }, graphFilterIndex[3])
      ],
    );
  }

  Widget weekgraph() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: const EdgeInsetsDirectional.all(20),
      child: Statgraph_n(
        data: graph,
        rule: '',
      ),
    );
    // return SizedBox(
    //   height: MediaQuery.of(context).size.height * 0.5,
    //   child: Stack(
    //     children: [
    //       Stack(
    //         children: [
    //           SizedBox(
    //             width: MediaQuery.of(context).size.width,
    //             child: ListView(
    //                 shrinkWrap: true,
    //                 primary: false,
    //                 scrollDirection: Axis.horizontal,
    //                 children: [
    //                   StatGraph(
    //                     data: graph,
    //                     rule: '',
    //                   ),
    //                 ]),
    //           ),
    //           Row(
    //             children: [
    //               Container(
    //                 width: MediaQuery.of(context).size.width * 0.15,
    //                 height: MediaQuery.of(context).size.height * 0.5,
    //                 color: Colors.white,
    //               )
    //             ],
    //           ),
    //         ],
    //       ),
    //       Stack(
    //         children: [
    //           Positioned(
    //               bottom: 0,
    //               child: Container(
    //                 width: MediaQuery.of(context).size.width * 0.2,
    //                 height: MediaQuery.of(context).size.height * 0.5,
    //                 color: Colors.white,
    //               )),
    //           Container(
    //             width: MediaQuery.of(context).size.width * 0.2,
    //             child: ListView(
    //                 shrinkWrap: true,
    //                 primary: false,
    //                 physics: const NeverScrollableScrollPhysics(),
    //                 scrollDirection: Axis.horizontal,
    //                 children: [
    //                   StatGraph(
    //                     data: graph,
    //                     rule: '',
    //                   ),
    //                 ]),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget monthgraph() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: const EdgeInsetsDirectional.all(20),
      child: StatgraphMonthN(
        data: graphMonth,
        rule: '',
      ),
    );
    // return SizedBox(
    //   height: MediaQuery.of(context).size.height * 0.5,
    //   child: Stack(
    //     children: [
    //       Stack(
    //         children: [
    //           SizedBox(
    //             width: MediaQuery.of(context).size.width,
    //             child: ListView(
    //                 shrinkWrap: true,
    //                 primary: false,
    //                 scrollDirection: Axis.horizontal,
    //                 children: [
    //                   StatGraphMonth(
    //                     data: graphMonth,
    //                     rule: '',
    //                   ),
    //                 ]),
    //           ),
    //           Row(
    //             children: [
    //               Container(
    //                 width: MediaQuery.of(context).size.width * 0.15,
    //                 height: MediaQuery.of(context).size.height * 0.5,
    //                 color: Colors.white,
    //               )
    //             ],
    //           ),
    //         ],
    //       ),
    //       Stack(
    //         children: [
    //           Positioned(
    //               bottom: 0,
    //               child: Container(
    //                 width: MediaQuery.of(context).size.width * 0.2,
    //                 height: MediaQuery.of(context).size.height * 0.5,
    //                 color: Colors.white,
    //               )),
    //           Container(
    //             width: MediaQuery.of(context).size.width * 0.2,
    //             child: ListView(
    //                 shrinkWrap: true,
    //                 primary: false,
    //                 physics: const NeverScrollableScrollPhysics(),
    //                 scrollDirection: Axis.horizontal,
    //                 children: [
    //                   StatGraphMonth(
    //                     data: graphMonth,
    //                     rule: '',
    //                   ),
    //                 ]),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget quartergraph() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: const EdgeInsetsDirectional.all(20),
      child: StatgraphquarterN(
        data: graphQUARTER,
        rule: '',
      ),
    );
  }

  // Widget quartergraph() {
  //   return SizedBox(
  //     height: MediaQuery.of(context).size.height * 0.5,
  //     child: Stack(
  //       children: [
  //         Stack(
  //           children: [
  //             SizedBox(
  //               width: MediaQuery.of(context).size.width,
  //               child: ListView(
  //                   shrinkWrap: true,
  //                   primary: false,
  //                   scrollDirection: Axis.horizontal,
  //                   children: [
  //                     StatGraphQuater(
  //                       data: graphQUARTER,
  //                       rule: '',
  //                     ),
  //                   ]),
  //             ),
  //             Row(
  //               children: [
  //                 Container(
  //                   width: MediaQuery.of(context).size.width * 0.15,
  //                   height: MediaQuery.of(context).size.height * 0.5,
  //                   color: Colors.white,
  //                 )
  //               ],
  //             ),
  //           ],
  //         ),
  //         Stack(
  //           children: [
  //             Positioned(
  //                 bottom: 0,
  //                 child: Container(
  //                   width: MediaQuery.of(context).size.width * 0.2,
  //                   height: MediaQuery.of(context).size.height * 0.5,
  //                   color: Colors.white,
  //                 )),
  //             Container(
  //               width: MediaQuery.of(context).size.width * 0.2,
  //               child: ListView(
  //                   shrinkWrap: true,
  //                   primary: false,
  //                   physics: const NeverScrollableScrollPhysics(),
  //                   scrollDirection: Axis.horizontal,
  //                   children: [
  //                     StatgraphquarterN(
  //                       data: graphQUARTER,
  //                       rule: '',
  //                     ),
  //                   ]),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget yeargraph() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: const EdgeInsetsDirectional.all(20),
      child: StatgraphyearN(
        data: graphYear,
        rule: '',
      ),
    );
  }

  // Widget yeargraph() {
  //   return Container(
  //     height: MediaQuery.of(context).size.height * 0.6,
  //     decoration: BoxDecoration(
  //       color: Color.fromARGB(255, 255, 255, 255),
  //       borderRadius: BorderRadius.all(Radius.circular(20)),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.5),
  //           spreadRadius: 5,
  //           blurRadius: 7,
  //           offset: Offset(0, 3), // changes position of shadow
  //         ),
  //       ],
  //     ),
  //     margin: const EdgeInsetsDirectional.all(20),
  //     child: Stack(
  //       children: [
  //         Stack(
  //           children: [
  //             Container(
  //               width: MediaQuery.of(context).size.width,
  //               decoration: BoxDecoration(
  //                 color: Color.fromARGB(255, 255, 255, 255),
  //                 borderRadius: BorderRadius.all(Radius.circular(20)),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.grey.withOpacity(0.5),
  //                     spreadRadius: 5,
  //                     blurRadius: 7,
  //                     offset: Offset(0, 3), // changes position of shadow
  //                   ),
  //                 ],
  //               ),
  //               child: ListView(
  //                   shrinkWrap: true,
  //                   primary: false,
  //                   scrollDirection: Axis.horizontal,
  //                   children: [
  //                     StatgraphyearN(
  //                       data: graphYear,
  //                       rule: '',
  //                     ),
  //                   ]),
  //             ),
  //             Row(
  //               children: [
  //                 Container(
  //                   width: MediaQuery.of(context).size.width * 0.15,
  //                   height: MediaQuery.of(context).size.height * 0.5,
  //                   color: Colors.white,
  //                 )
  //               ],
  //             ),
  //           ],
  //         ),
  //         Stack(
  //           children: [
  //             Positioned(
  //                 bottom: 0,
  //                 child: Container(
  //                   width: MediaQuery.of(context).size.width * 0.2,
  //                   height: MediaQuery.of(context).size.height * 0.5,
  //                   color: Colors.white,
  //                 )),
  //             Container(
  //               width: MediaQuery.of(context).size.width * 0.2,
  //               child: ListView(
  //                   shrinkWrap: true,
  //                   primary: false,
  //                   physics: const NeverScrollableScrollPhysics(),
  //                   scrollDirection: Axis.horizontal,
  //                   children: [
  //                     StatgraphyearN(
  //                       data: graphYear,
  //                       rule: '',
  //                     ),
  //                   ]),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  int _current = 0;
  Widget menu() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        CarouselSlider.builder(
            itemCount: 2,
            options: CarouselOptions(
              enlargeCenterPage: true,
              aspectRatio: 5.0,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                print('_current=====');
                print(index);
                setState(() {
                  loading = true;
                });

                if (index == 0) {
                  setState(() {
                    // graphHeaderIndex = [true, false, false];
                    _current = index;
                    loading = false;
                  });
                } else if (index == 1) {
                  setState(() {
                    // graphHeaderIndex = [false, true, false];
                    _current = index;
                    loading = false;
                  });
                } else if (index == 2) {
                  setState(() {
                    // graphHeaderIndex = [false, false, true];
                    _current = index;
                    loading = false;
                  });
                }
              },
            ),
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Card(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget.textSubTitleBoldWithSizeGradient(
                          itemIndex == 0
                              ? 'Standard coal saved'
                              : itemIndex == 1
                                  ? 'CO₂ Emission reduction'
                                  : 'Equivalent trees planted',
                          20,
                          Colors.white),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     TextWidget.textTitleBold(
                      //         itemIndex == 0 ? 'Dissolved oxygen' : ''),
                      //     TextWidget.textTitleBold(itemIndex == 0
                      //         ? ' ค่ามาตรฐานออกซิเจนในน้ำ'
                      //         : itemIndex == 1
                      //             ? 'ค่าความเป็นกรด-ด่าง'
                      //             : 'ค่าอุณหภูมิ')
                      //   ],
                      // )
                    ],
                  ),
                ),
              );

              //  ListItemWidget.newsCard_n(
              //     context,
              //     news[itemIndex]['title']['rendered'],
              //     news[itemIndex]['jetpack_featured_media_url'],
              //     news[itemIndex],
              //     showDate(news[itemIndex]['date']));
            }),
        // const SizedBox(
        //   height: 10,
        // ),
      ],
    );
  }
}
