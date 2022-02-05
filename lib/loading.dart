import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:midascraft/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'notifications/notifications_api.dart';

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
  static final notifications =  NotificationApi();
  static List<dom.Element> newArticles = [];
  static List<dom.Element> oldArticles = [];

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _getDOM();
    notifications.initialize();
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
    headerImage = Image.network(document.getElementsByTagName("img")[0].attributes['src'].toString(),
        frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child;
          }
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut,
            child: child,
          );
        },
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    articles = document.getElementsByTagName("article");

    prefs = await SharedPreferences.getInstance();
    await getNextVotes();

    if (document!=null){
    for( dom.Element article in articles ) {
      String url = article.children[0].children[0].attributes["src"].toString();
      if (url!="null"){
        newArticles.add(article);
        articleImages.add(Image.network(url));
    } else {
        url = article.children[0].children[0].children[0].attributes["src"].toString();
        oldArticles.add(article);
        articleImages.add(Image.network(url));
      }
    }
    if (articleImages.length==8) {Navigator.of(context).pushReplacementNamed(MainScreen.route);}
   }
    } else {
      throw NullThrownError();
    }
  }

  static getNextVotes() async {
    final czech_craft = "https://czech-craft.eu/api/server/midascraft/player/${prefs.getString("voteName")}/next_vote/";
    final response = await http.get(Uri.parse(czech_craft));
    if(response.statusCode == 200){final String next_vote = jsonDecode(response.body)['next_vote'];
        notifications.send_timed_notification("Hlasovanie",
            "Hlas pre czech-craft(${prefs.getString(
                "voteName")}) je znova mozny", DateTime.parse(next_vote));

    } else {
      throw Exception("Can't fetch votes");
    }
  }
}