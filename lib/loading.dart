import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:midascraft/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Load extends StatefulWidget {
  const Load({Key? key}) : super(key: key);

  static const String route = "/";

  @override
  State<Load> createState() => LoadState();

}

class LoadState extends State<Load>{
  String imageUrl = 'https://midascraft.sk/';
  static late dom.Document document;
  static late Image headerImage;
  static late List<dom.Element> articles;
  static List<Image> articleImages = [];
  static var prefs;

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _getDOM();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  <Widget>[
                const Image(image: AssetImage('assets/midascraft.png'), height: 150, alignment: Alignment.center,),
                Text("MidasCraft", style: const TextTheme().headline1, textScaleFactor: 2,),
                Divider(height: 400, color: const ColorScheme.dark().background,),
                const CircularProgressIndicator(color: Colors.red,),
                ]
      )
    )
    );
  }

  static dom.Document getDocument() {
    return document;
  }
  static List<dom.Element> getArticles() {
    return articles;
  }

  _getDOM() async {
    final response = await http.get(Uri.parse('https://midascraft.sk/'));
    if(response.statusCode == 200){
    document = parser.parse(response.body);
    headerImage = Image.network(document.getElementsByTagName("img")[0].attributes['src'].toString());
    articles = document.getElementsByTagName("article");
    for( dom.Element article in articles ) {
      articleImages.add(Image.network(
          article.children[0].children[0].attributes["src"].toString()));
    }
    prefs = await SharedPreferences.getInstance();

    if (document!=null){
      Navigator.of(context).pushReplacementNamed(MainScreen.route);
   }
    } else {
      throw NullThrownError();
    }
  }
}