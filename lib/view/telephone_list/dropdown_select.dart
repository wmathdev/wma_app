// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../model/station.dart';
import '../../widget/list_item_widget.dart';
import '../../widget/text_widget.dart';

class DropDownSelect extends StatefulWidget {
  List<ContactStation> contactStation;

  DropDownSelect({
    Key? key,
    required this.contactStation,
  }) : super(key: key);

  @override
  State<DropDownSelect> createState() => _DropDownSelectState();
}

class _DropDownSelectState extends State<DropDownSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('เลือกศูนย์บริหารจัดการคุณภาพ')),
        body: SafeArea(
          child: Center(
            child: Stack(
              children: [
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
                ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: widget.contactStation.length,
                    itemBuilder: (BuildContext context, int index) {
                      // if (index == 0) {
                      //   return Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Center(child: TextWidget.textSubTitle('เลือกศูนย์บริหารจัดการคุณภาพ')),
                      //   );
                      // }
                
                      return ListItemWidget.cardList(
                          context, widget.contactStation[index].name, () {
                        Navigator.pop(context, widget.contactStation[index]);
                      });
                    }),
              ],
            ),
          ),
        ));
  }
}
