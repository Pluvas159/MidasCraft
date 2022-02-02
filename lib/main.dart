
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:midascraft/hlasovanie.dart';
import 'package:midascraft/htmlview.dart';
import 'package:midascraft/loading.dart';
import 'package:midascraft/settings.dart';
import 'package:midascraft/util/WebRouteParams.dart';
import 'package:midascraft/webview.dart';

import 'forum/forum.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MidasCraft',
      theme: ThemeData(
        primarySwatch: Colors.red,
        canvasColor: ColorScheme.dark().background,
        textTheme: ThemeData.dark().textTheme


      ),
      initialRoute: Load.route,
      routes: <String, WidgetBuilder> {
        Load.route : (BuildContext context) => const Load(),
        MainScreen.route : (BuildContext context) => MainScreen(),
        Hlasovanie.route : (BuildContext context) => Hlasovanie(),
        MidasWebView.route : (BuildContext context) => MidasWebView(),
        Settings.route : (BuildContext context) => Settings(),
        HtmlView.route : (BuildContext context) => HtmlView(),
        Forum.route: (BuildContext context ) => Forum()
      }
    );
  }
}



