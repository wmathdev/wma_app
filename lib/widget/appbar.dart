import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wma_app/Utils/Color.dart';
import 'package:wma_app/view/notification/notificationlist.dart';
import 'package:wma_app/widget/text_widget.dart';

import '../api/Authentication.dart';

class MyAppBar extends StatelessWidget {
  final String title;
  final int noti;
  final onPress;

  static const double kToolbarHeight = 110.0;

  MyAppBar({super.key, this.title = "", required this.noti, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Theme(
                data: Theme.of(context).copyWith(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                ),
                child: IconButton(
                  style: ElevatedButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  icon: Image.asset(
                    'asset/images/logout.png',
                  ),
                  onPressed: () {
                    showAlertDialog(context);
                  },
                ),
              )),
          Center(
            child: Text(
              this.title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    alignment: Alignment.center,
                    child: TextWidget.textTitleBoldWithColor(
                        '$noti', Colors.white),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                    ),
                    child: IconButton(
                        style: ElevatedButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                        ),
                        icon: Image.asset(
                          'asset/images/bi_bell.png',
                        ),
                        onPressed: this.onPress),
                  )
                ],
              )),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () async {
        var auth = prefs.getString('access_token');
        print('auth : $auth');
        var result = await Authentication.logout(auth!);

        await prefs.setString('access_token', '');
        await prefs.setString('user', '');
        print(result.toString());
        Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
      },
    );

    Widget calcelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("เเจ้งเตือน"),
      content: Text("คุณต้องการออกจากระบบ"),
      actions: [okButton, calcelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
