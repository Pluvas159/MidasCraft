
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:midascraft/widgets/hlasovanie/hlasovanie.dart';
import 'package:midascraft/util/htmlview.dart';
import 'package:midascraft/widgets/loading/loading.dart';
import 'package:midascraft/navigation/midas_navigator.dart';
import 'package:midascraft/util/webview.dart';
import 'package:midascraft/widgets/nastavenia/nastavenia.dart';



void main() async {
  runApp(const MidasCraft());
}

class MidasCraft extends StatelessWidget {
  const MidasCraft({Key? key}) : super(key: key);
  static final GlobalKey<NavigatorState> materialKey = GlobalKey<NavigatorState>();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MidasCraft',
      navigatorKey: MidasCraft.materialKey,
      theme: ThemeData(
        primarySwatch: Colors.red,
        canvasColor: ColorScheme.dark().background,
        textTheme: ThemeData.dark().textTheme


      ),
      initialRoute: Load.route,
      routes: <String, WidgetBuilder> {
        Load.route : (BuildContext context) => const Load(),
        MidasNavigator.route : (BuildContext context) => MidasNavigator(),
        Hlasovanie.route : (BuildContext context) => Hlasovanie(),
        MidasWebView.route : (BuildContext context) => MidasWebView(),
        Nastavenia.route : (BuildContext context) => Nastavenia(),
        HtmlView.route : (BuildContext context) => HtmlView(),
        //Forum.route: (BuildContext context ) => Forum()
      }
    );
  }
}



