import 'package:flutter/material.dart';

class NavigateBar {
  static Widget NavBar(
      BuildContext context, String title, GestureTapCallback onBack) {
    return Container(
      color: Colors.white,
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
          ],
        ),
      ),
    );
  }

  static Widget NavBarWithNotification(
      BuildContext context, String title, GestureTapCallback onBack) {
    return Container(
      color: Colors.white,
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
                          onPressed: () {}),
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
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(3, 0), // changes position of shadow
          ),
          const BoxShadow(color: Colors.white, offset: Offset(0, -16)),
        ],
      ),
      // color: Colors.white,
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
                            'asset/images/notebook.png',
                          ),
                          onPressed: () {}),
                    )
                  ],
                )),
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
