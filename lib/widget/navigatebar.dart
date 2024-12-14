import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wma_app/view/notification/notificationlist.dart';

class NavigateBar {
  static Widget NavBar(
      BuildContext context, String title, GestureTapCallback onBack,) {
    return Container(
      color: Colors.transparent,
      child: Padding(
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
                      'asset/images/arrow_left_n.png',
                    ),
                    onPressed: onBack,
                  ),
                )),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget NavBarWithNotification(
      BuildContext context, String title, GestureTapCallback onBack,String role) {
    return Container(
      color: Colors.transparent,
      child: Padding(
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
                      'asset/images/arrow_back.png',
                    ),
                    onPressed: onBack,
                  ),
                )),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
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
                          onPressed: () {
                            Get.to(NotificationList(role:role ,));
                          }),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  static Widget NavBarWithNotebook(
      BuildContext context, String title, GestureTapCallback onBack) {
    return Container(
      color: Colors.transparent,
      child: Padding(
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
                      'asset/images/arrow_left_n.png',
                    ),
                    onPressed: onBack,
                  ),
                )),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),
            // Align(
            //     alignment: Alignment.centerRight,
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         Theme(
            //           data: Theme.of(context).copyWith(
            //             highlightColor: Colors.transparent,
            //             splashColor: Colors.transparent,
            //             hoverColor: Colors.transparent,
            //           ),
            //           child: IconButton(
            //               style: ElevatedButton.styleFrom(
            //                 splashFactory: NoSplash.splashFactory,
            //               ),
            //               icon: Image.asset(
            //                 'asset/images/notebook.png',
            //               ),
            //               onPressed: () {}),
            //         )
            //       ],
            //     )),
          ],
        ),
      ),
    );
  }

  static Widget NavBarHome(
      BuildContext context, String title, GestureTapCallback onBack) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Align(
            //     alignment: Alignment.centerLeft,
            //     child: Theme(
            //       data: Theme.of(context).copyWith(
            //         highlightColor: Colors.transparent,
            //         splashColor: Colors.transparent,
            //         hoverColor: Colors.transparent,
            //       ),
            //       child: IconButton(
            //         style: ElevatedButton.styleFrom(
            //           splashFactory: NoSplash.splashFactory,
            //         ),
            //         icon: Image.asset(
            //           'asset/images/arrow_back.png',
            //         ),
            //         onPressed: onBack,
            //       ),
            //     )),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
