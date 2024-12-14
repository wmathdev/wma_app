// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:wma_app/model/user.dart';
import 'package:wma_app/widget/navigatebar.dart';
import 'package:wma_app/widget/text_widget.dart';

class ScadaPage extends StatefulWidget {
  String name;
  String url;

  ScadaPage({
    Key? key,
    required this.name,
    required this.url,
  }) : super(key: key);

  @override
  State<ScadaPage> createState() => _ScadaPageState();
}

class _ScadaPageState extends State<ScadaPage> {
  late final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {
          print('URLWMA : $url');
        },
        onPageFinished: (String url) {
          print('URLWMA : $url');
        },
        onHttpError: (HttpResponseError error) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    //..loadRequest(Uri.parse('https://allmcl.com/login?id=0X/wopVsHYDohlAoX3MZopI6449CQranXG7qWPK/d42Jmji26xZkgnzkohizuIZAmOVW4QqwXvVq3B8X4eMflw=='));
    ..loadRequest(Uri.parse(widget.url));

  @override
  Widget build(BuildContext context) {
    print('object url ${widget.url}');
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            NavigateBar.NavBar(context, '', () {
              Get.back();
            }),
            contentView()
          ],
        ),
      ),
    );
  }

  Widget contentView() {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset('asset/images/iconintro.png')),
              Expanded(child: TextWidget.textSubTitleBoldMedium(widget.name))
            ],
          ),
          Container(
              margin: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.68,
              child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: WebViewWidget(controller: controller))))
        ]));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title:  Text(widget.name)),
  //     body: WebViewWidget(controller: controller),
  //   );
  // }
}
