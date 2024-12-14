import 'package:flutter/material.dart';

class MyDialog {
  static showAlertDialogOk(BuildContext context, String message,
      GestureTapCallback onOkPressed) async {
    Widget okButton = TextButton(child: Text("OK"), onPressed: onOkPressed);

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("เเจ้งเตือน"),
      content: Text(message),
      actions: [okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

      static showPermissionDialogOk(BuildContext context, String message,
          GestureTapCallback onOkPressed, GestureTapCallback onDenyPressed) async {
        Widget acceptButton =
            TextButton(child: Text("Accept"), onPressed: onOkPressed);

        Widget denyButton =
            TextButton(child: Text("Deny"), onPressed: onDenyPressed);

        // set up the AlertDialog
        AlertDialog alert = AlertDialog(
          title: Text("การเข้าถึงตำแหน่ง"),
          content: Text(message),
          actions: [denyButton, acceptButton],
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
