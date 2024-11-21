// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:wma_app/model/user.dart';

import '../../Utils/Color.dart';
import '../../api/ContactRequest.dart';
import '../../model/station.dart';
import '../../widget/dropdown/dropdown.dart';
import '../../widget/list_item_widget.dart';
import '../../widget/navigatebar.dart';
import '../../widget/text_widget.dart';

class ContactView extends StatefulWidget {
  Station station;
  ContactView({
    Key? key,
    required this.station,
  }) : super(key: key);

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var accessToken = '';

  List<dynamic> data = [];

  Future<void> _getContact() async {
    data.clear();
    final SharedPreferences prefs = await _prefs;
    accessToken = (prefs.getString('access_token') ?? '');
    var result =
        await Contact.getStationContact(accessToken, '${widget.station.id}');
    print(result['data']['contact'][0]);
    List<dynamic> dataTel = result['data']['contact'];
    for (var i = 0; i < dataTel.length; i++) {
      if (dataTel[i]['OPERATOR'] != null) {
        data.add({'title': 'เจ้าหน้าที่ตรวจสอบคุณภาพน้ำ', 'mode': 'title'});
        List<dynamic> temp = dataTel[i]['OPERATOR'];
        for (var i = 0; i < temp.length; i++) {
          data.add({
            'phone_number': '${temp[i]['phone_number']}',
            'mode': 'content'
          });
        }
      }

      if (dataTel[i]['MANAGER'] != null) {
        data.add({'title': 'ผู้จัดการ', 'mode': 'title'});
        List<dynamic> temp = result['data']['contact'][i]['MANAGER'];
        for (var i = 0; i < temp.length; i++) {
          data.add({
            'phone_number': '${temp[i]['phone_number']}',
            'mode': 'content'
          });
        }
      }

      if (dataTel[i]['OFFICER'] != null) {
        data.add({'title': 'ส่วนกลาง', 'mode': 'title'});
        List<dynamic> temp = result['data']['contact'][i]['OFFICER'];
        for (var i = 0; i < temp.length; i++) {
          data.add({
            'phone_number': '${temp[i]['phone_number']}',
            'mode': 'content'
          });
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
    _getContact();
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
                    const ImageIcon(AssetImage('asset/images/bi_journals.png')),
                    TextWidget.textTitle('ข้อมูลการติดต่อ'),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextWidget.textTitle(widget.station.name),
                  ),
                ),
                // DropDown.dropdownButton(context, dropdownshow, () async {
                //   ContactStation result = await Get.to(DropDownSelect(
                //     contactStation: contactStation,
                //   ));

                //   setState(() {
                //     dropdownshow = result.name;
                //     selectId = result.id;
                //     _getContact();
                //   });
                // }),
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
              context, '${data[index]['title']}', orangeHeader);
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
