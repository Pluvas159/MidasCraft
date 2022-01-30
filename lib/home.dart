import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:midascraft/drawer.dart';
import 'package:midascraft/util/WebRouteParams.dart';
import 'package:url_launcher/url_launcher.dart';

import 'loading.dart';

/// This is the stateless widget that the main application instantiates.
class MainScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  static const String route = "/novinky";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
                title: const Text('MidasCraft'),
                expandedHeight: 200.0,
                pinned: true,
                backgroundColor: Color(0xff330000),
                actions: [IconButton(onPressed: () => _key.currentState!.openEndDrawer(), icon: Icon(Icons.menu))],
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/midascraft.png",
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: FittedBox(
                    fit: BoxFit.fill,
                    child: ClipRect(
                      child: Container(
                        child: Align(
                          alignment: const Alignment(0.5, 0),
                          heightFactor: 1,
                          widthFactor: 0.5,
                          child:
                              LoadState.headerImage,
                        ),
                      ),
                    ),
                  ),
                )),
            SliverToBoxAdapter(
              child: Column(children: [
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Text("Novinky",
                        textScaleFactor: 2,
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Divider(
                  color: Colors.red,
                  thickness: 2,
                )
              ]),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.all(25.0),
                    child: _homeRow(LoadState.getArticles()[index], context, index),
                  );
                },
                childCount: 3,
              ),
            ),
          ],
        ),
        endDrawer: MidasDrawer() );
  }
}

Widget _homeRow(dom.Element article, BuildContext context, int index) {
  return InkWell(
    child: Container(
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
          border: Border(bottom: BorderSide(color: Colors.red))),
    ),
    onTap: () => Navigator.of(context).pushNamed('/view', arguments: WebRouteParams("Novinky", article.children[0].attributes["href"].toString())),
  );
}

_launchURL(_url) async {
  if (!await launch(_url)) throw 'Could not launch $_url';
}
