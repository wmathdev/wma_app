import 'dart:async';
import 'dart:io';

import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wma_app/Utils/MapUtils.dart';
import 'package:wma_app/Utils/label.dart';

import 'package:wma_app/widget/text_widget.dart';

import '../../Utils/Color.dart';
import '../../api/MapRequest.dart';

import 'package:lottie/lottie.dart' as lottie;

import '../../widget/button_app.dart';
import '../../widget/dialog.dart';
import 'location_search.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'overview_datail.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _OverviewState extends State<Overview> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool loading = true;
  bool mapFetch = false;
  bool bottomfiltermenu = false;

  String searchtitle = 'ค้นหาศูนย์บริหารจัดการคุณภาพน้ำ';

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  late List<dynamic> mapData;
  late List<dynamic> display;
  List<MarkerData> location = [];
  late Position position;
  double doMin = 0;
  double doMax = 10;

  late dynamic treatedWater;

  late SfRangeValues _values;

  var today = '0';
  var summary = '0';
  var total = '0';
  var location_consent = false;

  Future<void> _getStation() async {
    setState(() {
      location = [];
      mapData = [];
    });
    var res1 = await MapRequest.getDocumentShow();
    var loc = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    treatedWater = await MapRequest.getTreatedWater();

    final SharedPreferences prefs = await _prefs;
    var share = (prefs.getBool('location_consent') ?? false);

    setState(() {
      mapData = res1['data'];
      position = loc;
      today = treatedWater['data']['today'];
      summary = treatedWater['data']['summary'];
      total = '${treatedWater['data']['total']}';
      location_consent = share;
    });
    // print(mapData);

    for (var i = 0; i < mapData.length; i++) {
      List<String> words = mapData[i]['location'].trim().split(",");
      try {
        // print('doMin $doMin : doMax $doMax');
        if (mapData[i]['document'] != null) {
          if (mapData[i]['document']['treated_doo'] >= doMin &&
              mapData[i]['document']['treated_doo'] <= doMax) {
            location.add(
              MarkerData(
                  marker: Marker(
                    onTap: () {
                      //this is what you're looking for!
                      // print('${mapData[i]['document']['treated_doo']}');

                      for (var j = 0; j < location.length; j++) {
                        if (location[j].marker.markerId ==
                            mapData[i]['id'].toString()) {
                          var _mark = MarkerData(
                              marker: Marker(
                                markerId: MarkerId(mapData[i]['id'].toString()),
                                position: LatLng(double.parse(words[0]),
                                    double.parse(words[1])),

                                // infoWindow: InfoWindow(title: 'my new Title'),
                              ),
                              child: _customMarkerSelect(
                                  '${mapData[i]['document']['treated_doo']}',
                                  Colors.black));
                          setState(() {
                            location[j] = _mark;
                          });
                        }
                      }

                      showBottomSheet(
                          mapData[i],
                          true,
                          mapData[i]['document']['evaluate']['result'],
                          LatLng(
                              double.parse(words[0]), double.parse(words[1])));
                    },
                    markerId: MarkerId(mapData[i]['id'].toString()),
                    position:
                        LatLng(double.parse(words[0]), double.parse(words[1])),
                  ),
                  child: _customMarker(
                      '${mapData[i]['document']['treated_doo']}',
                      Colors.black,
                      mapData[i]['document']['evaluate']['result'] ? 1 : 2)),
            );
          }
        } else {
          location.add(
            MarkerData(
                marker: Marker(
                  onTap: () {
                    showBottomSheet(mapData[i], false, false,
                        LatLng(double.parse(words[0]), double.parse(words[1])));
                  },
                  markerId: MarkerId(mapData[i]['id'].toString()),
                  position:
                      LatLng(double.parse(words[0]), double.parse(words[1])),
                ),
                child: _customMarker('-', Colors.black, 3)),
          );
        }
      } catch (e) {
        print(e);
      }
    }

    setState(() {
      loading = false;
      mapFetch = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _values = SfRangeValues(doMin, doMax);
    _getStation();
  }

  final locations = const [
    LatLng(37.42796133580664, -122.085749655962),
    LatLng(37.41796133580664, -122.085749655962),
  ];

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
              lottie.Lottie.asset(
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

    // if (!location_consent) {
    //   Future.delayed(const Duration(milliseconds: 500), () {
    //     MyDialog.showPermissionDialogOk(context,
    //         'WMA Clear Water APP collects location data to enable identification of nearby Wastewater Stations even when the app is closed or not in use.',
    //         () async {
    //       final SharedPreferences prefs = await _prefs;
    //       await prefs.setBool('location_consent', true);
    //       Get.back();
    //     }, () {
    //       exit(0);
    //     });
    //   });
    // }

    return Scaffold(
        body: CustomGoogleMapMarkerBuilder(
      customMarkers: location,
      builder: (BuildContext context, Set<Marker>? markers) {
        if (markers == null) {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
              overlayout(),
              mapFetch
                  ? Container(
                      color: Colors.black26,
                      child: const Center(child: CircularProgressIndicator()))
                  : Container()
            ],
          );
        }
        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 14.4746,
              ),
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            overlayout(),
            mapFetch
                  ? Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator())) : Container()
          ],
        );
      },
    )

        // GoogleMap(
        //   mapType: MapType.normal,
        //   initialCameraPosition: _kGooglePlex,
        //   onMapCreated: (GoogleMapController controller) {
        //     _controller.complete(controller);
        //   },
        //   markers: {
        //     const Marker(
        //       markerId: MarkerId('Sydney'),
        //       position: LatLng(37.42796133580664, -122.085749655962),
        //     )
        //   },
        // ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: _goToTheLake,
        //   label: const Text('To the lake!'),
        //   icon: const Icon(Icons.directions_boat),
        // ),
        );
  }

  _customMarker(String symbol, Color color, int rule) {
    return Stack(
      children: [
        SizedBox(
            width: 45,
            height: 45,
            child: rule == 1
                ? Image.asset('asset/images/blue_pin_n.png')
                : rule == 2
                    ? Image.asset('asset/images/red_pin_n.png')
                    : Image.asset('asset/images/blue_pin_n.png')),
        Positioned(
          left: 8,
          top: 6,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: TextWidget.textTitleBoldWithColorMarker(
                    symbol, Colors.white)),
          ),
        )
      ],
    );
  }

  _customMarkerSelect(String symbol, Color color) {
    return Stack(
      children: [
        SizedBox(
            width: 45,
            height: 45,
            child: Image.asset('asset/images/markerselect.png')),
        Positioned(
          left: 8,
          top: 6,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: TextWidget.textTitleBoldWithColorMarker(
                    symbol, Colors.white)),
          ),
        )
      ],
    );
  }

  Widget overlayout() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          bottomfiltermenu ? bottomBar() : iconmenu(),
          Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 10, child: searchbar()),
                Expanded(
                    flex: 2,
                    child: MaterialButton(
                      minWidth: 10,
                      height: 20,
                      onPressed: () async {
                        var loc = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.low);

                        GoogleMapController controller =
                            await _controller.future;

                        Timer(const Duration(milliseconds: 500), () async {
                          controller.animateCamera(CameraUpdate.newLatLngZoom(
                              LatLng(loc.latitude, loc.longitude), 14.4746));
                        });
                      },
                      color: Colors.white,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(10),
                      shape: CircleBorder(),
                      child: SizedBox(
                        width: 15,
                        height: 15,
                        child: Image.asset('asset/images/target.png'),
                      ),
                    )),
              ],
            ),
            headerBar(),
          ]),
        ],
      ),
    );
  }

  Widget searchbar() {
    return GestureDetector(
      onTap: () async {
        var placeid = await Get.to(LocationSearch(
          station: mapData,
        ));

        dynamic panlocation;
        for (var i = 0; i < mapData.length; i++) {
          if (placeid == mapData[i]['id']) {
            panlocation = mapData[i];
          }
        }

        List<String> words = panlocation['location'].trim().split(",");

        // await mapController.animateCamera(CameraUpdate.newLatLngZoom(
        //     LatLng(double.parse(words[0]), double.parse(words[1])), 14.4746));
        GoogleMapController controller = await _controller.future;

        Timer(const Duration(milliseconds: 500), () async {
          controller.animateCamera(CameraUpdate.newLatLngZoom(
              LatLng(double.parse(words[0]), double.parse(words[1])), 14.4746));
        });
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 5),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 44,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset('asset/images/start_search_icon.png'),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextWidget.textSubTitleWithSizeColor(
                            searchtitle, 10, Colors.black45)),
                  ],
                )),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 60,
                child: Center(
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Image.asset('asset/images/bi_search.png'),
                  ),
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

  Widget headerBar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      // height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset('asset/images/drop.png'),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget.textTitleWithColorSize(
                        'ปริมาณน้ำเสียที่ผ่านการบำบัดจากทั้งหมด $total แห่ง',
                        Colors.black,
                        10),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget.textTitleWithColorSize(
                        'ล่าสุด ', Colors.grey, 13),
                    TextWidget.textTitleWithGradient(today, blueSelected, 13),
                    TextWidget.textTitleWithColorSize(
                        ' ลบ.ม. |', Colors.grey, 13),
                    TextWidget.textTitleWithColorSize(
                        ' สะสม ', Colors.grey, 13),
                    TextWidget.textTitleWithGradient(summary, blueSelected, 13),
                    TextWidget.textTitleWithColorSize(
                        ' ลบ.ม. ', Colors.grey, 13),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget iconmenu() {
    return Align(
      alignment: FractionalOffset.bottomRight,
      child: GestureDetector(
        onTap: () {
          setState(() {
            bottomfiltermenu = true;
          });
        },
        child: Container(
          height: 50,
          width: 50,
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Image.asset('asset/images/setting.png'),
        ),
      ),
    );
  }

  Widget bottomBar() {
    return Align(
        alignment: FractionalOffset.bottomCenter,
        child: GestureDetector(
          onTap: () {
            setState(() {
              bottomfiltermenu = false;
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.13,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget.textTitleWithColorSize(
                              'ตัวกรองคุณภาพออกซิเจนในน้ำ DO (mg/l)',
                              Colors.grey,
                              11),
                          TextWidget.textTitleWithColorSize(
                              'แสดง ${location.length} จาก $total แห่ง',
                              Colors.black,
                              11),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget.textTitleWithColorSize(
                              'ต่ำมาก', Colors.grey, 11),
                          TextWidget.textTitleWithColorSize(
                              'ปกติ', Colors.grey, 11),
                          TextWidget.textTitleWithColorSize(
                              'ดีมาก', Colors.grey, 11),
                        ],
                      ),
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            height: 20,
                            margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                            color: const Color.fromARGB(255, 220, 220, 220),
                          ),
                          Container(
                            height: 20,
                            margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                            // padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    blue_n,
                                    blue_n,
                                    blue_n,
                                    blue_n,
                                    blue_n,
                                    red_n,
                                    red_n
                                  ],
                                )),
                          ),
                          SfRangeSliderTheme(
                            data: SfRangeSliderThemeData(
                                thumbRadius: 20,
                                activeLabelStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                inactiveLabelStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                labelOffset: const Offset(0, -18),
                                thumbStrokeWidth: 0,
                                disabledActiveTrackColor: Colors.transparent,
                                thumbColor: Colors.white,
                                activeTrackHeight: 20,
                                activeTrackColor: Colors.transparent,
                                overlayRadius: 5,
                                trackCornerRadius: 5,
                                inactiveTrackHeight: 20,
                                inactiveTrackColor:
                                    const Color.fromARGB(255, 220, 220, 220),
                                overlayColor: Colors.transparent),
                            child: SfRangeSlider(
                              showLabels: true,
                              min: 0,
                              max: 10,
                              stepSize: 1,
                              values: _values,
                              interval: 1,
                              labelFormatterCallback:
                                  (dynamic actualValue, String formattedText) {
                                if (actualValue == _values.start ||
                                    actualValue == _values.end) {
                                  return '';
                                }

                                return formattedText;
                              },
                              startThumbIcon: Center(
                                  child: TextWidget.textSubTitleWithSizeColor(
                                      '${_values.start.toInt()}',
                                      16,
                                      Colors.black)),
                              endThumbIcon: Center(
                                  child: TextWidget.textSubTitleWithSizeColor(
                                      '${_values.end.toInt()}',
                                      16,
                                      Colors.black)),
                              onChanged: (SfRangeValues values) async {
                                print(values);
                                setState(() {
                                  mapFetch = true;
                                  _values = values;
                                  doMin = values.start;
                                  doMax = values.end;
                                });
                                await _getStation();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ));
  }

  showBottomSheet(
      dynamic station, bool isSubmited, bool isRule, LatLng latlng) {
    showModalBottomSheet<void>(
        context: context,
        enableDrag: false,
        builder: (BuildContext context) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            height: isSubmited
                ? MediaQuery.of(context).size.height * 0.4
                : MediaQuery.of(context).size.height * 0.25,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Image.asset('asset/images/greybar.png')]),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 30, height: 30, child: Container()),
                        Expanded(
                            child: TextWidget.textTitle(
                                'ศูนย์บริหารจัดการคุณภาพน้ำ')),
                      ]),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 30, height: 30, child: Container()),
                        Expanded(
                            child: TextWidget.textTitleBoldWithColor(
                                station['lite_name'], Colors.black)),
                      ]),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.asset('asset/images/mappin.png'),
                      ),
                      Expanded(
                          child: TextWidget.textTitleHTMLBoldLimit1(
                              station['address'])),
                    ],
                  ),
                  isSubmited
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: Image.asset('asset/images/mapdrop.png'),
                            ),
                            Expanded(
                                flex: 2,
                                child: TextWidget.textTitle(
                                    'ล่าสุดบำบัดน้ำเสียแล้ว')),
                            Expanded(
                              flex: 1,
                              child: TextWidget.textSubTitleWithSizeGradient(
                                  station['document'] == null
                                      ? '-'
                                      : Label.commaFormat(
                                          station['document']['treated_water']),
                                  15,
                                  blueSelected),
                            ),
                            Expanded(
                                flex: 1, child: TextWidget.textTitle('ลบ.ม.')),
                          ],
                        )
                      : Container(),
                  isSubmited
                      ? Container(
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              TextWidget.textSubTitleBoldWithSizeGradient(
                                station['document'] == null
                                    ? '-'
                                    : '${station['document']['treated_doo']}',
                                55,
                                blue_n,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget.textSubTitleWithSizeColor(
                                      'mg/I', 15, Colors.black),
                                  TextWidget.textSubTitleWithSizeColor(
                                      'ค่ามาตรฐานออกซิเจนในน้ำ\nDissolved Oxygen (Do)',
                                      10,
                                      Colors.black26)
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: 1,
                                height: 50,
                                color: blue_navy_n,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget.textSubTitleWithSizeColor(
                                      station['document'] == null
                                          ? '-'
                                          : station['document']['evaluate']
                                                  ['result']
                                              ? 'ผ่าน'
                                              : 'ไม่ผ่าน',
                                      15,
                                      Colors.black),
                                  TextWidget.textSubTitleWithSizeColor(
                                      'คุณภาพ\n', 10, Colors.black26)
                                ],
                              ),
                            ],
                          ),
                        )

                      // Container(
                      //     margin: const EdgeInsets.all(10),
                      //     height: MediaQuery.of(context).size.height * 0.12,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         color: isRule
                      //             ? blueGreenlight
                      //             : Color.fromARGB(255, 255, 246, 174)),
                      //     child: Row(
                      //       children: [
                      //         Expanded(
                      //             flex: 1,
                      //             child: Stack(
                      //                 alignment: Alignment.center,
                      //                 children: [
                      //                   Container(
                      //                     height: MediaQuery.of(context)
                      //                             .size
                      //                             .height *
                      //                         0.1,
                      //                     decoration: BoxDecoration(
                      //                         borderRadius:
                      //                             const BorderRadius.only(
                      //                           topLeft: Radius.circular(10),
                      //                           bottomLeft: Radius.circular(10),
                      //                         ),
                      //                         color: isRule
                      //                             ? blueGreen
                      //                             : Color.fromARGB(
                      //                                 255, 255, 209, 102)),
                      //                   ),
                      //                   Container(
                      //                       padding: const EdgeInsets.all(10),
                      //                       child: isRule
                      //                           ? Image.asset(
                      //                               'asset/images/circlewater.png')
                      //                           : Image.asset(
                      //                               'asset/images/circlewateryellow.png')),
                      //                   TextWidget.textTitleBoldWithColor(
                      //                       station['document'] == null
                      //                           ? '-'
                      //                           : '${station['document']['treated_doo']}',
                      //                       Colors.white)
                      //                 ])),
                      //         Expanded(
                      //             flex: 1,
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: Column(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.center,
                      //                 children: [
                      //                   TextWidget.textBigWithColor(
                      //                       station['document'] == null
                      //                           ? '- mg/l'
                      //                           : '${station['document']['treated_doo']} mg/l',
                      //                       isRule
                      //                           ? blueGreen
                      //                           : Color.fromARGB(
                      //                               255, 255, 193, 48)),
                      //                   TextWidget.textSubTitleWithSizeColor(
                      //                       'ค่ามาตรฐานออกซิเจนในน้ำ\nDissolved oxygen (Do)',
                      //                       8,
                      //                       isRule
                      //                           ? blueGreen
                      //                           : Color.fromARGB(
                      //                               255, 255, 193, 48))
                      //                 ],
                      //               ),
                      //             )),
                      //         Expanded(
                      //             flex: 1,
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: Column(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.center,
                      //                 children: [
                      //                   TextWidget.textBigWithColor(
                      //                       station['document'] == null
                      //                           ? '-'
                      //                           : station['document']
                      //                                   ['evaluate']['result']
                      //                               ? 'ผ่าน'
                      //                               : 'ไม่ผ่าน',
                      //                       isRule
                      //                           ? blueGreen
                      //                           : Color.fromARGB(
                      //                               255, 255, 193, 48)),
                      //                   TextWidget.textSubTitleWithSizeColor(
                      //                       'คุณภาพ',
                      //                       8,
                      //                       isRule
                      //                           ? blueGreen
                      //                           : Color.fromARGB(
                      //                               255, 255, 193, 48))
                      //                 ],
                      //               ),
                      //             )),
                      //       ],
                      //     ),
                      //   )
                      : Container(),
                  ButtonApp.buttonMainGradientWithIcon(context, 'ดูรายละเอียด',
                      () async {
                    Get.to(OverviewDertail(
                        stationId: '${station['id']}',
                        isSubmited: isSubmited,
                        isRule: isRule,
                        latlng: latlng));
                  }, true),
                  ButtonApp.buttonSecondary(context, 'นำทาง', () async {
                    await MapUtils.openMap(latlng.latitude, latlng.longitude);
                  }),
                ],
              ),
            ),
          );
        });
  }
}
