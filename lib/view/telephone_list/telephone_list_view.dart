import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/Color.dart';
import '../../api/ContactRequest.dart';
import '../../model/station.dart';
import '../../widget/dropdown/dropdown.dart';
import '../../widget/list_item_widget.dart';
import '../../widget/navigatebar.dart';
import '../../widget/text_widget.dart';
import 'dropdown_select.dart';

class TelephoneList extends StatefulWidget {
  const TelephoneList({super.key});

  @override
  State<TelephoneList> createState() => _TelephoneListState();
}

class _TelephoneListState extends State<TelephoneList> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var accessToken = '';

  List<ContactStation> contactStation = [];

  String dropdownshow = 'กรุณาเลือกศูนย์จัดการบริหารคุณภาพน้ำ';
  int selectId = -1;
  List<dynamic> data = [];

  Future<void> _getContactList() async {
    final SharedPreferences prefs = await _prefs;
    accessToken = (prefs.getString('access_token') ?? '');
    var result = await Contact.getAllStationList(accessToken);
    List<dynamic> data = result['data'];
    for (var i = 0; i < data.length; i++) {
      ContactStation temp =
          ContactStation(id: data[i]['id'], name: data[i]['name']);
      contactStation.add(temp);
    }
    setState(() {});
  }

  Future<void> _getContact() async {
    data.clear();
    final SharedPreferences prefs = await _prefs;
    accessToken = (prefs.getString('access_token') ?? '');
    var result = await Contact.getStationContact(accessToken, '$selectId');
    if (result['data']['contact'] != null) {
      List<dynamic> contact = result['data']['contact'];
      for (var i = 0; i < contact.length; i++) {
        if (result['data']['contact'][i]['MANAGER'] != null) {
          data.add({'title': 'ผู้จัดการ', 'mode': 'title'});
          List<dynamic> temp = result['data']['contact'][i]['MANAGER'];
          for (var i = 0; i < temp.length; i++) {
            data.add({
              'phone_number': '${temp[i]['phone_number']}',
              'mode': 'content'
            });
          }
        }

        if (result['data']['contact'][i]['OFFICER'] != null) {
          data.add({'title': 'เจ้าหน้าที่ส่วนกลาง', 'mode': 'title'});
          List<dynamic> temp = result['data']['contact'][i]['OFFICER'];
          for (var i = 0; i < temp.length; i++) {
            data.add({
              'phone_number': '${temp[i]['phone_number']}',
              'mode': 'content'
            });
          }
        }

        if (result['data']['contact'][i]['OPERATOR'] != null) {
          data.add({'title': 'เจ้าหน้าที่', 'mode': 'title'});
          List<dynamic> temp = result['data']['contact'][i]['OPERATOR'];
          for (var i = 0; i < temp.length; i++) {
            data.add({
              'phone_number': '${temp[i]['phone_number']}',
              'mode': 'content'
            });
          }
        }

        if (result['data']['contact'][i]['ADMIN'] != null) {
          data.add({'title': 'เจ้าหน้าที่แอดมิน', 'mode': 'title'});
          List<dynamic> temp = result['data']['contact'][i]['ADMIN'];
          for (var i = 0; i < temp.length; i++) {
            data.add({
              'phone_number': '${temp[i]['phone_number']}',
              'mode': 'content'
            });
          }
        }
      }
    }

    print(data);
    setState(() {});

    // print(result['data']['contact']);
    // setState(() {
    //   data = result['data']['contact'];
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getContactList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        color: Colors.white,
        child: contentView(),
      ),
    ));
  }

  Widget contentView() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                Row(
                  children: [
                    const ImageIcon(
                        AssetImage('asset/images/bi_journals.png')),
                    TextWidget.textTitle('ข้อมูลการติดต่อทั้งหมด'),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextWidget.textTitle('ศูนย์จัดการบริหารคุณภาพน้ำ'),
                  ),
                ),
                DropDown.dropdownButton(context, dropdownshow, () async {
                  ContactStation result = await Get.to(DropDownSelect(
                    contactStation: contactStation,
                  ));

                  setState(() {
                    dropdownshow = result.name;
                    selectId = result.id;
                    _getContact();
                  });
                }),
                listView()
              ],
            ),
          ),
        ),
        Container(
          height: 80,
          alignment: Alignment.topCenter,
          child: NavigateBar.NavBar(context, 'ข้อมูลการติดต่อทั้งหมด', () {
            Get.back();
          }),
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
        if (data[index]['mode'] == 'title') {
          return ListItemWidget.telephoneHeader(
              context, '${data[index]['title']}', Colors.blue[100]!);
        }
        return ListItemWidget.telephoneItem(
            context, '${data[index]['phone_number']}', Colors.white, () async {
          await _makePhoneCall(data[index]['phone_number']);
        });
      },
    );
  }


  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
