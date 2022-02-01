import 'dart:async';
import 'package:midascraft/util/WebRouteParams.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MidasWebView extends StatefulWidget {
  const MidasWebView({Key? key}) : super(key: key);

  static const String route = "/view";

  @override
  MidasWebViewState createState() => MidasWebViewState();
}

class MidasWebViewState extends State<MidasWebView> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  bool isLoading = true;


  @override
  Widget build(BuildContext context) {
    final Params = ModalRoute.of(context)!.settings.arguments as WebRouteParams;
    return Scaffold(
        appBar: AppBar(
          title: Text(Params.title),
          backgroundColor: Color(0xff330000),
          actions: [
            isLoading
                ? Center(
                    child: Container(
                        margin: EdgeInsets.only(right: 25),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )))
                : Text("")
          ],
        ),
        body: Builder(builder: (BuildContext context) {
          return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: WebView(
                initialUrl: Params.url,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController controller) {
                  _controller.complete(controller);
                },
                onPageFinished: (finish) {
                  setState(() {
                    isLoading = false;
                  });
                },
                onPageStarted: (start) {
                  setState(() {
                    isLoading = true;
                  });
                },
              ));
        }));
  }
}
