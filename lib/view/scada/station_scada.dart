// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wma_app/model/user.dart';
import 'package:wma_app/view/scada/scada.dart';
import 'package:wma_app/widget/appbar.dart';
import 'package:wma_app/widget/list_item_widget.dart';
import 'package:wma_app/widget/navigatebar.dart';
import 'package:wma_app/widget/text_widget.dart';

class StationScada extends StatefulWidget {
  Passphrases passphrases;
  StationScada({
    Key? key,
    required this.passphrases,
  }) : super(key: key);

  @override
  State<StationScada> createState() => _StationScadaState();
}

class _StationScadaState extends State<StationScada> {
  @override
  Widget build(BuildContext context) {
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
              // MyAppBar(
              //   title: '',
              //   noti: notifications['unread'],
              //   onPress: () async {
              //     await Get.to(NotificationList());
              //     _getNotificationList();
              //   },
              // ),
              contentView()
            ],
          ),
        ),
      ),
    );
  }

  Widget contentView() {
    return Column(
      children: [
        Container(
          height: 70,
          alignment: Alignment.topCenter,
          child: NavigateBar.NavBarWithNotebook(
              context, 'การเปิด-ปิดอุปกรณ์ระยะไกล', () {
            Get.back();
          }),
        ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            SizedBox(
                width: 50,
                height: 50,
                child: Image.asset('asset/images/iconintro.png')),
            TextWidget.textSubTitleBold('การเปิด - ปิดอุปกรณ์ระยะไกล'),
            // TextWidget.textSubTitleBold('ศูนย์บำบัดน้ำ')
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        widget.passphrases.passphrase.isNotEmpty
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(child: Text('No Station')))
            : SizedBox(
                // width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: widget.passphrases.passphrase.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListItemWidget.cardListStationScada(
                          context, widget.passphrases.passphrase[index].name,
                          () {
                        // Get.to(Scada(
                        //   passphrase: widget.passphrases.passphrase[index],
                        // ));
                      });
                    }),
              ),
      ],
    );
  }
}
