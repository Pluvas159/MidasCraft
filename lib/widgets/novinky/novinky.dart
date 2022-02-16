import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:midascraft/util/WebRouteParams.dart';
import 'package:midascraft/util/midas_colors.dart';
import 'package:midascraft/util/yt_player.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../util/htmlview.dart';
import '../loading/loading.dart';

/// This is the stateless widget that the main application instantiates.
class Novinky extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  static const String route = "/novinky";
  String yt_link = LoadState.document
      .getElementsByClassName("wp-video")[0]
      .getElementsByTagName("a")[0]
      .attributes["href"]!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        body: CustomScrollView(
          slivers: <Widget>[
            MidasSliverAppBar(),
            MidasSliverText("Novinky", 2, Alignment.center),
            SliverToBoxAdapter(child: newArticlesWidget()),
            MidasSliverText("Najnovšie video", 1.5, Alignment.center),
            SliverToBoxAdapter(
              child: Container(
                  margin: EdgeInsets.all(8),
                  child: YtPlayer(
                      url: yt_link.substring(yt_link.indexOf("be/") + 3))),
            ),
            MidasSliverText("Staršie novinky", 1.5, Alignment.center),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return oldArticle(LoadState.oldArticles[index], index, context);
              }, childCount: LoadState.oldArticles.length),
            )
          ],
        ),
    );
  }
}

Widget MidasSliverText(String text, double height, Alignment textAlign) {
  return SliverToBoxAdapter(
    child: Column(children: [
      Container(
          alignment: textAlign,
          margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Text(text,
              textScaleFactor: height,
              style: TextStyle(fontWeight: FontWeight.bold))),
      Divider(
        color: MidasColors.darkRed,
        thickness: 2,
      )
    ]),
  );
}

Widget MidasSliverAppBar() {
  return SliverAppBar(
      title: const Text('MidasCraft'),
      pinned: true,
      backgroundColor: Color(0xff330000),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          "assets/midascraft.png",
        ),
      ),
      );
}

Widget oldArticle(dom.Element article, int index, context) {
  List<dom.Element> articles = LoadState.oldArticles;
  String title = article.children[0].children[0].attributes["title"].toString();
  return Column(children: [
    Divider(),
    InkWell(
      child: Container(
          margin: EdgeInsets.all(8),
          child: Column(children: [
            LoadState.articleImages[index + 3],
            Divider(),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: 5),
              child: Text(
                title,
                textScaleFactor: 1.2,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 5),
                child: Text(
                  article.getElementsByTagName("p")[0].text,
                  textAlign: TextAlign.center,
                )),
          ])),
      onTap: () => Navigator.of(context).pushNamed(HtmlView.route,
          arguments: WebRouteParams(
              title,
              article
                  .getElementsByTagName("a")[0]
                  .attributes["href"]
                  .toString(),
              type: "article")),
    ),
    Divider(
      color: Colors.red,
    )
  ]);
}

Widget newArticlesWidget() {
  final PageController ctrl =
      PageController(initialPage: 0, viewportFraction: .9);

  return Container(
      height: 285,
      child: PageView.builder(
        controller: ctrl,
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return _homeRow(LoadState.getArticles()[index], context, index);
        },
      ));
}

Widget _homeRow(dom.Element article, BuildContext context, int index) {
  return InkWell(
    child: Container(
      margin: EdgeInsets.all(10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LoadState.articleImages[index],
            Container(
                margin: EdgeInsets.all(8),
                child: Text(
                  article.children[0].attributes["title"].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.1,
                )),
            Container(
                margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Text(
                  article.children[1].children[0].children[1].children[0]
                      .children[0].text,
                  style: TextTheme().caption,
                  textScaleFactor: .9,
                )),
          ]),
      decoration: BoxDecoration(
          color: Colors.white10,
          border: Border(bottom: BorderSide(color: MidasColors.darkRed))),
    ),
    onTap: () => Navigator.of(context).pushNamed(HtmlView.route,
        arguments: WebRouteParams(
            article.children[0].attributes['title'].toString(),
            article.children[0].attributes["href"].toString(),
            type: "article")),
  );
}

_launchURL(_url) async {
  if (!await launch(_url)) throw 'Could not launch $_url';
}
